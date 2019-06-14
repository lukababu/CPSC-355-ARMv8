// Assignment 3 | Sorting 1D array
// Name: Luke Iremadze
// UCID: 10163614
// Tutorial: T01
// Version: 03.02.2017

// Macros




						// Base address of the array


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

main:	stp	x29, x30, [sp, alloc]!
	mov	x29, sp

	add	 x28, x29, arrayBase				// Calculate array address

	mov	 w19, 0						// Initialize i to 0
	str	 w19, [x29, iAddress]					// Store i to stack memeroy
	b	 test1

randomNumber:	bl	rand
	and	w21, w0, 0xFF						// Shift random number

	ldr	w19, [x29, iAddress]					// Load i from stack
	str	w21, [x28, w19, SXTW 2]			// Store the random value from w21 to stack

printString1:	adrp	x0, string1
	add	x0, x0, :lo12:string1
	mov	w1, w19
	mov	w2, w21
	bl	printf

	ldr	w19, [x29, iAddress]
	add	w19, w19, 1
	str	w19, [x29, iAddress]

test1:	cmp	w19, arraySize						// Compare i to array size, 50
	b.lt	randomNumber						// If i is less than 50, run the loop

	sub	w19, w19, 1						// After the loop i is 50 but we need it to be 39 for the next loop
	str	w19, [x29, iAddress]

allocateMem:	add	sp, sp, -4 & -16				// Allocate memory on the stack for temp

	mov	w20, 1
	str	w20, [x29, jAddress]
	b	test2

loop1:	ldr	w20, [x29, jAddress]
	ldr	w21, [x28, w20, SXTW 2]
	sub	w22, w20, 1
	ldr	w23, [x28, w22, SXTW 2]
	cmp	w23, w21
	b.le	next

	str	w23, [x29, temp]
	str	w21, [x28, w22, SXTW 2]
	str	w23, [x28, w20, SXTW 2]


next:	ldr	w20, [x29, jAddress]					
	add	w20, w20, 1						// j++
	str	w20, [x29, jAddress]

test2:	cmp	w20, w19
	b.le	loop1							// If j is less than or equal to i, jump to top of loop 3

	ldr	w19, [x29, iAddress]
	sub	w19, w19, 1
	str	w19, [x29, iAddress]

	add	sp, sp, 16

test3:	cmp	w19, 0
	b.ge	allocateMem						// While i is greater than or equal to 0, jump to top of loop 2

printString2:	adrp	x0, string2					// Prep for printing string 2, higher bits
	add	x0, x0, :lo12:string2
	bl	printf

	add	w19, w19, 1						// i++
	str	w19, [x29, iAddress]
	b	test4

loop2:	ldr	w19, [x29, iAddress]
	ldr	w21, [x28, w19, SXTW 2]

	adrp	x0, string1
	add	x0, x0, :lo12:string1
	mov	w1, w19
	mov	w2, w21
	bl	printf

	add	w19, w19, 1						// i++
	str	w19, [x29, iAddress]

test4:	cmp	w19, arraySize						// Compare i to 50
	b.lt	loop2							// While i is less than 50, jump to top of loop

done:	mov	w0, 0

	ldp	x29, x30, [sp], deAlloc
	ret
