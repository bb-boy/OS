BUILD_DIR = ./build
ENTRY_POINT = 0xc0002500
AS = nasm 
CC = gcc 
LD = ld
LIB = -I lib/ -I lib/kernel/ -I lib/kernel/user/ -I device
ASFLAGS = -f elf
CFLAGS = -no-pie -fno-pic -fno-stack-protector -m32 -Wall $(LIB) -c -fno-builtin -W -Wstrict-prototypes -Wmissing-prototypes
LDFLAGS = -Ttext $(ENTRY_POINT) -e main -m elf_i386 -Map $(BUILD_DIR)/kernel.map 
OBJS = $(BUILD_DIR)/main.o \
	   $(BUILD_DIR)/interrupt.o \
	   $(BUILD_DIR)/print.o \
	   $(BUILD_DIR)/init.o \
	   $(BUILD_DIR)/timer.o \
	   $(BUILD_DIR)/kernel.o \
	   $(BUILD_DIR)/debug.o \

$(BUILD_DIR)/main.o:kernel/main.c lib/kernel/print.h \
	lib/stdint.h kernel/init.h kernel/debug.h
	$(CC) $(CFLAGS)  $< -o $@       
#$<代表第一个依赖文件，$@代表目标文件，这里把.h文件也作为依赖是由于.h文件如果修改，就要重新编译main.c文件

$(BUILD_DIR)/init.o:kernel/init.c kernel/init.h \
	lib/kernel/print.h lib/stdint.h kernel/interrupt.h \
	device/timer.h
	$(CC) $(CFLAGS)  $< -o $@

$(BUILD_DIR)/interrupt.o:kernel/interrupt.c kernel/interrupt.h \
	lib/kernel/print.h lib/stdint.h kernel/global.h ./lib/kernel/io.h
	$(CC) $(CFLAGS)  $< -o $@

$(BUILD_DIR)/timer.o:device/timer.c device/timer.h \
	lib/kernel/print.h lib/stdint.h lib/kernel/io.h
	$(CC) $(CFLAGS)  $< -o $@

$(BUILD_DIR)/debug.o:kernel/debug.c kernel/debug.h \
	lib/kernel/print.h kernel/interrupt.h
	$(CC) $(CFLAGS)  $< -o $@


$(BUILD_DIR)/kernel.o:kernel/kernel.S lib/kernel/print.h
	$(AS) $(ASFLAGS) $< -o $@
	

$(BUILD_DIR)/print.o:lib/kernel/print.S
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD_DIR)/kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) $^ -o $@ 

.PHONY:mk_dir clean all 
mk_dir:
	@if [ ! -d $(BUILD_DIR) ]; then mkdir $(BUILD_DIR); fi

clean:
	cd $(BUILD_DIR) && rm -rf ./*

build:$(BUILD_DIR)/kernel.bin

all:mk_dir build 