.text
.global _start

_start:

	//设置GPIOB5引脚设置为输出
	ldr r1,= 0x56000010
	ldr r0,= 0x400
	str r0,[r1]

	//GPIOB5输出低电平点亮led
	ldr r1,= 0x56000014
	ldr r0,= 0x10
	str r0,[r1]

halt:
	b halt








