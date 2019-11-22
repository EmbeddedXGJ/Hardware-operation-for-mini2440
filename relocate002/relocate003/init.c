#include "s3c2440_soc.h"

void sdram_init(void)
{
	BWSCON = 0X22000000;
	BANKCON6 = 0X18001;

	REFRESH = 0X8404F5;

	BANKSIZE = 0xb1;

	MRSRB6 = 0x20;
}

int sdram_test()
{
	volatile unsigned char *p= (volatile unsigned char*)0x30000000;
	int i;

	//write sdram
	for(i = 0;i < 1000;i++)
	{
		p[i] =0x66;
	}

	for(i = 0;i < 1000;i++)
	{
		if(p[i] != 0x66)
		{
			return -1;
		}
	}

	return 0;
	
}
