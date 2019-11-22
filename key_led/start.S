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

	bl main

halt:
	b halt
