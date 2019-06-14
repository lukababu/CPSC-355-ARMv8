// Assignment 2 | Integer Multiplication
// Name: Luke Iremadze 
// UCID: 10163614
// Tutorial: T01
// Version: 02.10.2017

// ======================= //
// Multiplicand: 522133279 //
// Multiplier:         200 //
// ======================= //

// Macros
	// Boolean
		define(true_r, w18)
		define(false_r, w19)

	// 32-bit
		define(multiplier_r, w20)
		define(multiplicand_r, w21)
		define(product_r, w22)
		define(counter_r, w23)
		define(negative_r, w24)

	// 64-bit
		define(res_r, x25)
		define(temp1_r, x26)
		define(temp2_r, x27)

// String code
fmt1:
		.string "multiplier = 0x%08x (%d)   multiplicand = 0x%08x (%d) \n\n"
fmt2:
		.string "product = 0x%08x   multiplier = 0x%08x\n\n"
fmt3:
		.string "64-bit result = 0x%016lx (%ld)\n\n"

		.balign 4
		.global main

main:
		stp x29, x30, [sp, -16]!
		mov x29, sp

	// Assign initial values
		mov multiplicand_r, 522133279
		mov multiplier_r, 200
		mov product_r, 0

		mov true_r, 1
		mov false_r, 0

		adrp x0, fmt1
		add x0, x0, :lo12:fmt1

	// Input argument values
		mov w1, multiplier_r
		mov w2, multiplier_r
		mov w3, multiplicand_r
		mov w4, multiplicand_r

		bl printf

	// Check sign of multiplicand, if negative then negative_r = true_r
		cmp multiplicand_r, 0
		b.gt elseIf_1
		mov negative_r, true_r
		b jump_1

elseIf_1:
		mov negative_r, false_r

jump_1:
	// initialize counter and jump to loop test
		mov counter_r, 0
		b test

loop:
		ands wzr, multiplier_r, 0x1 
		b.eq jump_2

		add product_r, product_r, multiplicand_r

jump_2:
		asr multiplier_r, multiplier_r, 1

		ands wzr, product_r, 0x1
		b.eq elseIf_2

		orr multiplier_r, multiplier_r, 0x80000000
		b jump_3

elseIf_2:
		and multiplier_r, multiplier_r, 0x7FFFFFFF
jump_3:
		asr product_r, product_r, 1

		add counter_r, counter_r, 1

test:
		cmp counter_r, 32
		b.lt loop

	// Check for negative
		cmp negative_r, true_r
		b.eq jump_4

		sub product_r, product_r, multiplicand_r

jump_4:
		adrp x0, fmt2
		add x0, x0, :lo12:fmt2
		mov w1, product_r
		mov w2, multiplier_r

		bl printf

		sxtw x22, product_r
		and temp1_r, x22, 0xFFFFFFFF
		asr temp1_r, temp1_r, 32		// Arithmetic Shift left by 32

		sxtw x20, multiplier_r
		and temp2_r, x20, 0xFFFFFFFF
		add res_r, temp1_r, temp2_r

		adrp x0, fmt3
		add x0, x0, :lo12:fmt3

		mov x1, res_r
		mov x2, res_r

		bl printf

		mov x0, 0				// Return 0 to main

		ldp x29, x30, [sp], 16
		ret					// Return message
