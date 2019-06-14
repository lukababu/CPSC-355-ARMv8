// Assignment 4 | Structures and subroutines
// Name: Luke Iremadze
// UCID: 10163614
// Version: 2017-03-17
// Tutorial: T01


		// Macros
		define(fp, x29)
		define(lr, x30)
		define(true_r, w19)
		define(false_r, w20)

		// Structure | Nested Dimensions
		dimension_width = 0
		dimension_height = 4
		point_x = 0
		point_y = 4

		// Main Structure
		boxOrigin = 0
		boxSize = 8
		boxArea = 16

		//Memory allignment for objects and variables
		boxSize2 = 20
		a_size  = 4
		b_size = 4
		total_size = box_Tsize*2 + a_size + b_size
		alloc = -(16 + total_size) & -16
		dealloc = -alloc
		first_s = 16
		second_s = 36
		a_s = 56
		b_s = 60

		// String formating
fmt1:
		.string "Initial Box Values:\n"
fmt2:
		.string "Changed Box Values:\n"
Name1:
		.string "first"
Name2:
		.string "second"
fmt3:
		.string "Box %s origin = (%d, %d) width = %d height = %d area = %d\n"

		.balign 4
		.global main

main:
		stp fp, lr, [sp, alloc]!
		mov fp, sp

		mov true_r, 1
		mov false_r, 0

		//Creating instances
		add x8, fp, first_s
		bl newBox

		add x8, fp, second_s
		bl newBox

		adrp x0, fmt1
		add x0, x0, :lo12:fmt1
		bl printf

		adrp x0, Name1
		add x0, x0, :lo12:Name1
		add x8, fp, first_s
		bl toString

		adrp x0, Name2
		add x0, x0, :lo12:Name2
		add x8, fp, second_s
		bl toString

		add x0, fp, first_s
		add x1, fp, second_s
		bl equal

		cmp w0, true_r	// Check box equality
		b.eq iff

		//Shifting the origin of the first box
		mov w21, -5
		str w21, [fp, a_s]
		mov w21, 7
		str w21, [fp, b_s]
		add x8, fp, first_s
		add x0, fp, a_s
		add x1, fp, b_s
		bl move

		//Expanding the dimensions of second box
		mov w21, 3
		str w21, [fp, a_s]
		add x8, fp, second_s
		add x0, fp, a_s
		bl expand

iff:	//Method to assign arguments and print box information
		adrp x0, fmt2
		add x0, x0, :lo12:fmt2
		bl printf

		adrp x0, Name1
		add x0, x0, :lo12:Name1
		add x8, fp, first_s
		bl toString

		adrp x0, Name2
		add x0, x0, :lo12:Name2
		add x8, fp, second_s
		bl toString

		ldp fp, lr, [sp], dealloc
		ret

		define(b_base_r, x9)

		b_size = 20
		alloc = -(16 + b_size) & -16
		dealloc = -alloc
		b_s = 16

newBox:	//Method to initialize Box's values
		stp fp, lr, [sp, alloc]!
		mov fp, sp

		add b_base_r, fp, b_s

		//Value of the points is 0
		str wzr, [b_base_r, boxOrigin+point_x]
		str wzr, [b_base_r, boxOrigin+point_y]

		//Height and width is 1
		mov w10, 1
		str w10, [b_base_r, box_size+dimension_width]
		mov w11, 1
		str w11, [b_base_r, box_size+dimension_height]

		//Calculating the area
		mul w10, w10, w11
		str w10, [b_base_r, boxArea]

		//Putting values in memory
		ldr w10, [b_base_r, boxOrigin+point_x]
		str w10, [x8, boxOrigin+point_x]
		ldr w10, [b_base_r, boxOrigin+point_y]
		str w10, [x8, boxOrigin+point_y]
		ldr w10, [b_base_r, box_size+dimension_width]
		str w10, [x8, box_size+dimension_width]
		ldr w10, [b_base_r, box_size+dimension_height]
		str w10, [x8, box_size+dimension_height]
		ldr w10, [b_base_r, boxArea]
		str w10, [x8, boxArea]

		ldp fp, lr, [sp], dealloc
		ret

		define(temp_r, x9)

toString:	//Method to pass arguments for printf
		stp fp, lr, [sp, -16]!
		mov fp, sp

		mov x9, x0

		adrp x0, fmt3
		add x0, x0, :lo12:fmt3
		mov x1, x9
		ldr w2, [x8, boxOrigin+point_x]
		ldr w3, [x8, boxOrigin+point_y]
		ldr w4, [x8, box_size+dimension_width]
		ldr w5, [x8, box_size+dimension_height]
		ldr w6, [x8, boxArea]
		bl printf

		ldp fp, lr, [sp], 16
		ret

		define(result_r, w4)

equal:	//Method to check all values of first and second Box
		stp fp, lr, [sp, -16]!
		mov fp, sp

		mov result_r, 0

		ldr w2, [x0, boxOrigin+point_x]
		ldr w3, [x1, boxOrigin+point_x]

		cmp w2, w3
		b.eq bool

		ldr w2, [x0, boxOrigin+point_y]
		ldr w3, [x1, boxOrigin+point_y]

		cmp w2, w3
		b.eq bool

		ldr w2, [x0, box_size+dimension_width]
		ldr w3, [x1, box_size+dimension_width]

		cmp w2, w3
		b.eq bool

		ldr w2, [x0, box_size+dimension_height]
		ldr w3, [x1, box_size+dimension_height]

		cmp w2, w3
		b.eq bool

		mov result_r, 1

bool:	//Return value True or False
		mov w0, result_r

		ldp fp, lr, [sp], 16
		ret

move:	//Method to move points
		stp fp, lr, [sp, -16]!
		mov fp, sp

		ldr w2, [x8, boxOrigin+point_x]
		ldr w3, [x8, boxOrigin+point_y]
		ldr w4, [x0]
		ldr w5, [x1]

		add w2, w2, w4
		add w3, w3, w5

		str w2, [x8, boxOrigin+point_x]
		str w3, [x8, boxOrigin+point_y]

		ldp fp, lr, [sp], 16
		ret

expand:	//Method to expand the dimensions by a factor
		stp fp, lr, [sp, -16]!
		mov fp, sp

		ldr w1, [x8, box_size+dimension_width]
		ldr w2, [x8, box_size+dimension_height]
		ldr w0, [x0]

		mul w1, w1, w0
		mul w2, w2, w0

		mul w3, w1, w2

		str w1, [x8, box_size+dimension_width]
		str w2, [x8, box_size+dimension_height]

		str w3, [x8, boxArea]

		//Restoring the state
		ldp fp, lr, [sp], 16
		ret
