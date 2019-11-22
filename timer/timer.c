#include "s3c2440_soc.h"

 
extern void timer_irq();
extern void regsister_irq(int irq,irq_fuc hardware_irq);
void timer_init()
{
	//50000000 / (99+1)  /16
	TCFG0 = 99;
	TCFG1 &= ~0xf;
	TCFG1 |= 3<<0;

	TCNTB0 = 15625;  /* 0.5s�ж�һ��*/
	
	TCON |= (1 << 1); //���� TCNTB0��TCMP0
	TCON &= ~(1 << 1); 
	
	TCON |= (1<<0) | (1<<3); //������ʱ���������Զ���װ��
	regsister_irq(10,timer_irq); //zhu ce zhong duan
} 
