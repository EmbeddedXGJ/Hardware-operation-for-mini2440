#include "s3c2440_soc.h"

#define LED1 1
#define LED2 2
#define LED3 3
#define LED4 4

#define GPIOG0_INTER (3 << (2*0))   //K1 按键
#define GPIOG3_INTER (3 << (2*3))   //k2 按键

char exit_int_flag = 0;
extern void led_on_off(char led_num, char status);
//EINTPEND
//INTOFFSET
void interrupt_init()
{
	INTMOD &= ~(1 << 5); //设置ENINT8_23为IRQ中断
	INTMSK &= ~(1 << 5);//使能中断ENIN8_23
}

void beep_init(void)
{
	GPBCON &= ~(3 << 0);
	GPBCON |= 1 << 0;
}

void key_intterupt_init()
{
	beep_init();
	/*设置按键引脚为中断引脚*/
	GPGCON &= ~((3 << 0) | (3 << 6));  
	GPGCON |= (2 << 6) | (2 << 0);

	/*设置中断触发方式，上升沿or下降沿，or双边沿*/
	EXTINT1 |= (3 << 1) | (3 << 9); //设置为双边沿触发

	EINTMASK &= ~((1<<8) | (1<<11));//使能EINT8和EINT11
}

void key_exint_handle(int irq_num)
{
	int val = EINTPEND;
	
	int val_key = GPGDAT;
	
	if(irq_num == 5)
	{
		exit_int_flag = 1;
		if(val & (1<<8))
		{
			if(val_key & (1 << 0))
			{
				GPBDAT &= (~(1 << 7));
			}
			else
			{
				GPBDAT |= (1 << 7);
			}
		}
		else if(val & (1 << 11))
		{
			
			if(val_key & (1 << 3))
			{
				GPBDAT &= (~(1 << 8));
			}
			else
			{
				GPBDAT |= (1 << 8);
			}
		}
	}
	EINTPEND = val;  //清中断
}


void irq_handle()
{
	int bit = INTOFFSET;
	if(bit == 5)
	{
		key_exint_handle(bit);
	}
	SRCPND |= (1<<bit);
	INTPND |= (1<<bit);
	
}


