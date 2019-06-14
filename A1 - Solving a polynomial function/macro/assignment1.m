// Name: Luke Iremadze
// UCID: 10163614
// Tutorial: T01
// Version: 01.30.2017
// Equation y=( (-3x^3) - (24x^2) + (13x) + (31) ) && -8 <= x  <= 5

// Macros
define(lr, x30)
define(fp, x29)
define(zero, x0)
define(arg1, x1)
define(arg2, x2)
define(arg3, x3)
define(arg4, x4)
define(xVariable, x19)
define(c1, x20)
define(c2, x21)
define(c3, x22)
define(c4, x23)
define(currentX, x24)
define(currentY, x25)
define(xAtLargestY, x27)
define(largestY, x26)

// Format String
toString: 	.string "x: %d \ny: %d \nMaximum: (%d,%d) \n\n"
		.balign 4
		.global main

main: 		stp fp, lr, [sp, -16]!
		mov fp,	sp
	// Initialize & set register x19 to -8 as the initial x value
		mov xVariable,	-8
	// Coeficient for the polynomial
		mov c1,	-3
		mov c2,	-24
		mov c3,	13
		mov c4,	31
	// Final values
		mov largestY,	-300		// Highest y value
		mov xAtLargestY,	x19	// Highest x value 

process:	cmp xVariable,	6	// if our x value reaches 6 then we are out of range
		b.eq finish

	// reset or set
		mov currentX, xVariable // take the current x value
        	mov currentY, c4 // x25 will hold the calculated y value

	// add (13x)
        	mul currentX,	c3,	currentX
        	add currentY,	currentY,	currentX
        	mov currentX, xVariable // reset x

	// add (-24x^2)
        	mul currentX, currentX, currentX
        	mul currentX, currentX, c2
        	add currentY, currentY, currentX
        	mov currentX, xVariable // reset x

	// add (-3x^3)
        	mul currentX, currentX, currentX
        	mul currentX, currentX, xVariable
        	mul currentX, currentX, c1
		add currentY, currentY, currentX
		mov currentX, xVariable // reset x
		cmp largestY, currentY // Check to see if our maximum is still the maximum, if not setY will execute
		b.gt output

setY:
		mov largestY, currentY
		mov xAtLargestY, xVariable

output:		adrp zero, toString
		add zero,	zero,	:lo12:toString

	// Arguments for toString
		mov arg1, xVariable
		mov arg2, currentY
		mov arg3, xAtLargestY
		mov arg4, largestY
		bl	printf

		add xVariable, xVariable, 1 // xVariable++
		b process //Loop back 

finish:	mov zero, 0

end:		ldp	fp,	lr,	[sp],	16
		ret
