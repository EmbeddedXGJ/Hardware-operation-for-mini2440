.text
.global _start

_start:
	/*πÿ±’ø¥√≈π∑*/
	ldr r1,= 0x53000000
	mov r0,#0
	str r0,[r1]

	ldr sp,= 0x40000000+4096

	bl main

halt_loop:
	b halt_loop
