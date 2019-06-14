// Assignment 6 | File I/O and Floating-Point Numbers
// Name: Luke Iremadze
// UCID: 10163614
// Tutorial: T01
// Version: 04.26.2017


define(fp_r, w19)											// File Path
define(nread_r, x20)										// Number of bits read
define(buf_base, x21)										// Base address of buffer
define(cmdArgs, x22)										// Command line arguments
define(i_r, w23)											// Index

define(x_r, d31)											// Read value x
define(sin_r, d25)											// Sin Value
define(cos_r, d24)											// Cos Value

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

		mov	cmdArgs, x1

		mov	i_r, 1
		ldr	x1, [cmdArgs, i_r, SXTW 3]

		mov	w0, AT_FDCWD
		mov	w2, 0
		mov	w3, 0
		mov	x8, 56
		svc	0
		mov	fp_r, w0

		cmp	fp_r, 0
		b.ge	opened

		adrp	x0, fileNotFound
		add	x0, x0, :lo12:fileNotFound
		bl	printf

		mov	w0, -1
		b	exit

opened:	adrp	x0, header						//load string address, higher bits
		add	x0, x0, :lo12:header				//load string address, lower bits
		bl	printf								//print header

		add	buf_base, x29, 16					//calculate buffer base

top:	mov		w0, fp_r
		mov		x1, buf_base
		mov		w2, buf_size
		mov		x8, 63
		svc		0
		mov		nread_r, x0

		cmp		nread_r, buf_size				// Compare nread to expected read number
		b.ne	close							// Exit if fail

		ldr		x_r, [buf_base]					// Load read value into x_r from buffer

		fmov	d0, x_r
		fmov	sin_r, d0						// Assign return value into Sin_r register
		fmov	cos_r, d0						// Assign return value into Cos_r register

		adrp	x0, fmt
		add		x0, x0, :lo12:fmt
		fmov	d0, x_r							// Load read value
		fmov	d1, sin_r						// Load Sin value
		fmov	d2, cos_r						// Load Cos value
		bl		printf

		b	top									// Loop again

close:	mov	w0, fp_r
		mov	x8, 57
		svc	0

		mov	w0, 0

exit:	ldp	x29, x30, [sp], dealloc
		ret
