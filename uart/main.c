#include "s3c2440_soc.h"
#include "uart.h"

int main()
{
	char c = 'a';
	uart0_init();

	while(1)
	{
		putchar(c);
	}

	return 0;
}

