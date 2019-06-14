// Assignment 3 | Sorting 1D array
// Name: Luke Iremadze
// UCID: 10163614
// Tutorial: T01
// Version: 03.02.2017

// Macros
define(fp, x29)
define(lr, x30)
define(regI, w19)
define(regJ, w20)
define(baseAddress, x28)						// Base address of the array


// Create Array
arraySize = 50
alloc =  -(32+ 4 + 4 + arraySize*4) & 16
deAlloc = -alloc
arrayBase = 0
iAddress = 300
jAddress = 304
temp = -4

string1:	.string "Entry %d : %d\n"
string2:	.string "Sorted Array:\n"

.balign 4
.global main

main:	stp	fp, lr, [sp, alloc]!
	mov	fp, sp

	add	 baseAddress, fp, arrayBase				// Calculate array address

	mov	 regI, 0						// Initialize i to 0
	str	 regI, [fp, iAddress]					// Store i to stack memeroy
	b	 test1

randomNumber:	bl	rand
	and	w21, w0, 0xFF						// Shift random number

	ldr	regI, [fp, iAddress]					// Load i from stack
	str	w21, [baseAddress, regI, SXTW 2]			// Store the random value from w21 to stack

printString1:	adrp	x0, string1
	add	x0, x0, :lo12:string1
	mov	w1, regI
	mov	w2, w21
	bl	printf

	ldr	regI, [fp, iAddress]
	add	regI, regI, 1
	str	regI, [fp, iAddress]

test1:	cmp	regI, arraySize						// Compare i to array size, 50
	b.lt	randomNumber						// If i is less than 50, run the loop

	sub	regI, regI, 1						// After the loop i is 50 but we need it to be 39 for the next loop
	str	regI, [fp, iAddress]

allocateMem:	add	sp, sp, -4 & -16				// Allocate memory on the stack for temp

	mov	regJ, 1
	str	regJ, [fp, jAddress]
	b	test2

loop1:	ldr	regJ, [fp, jAddress]
	ldr	w21, [baseAddress, regJ, SXTW 2]
	sub	w22, regJ, 1
	ldr	w23, [baseAddress, w22, SXTW 2]
	cmp	w23, w21
	b.le	next

	str	w23, [fp, temp]
	str	w21, [baseAddress, w22, SXTW 2]
	str	w23, [baseAddress, regJ, SXTW 2]


next:	ldr	regJ, [fp, jAddress]					
	add	regJ, regJ, 1						// j++
	str	regJ, [fp, jAddress]

test2:	cmp	regJ, regI
	b.le	loop1							// If j is less than or equal to i, jump to top of loop 3

	ldr	regI, [fp, iAddress]
	sub	regI, regI, 1
	str	regI, [fp, iAddress]

	add	sp, sp, 16

test3:	cmp	regI, 0
	b.ge	allocateMem						// While i is greater than or equal to 0, jump to top of loop 2

printString2:	adrp	x0, string2					// Prep for printing string 2, higher bits
	add	x0, x0, :lo12:string2
	bl	printf

	add	regI, regI, 1						// i++
	str	regI, [fp, iAddress]
	b	test4

loop2:	ldr	regI, [fp, iAddress]
	ldr	w21, [baseAddress, regI, SXTW 2]

	adrp	x0, string1
	add	x0, x0, :lo12:string1
	mov	w1, regI
	mov	w2, w21
	bl	printf

	add	regI, regI, 1						// i++
	str	regI, [fp, iAddress]

test4:	cmp	regI, arraySize						// Compare i to 50
	b.lt	loop2							// While i is less than 50, jump to top of loop

done:	mov	w0, 0

	ldp	fp, lr, [sp], deAlloc
	ret
