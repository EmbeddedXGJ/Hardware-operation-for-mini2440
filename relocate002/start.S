.text
.global _start

_start:
	
	ldr   r0, =0x53000000     @ WATCHDOGÅ’Ã„Å½Ã¦Ã†Ã·ÂµÃ˜Ã–Â·
    mov   r1, #0x0                     
    str   r1, [r0] 
	
	

	/* Ìá¸ßÊ±ÖÓ£¬ÉèÖÃFCLK:HCLK:PCLK=400M:100M:50M */
	/* LOCKTIME(¸Ã¼Ä´æÆ÷ÊÇÓÃÀ´ÉÏµçÊ±ÖÓ±äÎªÎÈ¶¨µÄÊ±¼ä) */
	ldr r0,= 0x4C000000
	ldr r1,= 0xffffffff
	str r1,[r0]
	
	/* ÉèÖÃ·ÖÆµ±È£¬CLKDIN,HCCLK = FCLK / 4,PCLK = FCLK / 8*/
	ldr r0,= 0x40000014
	ldr r1,= 0x5
	str r1,[r0]
	
	/*MMU_SetAsyncBusMode  HCLKDIVNä¸ä¸ºé›¶çš„è¯è¦è®¾ç½®ä¸ºå¼‚æ­¥æ¨¡å¼ï¼ˆæ‰‹å†Œä¸­å¾—æ¥çš„ï¼‰*/
	mrc p15,0,r0,c1,c0,0
	orr r0,r0,#0xc0000000
	mcr p15,0,r0,c1,c0,0
	
	/* è®¾ç½® MPLL(0x40000004) = (92<<12) | (1<<4)|(1<<0)*/
	ldr r0,= 0x40000004
	ldr r1,= (92<<12) | (1<<4) | (1<<0)
	str r1,[r0]
	
	mov r0,#0
	ldr r1,[r0] //¶Á³ö0µØÖ·µÄÖµ£¬±£´æÔÚr1ÖĞ
	mov r2,#123 
	str r2,[r0]  //½«123Ğ´Èë0µØÖ·
	ldr r3,[r0]  //¶Á³ö0µØÖ·µÄÖµ
	cmp r2,r3    //±È½Ï¶Á³öºÍĞ´ÈëµÄÖµÊÇ·ñÏàµÈ
	             //ÏàµÈÔòÎªnandÆô¶¯£¬²»ÏàµÈÔòÎªnorÆô¶¯
	ldr sp, =0x40000000+4096  //¼ÙÉèÊÇnorÆô¶¯
  	ldreq sp,= 4096   //ÏàµÈÔòÎªnandÆô¶¯£¬
  	streq r1,[r0]  //nandÆô¶¯£¬»Ö¸´0µØÖ·µÄÖµ

	bl sdram_init  //ÔÚÖØ¶¨Î»´úÂëÖ®Ç°Òª³õÊ¼»¯sdram,·ñÔòÎŞ·¨½«Êı¾İ¶ÎÖØ¶¨Î»µ½sdramÖĞ


	//ÖØ¶¨Î»text¶Î£¬rodada,data¶Î(ÖØ¶¨Î»Õû¸ö³ÌĞò)  bss¶Î²»Òª¸´ÖÆ
	mov r2,#0   //³ÌĞòµÄ¼ÓÔØµØÖ·£¬
	ldr r0,= _start // //µÚÒ»Ö¸ÁîÔËĞĞÊ±µØÖ· ÆäÁ¬½ÓµØÖ·Îª0x30000000£¬
	                //ÔÚ0µØÖ·ÄÜÊÇÒòÎªÊÇÎ»ÖÃÎŞ¹ØÂë
	ldr r1,= __bss_start  
 
 relacorte:
	ldr r3,[r2]  //´Ó0µØÖ·È¡Öµ
	str r3,[r0]  //Ğ´Èëstart
	add r2,r2,#4
	add r0,r0,#4
	cmp r1,r0
	bne relacorte

	/* Çåbss¶Î*/
	ldr r0,= __bss_start
	ldr r1,= _end
	mov r2,#0
clean:
	str r2,[r0];
	add r0,r0,#4
	cmp r0,r1
	bne clean
	
	//bl main  /* Ê¹ÓÃblÃüÁîÊÇÏà¶ÔÌø×ª */
	ldr pc,= main /* Ê¹ÓÃ¾ø¶ÔÌø×ª²ÅÄÜµ÷µ½sdramÖĞÖ´ĞĞ*/

halt:
	b halt
