void copy_to_sdram()
{
	extern unsigned int _code_start,__bss_start;
	volatile unsigned int *src = (volatile unsigned int *)0;
	volatile unsigned int *dest = (volatile unsigned int *)&_code_start;
	volatile unsigned int *dest_end = (volatile unsigned int *)&__bss_start;

	while(dest < dest_end)
	{
		*dest = *src;
		dest++;
		src++;
	}
}

//Çå³ýbss¶Î
void clear_bss()
{
	extern unsigned int __bss_start,_end;
	volatile unsigned int *start_bss = (volatile unsigned int *)&__bss_start;
	volatile unsigned int *end_bss = (volatile unsigned int *)&_end;

	while(start_bss < end_bss)
	{
		*start_bss = 0;
		start_bss++;
	}
	
}
