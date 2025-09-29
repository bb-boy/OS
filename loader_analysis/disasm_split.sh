#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <path-to-config>" >&2
  exit 1
fi

config_input="$1"
if [[ ! -f "$config_input" ]]; then
  echo "Config file '$config_input' not found" >&2
  exit 1
fi

if command -v readlink >/dev/null 2>&1; then
  config_path="$(readlink -f "$config_input")"
else
  config_path="$(python3 - <<'PY'
import os, sys
print(os.path.abspath(sys.argv[1]))
PY
"$config_input")"
fi
config_dir="$(dirname "$config_path")"

# shellcheck disable=SC1090
source "$config_path"

cd "$config_dir"

binary_path="$BINARY_FILE"
if [[ ! -f "$binary_path" ]]; then
  echo "Binary '$binary_path' not found relative to $config_dir" >&2
  exit 1
fi

output_dir="$OUTPUT_DIR"
mkdir -p "$output_dir"

load_addr=$((LOAD_ADDR))
real_start=$((REAL_MODE_START))
real_end=$((REAL_MODE_END))
data_start=$((DATA_START))
data_end=$((DATA_END))
mode_switch=$((MODE_SWITCH))
prot_start=$((PROT_MODE_START))

file_size=$(wc -c < "$binary_path")

if (( file_size <= 0 )); then
  echo "Binary '$binary_path' is empty" >&2
  exit 1
fi

to_offset() {
  local value=$1
  echo $(( value - load_addr ))
}

clamp_start() {
  local value=$1
  if (( value < 0 )); then
    value=0
  fi
  echo "$value"
}

clamp_stop() {
  local value=$1
  if (( value > file_size )); then
    value=$file_size
  fi
  echo "$value"
}

real_start_off=$(clamp_start "$(to_offset "$real_start")")
prot_start_off=$(clamp_start "$(to_offset "$prot_start")")

real_before_stop_off=$(clamp_stop "$(to_offset "$data_start")")
if (( real_before_stop_off < real_start_off )); then
  real_before_stop_off=$real_start_off
fi

raw_data_stop=$(( data_end - load_addr + 1 ))
if (( raw_data_stop < 0 )); then
  raw_data_stop=0
fi
data_start_off=$(clamp_start "$(to_offset "$data_start")")
data_stop_off=$(clamp_stop "$raw_data_stop")
if (( data_stop_off < data_start_off )); then
  data_stop_off=$data_start_off
fi

data_length=$(( data_stop_off - data_start_off ))

real_tail_start_off=$data_stop_off
if (( real_tail_start_off < real_start_off )); then
  real_tail_start_off=$real_start_off
fi

real_tail_stop_off=$(clamp_stop "$prot_start_off")
if (( real_tail_stop_off < real_tail_start_off )); then
  real_tail_stop_off=$real_tail_start_off
fi

prot_stop_off=$file_size
if (( prot_stop_off < prot_start_off )); then
  prot_start_off=$prot_stop_off
fi

real_out="$output_dir/real_mode.asm"
prot_out="$output_dir/protected_mode.asm"
data_out="$output_dir/data_dump.txt"
summary_out="$output_dir/summary.txt"
symbol_map_out="$output_dir/symbols.map"

: > "$real_out"
: > "$prot_out"
: > "$summary_out"
: > "$symbol_map_out"

segment_summary() {
  local name=$1 start_off=$2 stop_off=$3
  local start_addr=$(( load_addr + start_off ))
  local end_addr=$(( load_addr + stop_off - 1 ))
  if (( stop_off <= start_off )); then
    printf "%s: (empty)\n" "$name" >> "$summary_out"
    return
  fi
  printf "%s: file[0x%X-0x%X) addr[0x%X-0x%X]\n" \
    "$name" "$start_off" "$stop_off" "$start_addr" "$end_addr" >> "$summary_out"
}

dump_disasm() {
  local label=$1 arch=$2 start_off=$3 stop_off=$4 out_file=$5
  if (( stop_off <= start_off )); then
    return
  fi
  local start_addr=$(( load_addr + start_off ))
  local end_addr=$(( load_addr + stop_off - 1 ))
  local stop_addr=$(( end_addr + 1 ))
  {
    printf ";; ===== %s =====\n" "$label"
    printf ";; file offset: 0x%X - 0x%X\n" "$start_off" "$stop_off"
    printf ";; addresses: 0x%X - 0x%X\n" "$start_addr" "$end_addr"
    objdump -D -b binary -m "$arch" --adjust-vma="$load_addr" \
      --start-address="$start_addr" --stop-address="$(( stop_addr - 1 ))" \
      "$binary_path"
    printf '\n'
  } >> "$out_file"
}

segment_summary "real_mode_head" "$real_start_off" "$real_before_stop_off"
segment_summary "real_mode_tail" "$real_tail_start_off" "$real_tail_stop_off"
segment_summary "protected_mode" "$prot_start_off" "$prot_stop_off"
segment_summary "data" "$data_start_off" "$data_stop_off"
printf "mode_switch: 0x%X\n" "$mode_switch" >> "$summary_out"
printf "real_mode_end: 0x%X\n" "$real_end" >> "$summary_out"

if (( real_before_stop_off > real_start_off )); then
  dump_disasm "Real mode (before data)" "i8086" "$real_start_off" "$real_before_stop_off" "$real_out"
fi
if (( real_tail_stop_off > real_tail_start_off )); then
  dump_disasm "Real mode (after data)" "i8086" "$real_tail_start_off" "$real_tail_stop_off" "$real_out"
fi
if (( prot_stop_off > prot_start_off )); then
  dump_disasm "Protected mode" "i386" "$prot_start_off" "$prot_stop_off" "$prot_out"
fi

if (( data_length > 0 )); then
  python3 - "$binary_path" "$data_start_off" "$data_length" "$(( load_addr + data_start_off ))" <<'PY' > "$data_out"
import sys
from textwrap import wrap

binary, start_off, length, base_addr = sys.argv[1:]
start_off = int(start_off)
length = int(length)
base_addr = int(base_addr)

with open(binary, 'rb') as f:
    f.seek(start_off)
    blob = f.read(length)

for row_start in range(0, len(blob), 16):
    chunk = blob[row_start:row_start + 16]
    addr = base_addr + row_start
    hex_bytes = ' '.join(f'{b:02X}' for b in chunk)
    hex_bytes = hex_bytes.ljust(47)
    ascii_repr = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
    print(f'{addr:08X}: {hex_bytes} |{ascii_repr}|')
PY
else
  echo "<empty>" > "$data_out"
fi

if declare -p SYMBOLS >/dev/null 2>&1; then
  for entry in "${SYMBOLS[@]}"; do
    addr="${entry%%:*}"
    name="${entry##*:}"
    printf "%s %s\n" "$addr" "$name" >> "$symbol_map_out"
  done
fi

echo "Disassembly written to:"
echo "  $real_out"
echo "  $prot_out"
echo "  $data_out"
echo "  $summary_out"
echo "  $symbol_map_out"
