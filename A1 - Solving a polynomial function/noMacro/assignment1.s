// Name: Luke Iremadze
// UCID: 10163614
// Tutorial: T01
// Version: 01.30.2017

// Equation y=( (-3x^3) - (24x^2) + (13x) + (31) ) && -8 <= x <= 5

// Format String
toString:		.string "x: %d \ny: %d \nMaximum: (%d,%d) \n\n"
			.balign 4
			.global main

main:		stp	x29,	x30,	[sp, -16]!
		mov	x29,	sp

		// Initialize & set register x19 to -8 as the initial x value
		mov	x19,	-8

		// Coeficient for the polynomial
		mov	x20,	-3
		mov	x21,	-24
		mov	x22,	13
		mov	x23,	31

		// Final values
		mov x26, -300	// Highest y value
		mov x27, x19	// Highest x value

process:        cmp x19,        6	// if our x value reaches 6 then we are out of range
		 b.eq    finish

		// reset or set
                mov x24,        x19             // take the current x value
                mov x25,        31              // x25 will hold the calculated y value

		// add (13x)
                mul x24,        x22,    x24
                add x25,        x25,    x24
                mov x24,        x19             // reset x24 value

		// add (-24x^2)
                mul x24,        x24,    x24
                mul x24,        x24,    x21
                add x25,        x25,    x24
                mov x24,        x19             // reset x24 value

		// add (-3x^3)
                mul x24,        x24,    x24
                mul x24,        x24,    x19
                mul x24,        x24,    x20
		add x25,        x25,    x24
		mov x24,        x19             // reset x24 value

		cmp x26,	x25		// Check to see if our maximum is still the maximum, if not setY will execute
		b.gt    output

setY:
		mov x26, x25
		mov x27, x19

output:		adrp	x0, toString
		add	x0,	x0,	:lo12:toString

		// Arguments for toString
		mov	x1,	x19		// Current x value
		mov	x2,	x25		// Current y value
		mov	x3,	x27		// Maximum@x
		mov	x4,	x26		// Maximum@y
		bl	printf

		add	x19,	x19,	1                  // x19++

		b	process		//Loop back

finish:	mov x0, 0

end:	ldp	x29,	x30,	[sp],	16
		ret
