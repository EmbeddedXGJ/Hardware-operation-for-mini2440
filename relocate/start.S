.text
.global _start

_start:
	
	ldr   r0, =0x53000000     @ WATCHDOGÅ’Ã„Å½Ã¦Ã†Ã·ÂµÃ˜Ã–Â·
    mov   r1, #0x0                     
    str   r1, [r0] 
	
	

	/* è®¾ç½®FCLK:HCLK:PCLK=400M:100M:50M */
	/* è®¾ç½®LOCKTIMEï¼ˆæ—¶é’Ÿç¨³å®šæ—¶é—´çš„å¯„å­˜å™¨ï¼‰ */
	ldr r0,= 0x4C000000
	ldr r1,= 0xffffffff
	str r1,[r0]
	
	/* è®¾ç½®CLKDIN,HCCLK = FCLK / 4,PCLK = FCLK / 8*/
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
	mov r2,#123  //r3ç­‰äº0
	str r2,[r0]  //å°†123å†™å…¥0åœ°å€çš„å€¼
	ldr r3,[r0]  //è¯»å‡º0åœ°å€çš„å€¼
	cmp r2,r3    //ç›¸ç­‰åˆ™è¯æ˜æ˜¯nandå¯åŠ¨ï¼Œä¸æƒ³ç­‰åˆ™æ˜¯norå¯åŠ¨
	ldr sp, =0x40000000+4096  //å‡è®¾æ˜¯norå¯åŠ¨å…ˆï¼Œè®¾ç½®norå¯åŠ¨çš„å †æ ˆ
	ldreq sp,= 4096   //å¦‚æœå†™å…¥çš„å€¼å’Œè¯»å‡ºçš„å€¼ç›¸ç­‰ï¼Œnandå¯åŠ¨,åˆ™è®¾ç½®å †æ ˆä¸º4096
	streq r1,[r0]  //æ¢å¤0åœ°å€çš„å€¼

	bl sdram_init  //ÔÚÖØ¶¨Î»´úÂëÖ®Ç°Òª³õÊ¼»¯sdram,·ñÔòÎŞ·¨½«Êı¾İ¶ÎÖØ¶¨Î»µ½sdramÖĞ


	//ÖØ¶¨Î»data¶Î
	ldr r0,= data_loadaddr //data¶ÎÔÚbinÎÄ¼şÖĞµÄµØÖ·£¬¼´¼ÓÔØµØÖ·
	ldr r1,= data_start   //ÖØ¶¨Î»µÄµØÖ·£¬ÔËĞĞµØÖ·
	ldr r2,= data_end    //ÔËĞĞ½áÊøµØÖ·
relacorte:
	ldr r3,[r0] 
	str r3,[r1]
	add r0,r0,#4
	add r1,r1,#4
	cmp r1,r2
	bne relacorte

	/* Çåbss¶Î*/
	ldr r0,= _bss_start
	ldr r1,= _bss_end
clean:
	mov r2,#0
	str r2,[r1];
	add r0,r0,#4
	cmp r0,r1
	bne clean
	
	bl main

halt:
	b halt
