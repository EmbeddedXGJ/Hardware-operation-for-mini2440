.text
.global _start

_start:
	
	ldr   r0, =0x53000000     @ WATCHDOGŒÄŽæÆ÷µØÖ·
    mov   r1, #0x0                     
    str   r1, [r0] 
	
	mov r0,#0
	ldr r1,[r0] //保存0地址的值
	mov r2,#123  //r3等于0
	str r2,[r0]  //将123写入0地址的值
	ldr r3,[r0]  //读出0地址的值
	cmp r2,r3    //相等则证明是nand启动，不想等则是nor启动
	ldr sp, =0x40000000+4096  //假设是nor启动先，设置nor启动的堆栈
	ldreq sp,= 4096   //如果写入的值和读出的值相等，nand启动,则设置堆栈为4096
	streq r1,[r0]  //恢复0地址的值

	/* 设置FCLK:HCLK:PCLK=400M:100M:50M */
	/* 设置LOCKTIME（时钟稳定时间的寄存器） */
	ldr r0,= 0x4C000000
	ldr r1,= 0xffffffff
	str r1,[r0]
	
	/* 设置CLKDIN,HCCLK = FCLK / 4,PCLK = FCLK / 8*/
	ldr r0,= 0x40000014
	ldr r1,= 0x5
	str r1,[r0]
	
	/*MMU_SetAsyncBusMode  HCLKDIVN不为零的话要设置为异步模式（手册中得来的）*/
	mrc p15,0,r0,c1,c0,0
	orr r0,r0,#0xc0000000
	mcr p15,0,r0,c1,c0,0
	
	/* 设置 MPLL(0x40000004) = (92<<12) | (1<<4)|(1<<0)*/
	ldr r0,= 0x40000004
	ldr r1,= (92<<12) | (1<<4) | (1<<0)
	str r1,[r0]
	
	bl main

halt:
	b halt
