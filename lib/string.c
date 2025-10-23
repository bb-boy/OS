#include  "string.h"
#include "global.h"
#include "debug.h"

/*将dst起始的size个字节置为value*/
void memset(void* dst_,uint8_t value,uint32_t size){
    ASSERT(dst_ != NULL);
    uint8_t* dst = (uint8_t*)dst_;
    while(size-- >0){
        *dst++ = value;
    }
}

/*将src起始的size个字节复制到dst*/
void memcopy(void* dst_,const void* src_,uint32_t size){
    ASSERT(dst_ != NULL && src_ != NULL);
    uint8_t* dst = (uint8_t*)dst_;//声明一个4字节指向uint8_t的指针，方便后续的指针运算
    const uint8_t* src = (const uint8_t*)src_;
    while(size-- >0){
        *dst++ = *src++;
    }
}

/*比较内存*/
int8_t memcmp(const void* a_,const void* b_,uint32_t size){
    const char* a = a_;  //这里使用const修饰，表示指针指向的数据不可被修改
    const char* b = b_;
    ASSERT(a_ != NULL || b_ != NULL);
    while(size-- >0){
        if(*a != *b){
            return *a < *b ? -1:1;
        }
        a++;
        b++;
    }
    return 0;
}


/*将字符串从src复制到dst*/
char* strcpy(char* dst_,const char* src_){
    ASSERT(dst_ != NULL && src_ != NULL);
    char* r = dst_;  //保存dst的起始地址
    while((*dst_++ = *src_++) != 0);//这里是运算符的优先级，*先解引用，再进行赋值，*src_和'\0'最后进行比较
    return r;
}


/*返回字符串长度*/
uint32_t strlen(const char* str){
    ASSERT(str != NULL);
    const char* p = str;
    while(*p++);
    return (p - str -1);//减去字符串结束符'\0'
}


/*比较两个字符串，若a_<b_则返回-1，若a_>b_则返回1，若相等则返回0*/
int8_t strcmp(const char* a_, const char* b_){
    ASSERT(a_ != NULL && b_ != NULL);
    while((*a_ != 0) && (*a_ != *b_)){
       
        a_++;
        b_++;
    }
    if(*a_ == *b_){
        return 0;
    }else if(*a_ < *b_){
        return -1;
    }else{
        return 1;
    }
}


/*从左到右查找字符c在字符串中的位置，若找到则返回位置，若未找到则返回null*/
char* strchr(const char* str, const uint8_t c){
    ASSERT(str != NULL);
    while(*str != 0){
        if(*str == c){
            return (char*)str;
        }
        str++;
    }
    return NULL;
}

/*从右到左查找字符c在字符串中的位置，若找到则返回位置，若未找到则返回null*/
char* strrchr(const char* str, const uint8_t c){
    ASSERT(str != NULL);
    const char* last_char = NULL;
    while(*str != 0){
        if(*str == c){
            last_char = str;
        }
        str++;
    }
    return (char*)last_char;
}


/*拼接字符串，并返回拼接串的地址*/
char* strcat(char* dst_, const char* src_){
    ASSERT(dst_ != NULL && src_ != NULL);
    char* r = dst_;
    while(*dst_ != 0){
        dst_++;
    }
    while((*dst_++ = *src_++) != 0);
    return r;
}


/*统计字符串中字符c出现的次数*/
uint32_t strchrs(const char* str, const uint8_t c){
    ASSERT(str != NULL);
    uint32_t count = 0;
    while(*str != 0){
        if(*str == c){
            count++;
        }
        str++;
    }
    return count;
}