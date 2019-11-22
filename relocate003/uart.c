#include "s3c2440_soc.h"

void uart0_init()
{
	/* 设置引脚为RTX,TXD*/
	GPHCON &= ~((3 << 4)| (3<<6));
	GPHCON |= (2<<4) | (2<<6);
	
	/* 使能管脚的内部上拉*/
	GPHUP &= ~((1<<2) | (1<<3));
	
	/* 选择串口的时钟 */
	 UCON0 &= (3<<10);/*选择PCLK作为时钟源*/
	 UCON0 |= (1<<0) | (1<<2);	 /* 使用终端或查询的方式*/
	 
	/*设置波特率*/
	/*UBRDIVn = (int)( UART clock / ( buad rate x 16) ) –1*/
	UBRDIV0 =  26;
	
	/* 设置数据格式 */
	ULCON0 = 0X00000003;/*8位数据位，1bit停止位，无校验*/
}

/*UTRSTAT0*/
void putchar(int c)
{
	UTXH0 =  (unsigned char)c;
	while(!(UTRSTAT0 & (1<<2))); /*UTRSTAT0 第二位为1,代表上次数据发送成功，接下来可以发送数据*/
	
}

int getchar(void)
{
	while(!(UTRSTAT0 & (1<<0)));
	return URXH0;
}

int puts(const char *s)
{
	while(*s)
	{
		putchar(*s);
		s++;
	}
}




