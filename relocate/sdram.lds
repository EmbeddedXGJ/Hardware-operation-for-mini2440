SECTIONS {
	.text 0 : {*(.text)}
	.rodata : {*(.rodata)}
	.data 0x30000000 : AT(0x800) 
	{
		data_loadaddr = LOADADDR(.data);
		. = ALIGN(4);   /*保证代码向4对齐，避免发生错误*/
		data_start = .;
		*(.data)
		data_end = .;
	}
	
 	. = ALIGN(4);    /*bss段向4对齐，避免bss段破坏数据段的数据*/
	_bss_start = .;
	.bss : 
	{
		*(.bss) 
		*(.COMMON)
	}
	_bss_end = .;
}
