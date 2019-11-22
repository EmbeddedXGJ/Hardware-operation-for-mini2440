#include "s3c2440_soc.h"
#include "uart.h"

void uart0_init()
{
	/*设置引脚GPH2,3用于串口0*/
	GPHCON &= ~(0XF << 4);
	GPHCON |= (0XA << 4);
	GPHUP &= (1 << 2) | (1 << 3);  //使能内部上拉(使不使能都没关系)

	UCON0 |= (1 << 0) | (1 << 2);//使用中断或查询模式
	UCON0 &= ~(2 << 10); 
	
	 
	UBRDIV0 = 26;

	ULCON0 &= ~(1 << 5);
	 
	ULCON0 &= ~(1 << 2);
 
	ULCON0 |= (3 << 0);
	
}

void putchar(int c)
{
	UTXH0 = (unsigned char)c;
	while(!(UTRSTAT0&(1 << 2)));
}

int getchar()
{
	while(!(UTRSTAT0&1<<0));
	return URXH0;
}



void puts(const char *str)
{
	int i = 0;
	while(*str)
	{
		putchar(*str);
		str++;
	}
}



