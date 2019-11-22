#include "s3c2440_soc.h"

#define LED1 1
#define LED2 2
#define LED3 3
#define LED4 4

#define GPIOG0_INTER (3 << (2*0))   //K1 ����
#define GPIOG3_INTER (3 << (2*3))   //k2 ����

char exit_int_flag = 0;
extern void led_on_off(char led_num, char status);
//EINTPEND
//INTOFFSET
void interrupt_init()
{
	INTMOD &= ~(1 << 5); //����ENINT8_23ΪIRQ�ж�
	INTMSK &= ~(1 << 5);//ʹ���ж�ENIN8_23
}

void beep_init(void)
{
	GPBCON &= ~(3 << 0);
	GPBCON |= 1 << 0;
}

void key_intterupt_init()
{
	beep_init();
	/*���ð�������Ϊ�ж�����*/
	GPGCON &= ~((3 << 0) | (3 << 6));  
	GPGCON |= (2 << 6) | (2 << 0);

	/*�����жϴ�����ʽ��������or�½��أ�or˫����*/
	EXTINT1 |= (3 << 1) | (3 << 9); //����Ϊ˫���ش���

	EINTMASK &= ~((1<<8) | (1<<11));//ʹ��EINT8��EINT11
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
	EINTPEND = val;  //���ж�
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


