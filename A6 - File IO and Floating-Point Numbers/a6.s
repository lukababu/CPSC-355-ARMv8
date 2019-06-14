// Assignment 6 | File I/O and Floating-Point Numbers
// Name: Luke Iremadze
// UCID: 10163614
// Tutorial: T01
// Version: 04.26.2017


											// File Path
										// Number of bits read
										// Base address of buffer
										// Command line arguments
											// Index

											// Read value x
											// Sin Value
											// Cos Value

			.text
pi:			.double	0r3.1415								// Constant for Pi number
															// rad = x/180.0*3.1415

AT_FDCWD = -100													// File input pathname set relative to program location
buf_size = 8													// Size of buffer
alloc = -(16 + buf_size) & -16
dealloc = -alloc

header:			.string " Degree\t\tSin(x)  \tCos(x)\n\n"		// Table header
fmt:			.string "%13.10f %13.10f %13.10f\n"				// Print values according to format (10 digit precision)
fileNotFound:	.string "File could not open\n"

		.balign 4
		.global main

main:	stp	x29, x30, [sp, alloc]!
		mov	x29, sp

		mov	x22, x1

		mov	w23, 1
		ldr	x1, [x22, w23, SXTW 3]

		mov	w0, AT_FDCWD
		mov	w2, 0
		mov	w3, 0
		mov	x8, 56
		svc	0
		mov	w19, w0

		cmp	w19, 0
		b.ge	opened

		adrp	x0, fileNotFound
		add	x0, x0, :lo12:fileNotFound
		bl	printf

		mov	w0, -1
		b	exit

opened:	adrp	x0, header						//load string address, higher bits
		add	x0, x0, :lo12:header				//load string address, lower bits
		bl	printf								//print header

		add	x21, x29, 16					//calculate buffer base

top:	mov		w0, w19
		mov		x1, x21
		mov		w2, buf_size
		mov		x8, 63
		svc		0
		mov		x20, x0

		cmp		x20, buf_size				// Compare nread to expected read number
		b.ne	close							// Exit if fail

		ldr		d31, [x21]					// Load read value into d31 from buffer

		fmov	d0, d31
		fmov	d25, d0						// Assign return value into Sin_r register
		fmov	d24, d0						// Assign return value into Cos_r register

		adrp	x0, fmt
		add		x0, x0, :lo12:fmt
		fmov	d0, d31							// Load read value
		fmov	d1, d25						// Load Sin value
		fmov	d2, d24						// Load Cos value
		bl		printf

		b	top									// Loop again

close:	mov	w0, w19
		mov	x8, 57
		svc	0

		mov	w0, 0

exit:	ldp	x29, x30, [sp], dealloc
		ret
