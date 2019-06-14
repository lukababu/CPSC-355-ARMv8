// Assignment 5 (part b) | External Pointer Arrays and Command-Line Arguments
// Name: Luke Iremadze 
// UCID: 10163614
// Tutorial: T01
// Version: 04.26.2017


//=====Macros====//
define(i_r, w19)
define(mm_r, w20)
define(dd_r, w21)
define(yyyy_r, w22)
define(argv_r, x23)
define(argc_r, w24)

			.text							// Read-Only
validInput:		.string " %s %d%s %d\n "				// If user input has valid format, output the following
invalidInput:		.string	"usage: a5b mm dd yyyy\n"			// If user did not pass the arguments correctly output this

Jan_m:			.string "January"					// List of Months
Feb_m:			.string "February"
Mar_m:			.string "March"
Apr_m:			.string "April"
May_m:			.string "May"
Jun_m:			.string "June"
Jul_m:			.string "July"
Aug_m:			.string "August"
Sep_m:			.string "September"
Oct_m:			.string "October"
Nov_m:			.string "November"
Dec_m:			.string "December"

st_m:			.string "st,"						// Suffixes
nd_m:			.string "nd,"
rd_m:			.string "rd,"
th_m:			.string "th,"


			.data
			.balign 8 						// Should be 8 due to month_m referencing
month_m:		.dword Jan_m, Feb_m, Mar_m, Apr_m, May_m, Jun_m, Jul_m, Aug_m, Sep_m, Oct_m, Nov_m, Dec_m
days_m:			.dword st_m, nd_m, rd_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, st_m, nd_m, rd_m, th_m, th_m, th_m, th_m, th_m, th_m, th_m, st_m


		.text
		.balign 4					// re-allign to 4 bytes
		.global main

main:		stp	x29, x30, [sp, -16]!
		mov	x29, sp

		mov	argc_r, w0				// Copy argument count
		mov	argv_r, x1				// Copy argument values

		cmp	argc_r, 4				// Check to see if input has correct number of arguments
		b.eq	initialize				// If it has, proceed
		b	invalid					// Else branch to invalid and print the error message

initialize:
		mov	i_r, 1						// int i = 1;
		ldr	x20, [argv_r, i_r, SXTW 3]			// argv_r[i]@x20 == argv_r[1]
		mov	i_r, 2						// int i = 2;
		ldr	x21, [argv_r, i_r, SXTW 3]			// argv_r[i]@x21 == argv_r[2]
		mov	i_r, 3						// int i = 3;
		ldr	x22, [argv_r, i_r, SXTW 3]			// argv_r[i]@x22 == argv_r[3]

		mov	x0, x20
		bl	atoi						// Cast string into int
		mov	mm_r, w0					// Save (Month) mm_r value

		mov	x0, x21
		bl	atoi
		mov	dd_r, w0					// Save (Day) dd_r value

		mov	x0, x22
		bl	atoi
		mov	yyyy_r, w0					// Save (Year) yyyy_r value

monthValidityUpperBound:
	cmp		mm_r, 12					// mm_r <= 12 ?
	b.le		monthValidityLowerBound				// If True proceed
	b		invalid						// Else invalid

monthValidityLowerBound:
	cmp		mm_r, 0						// mm_r > 0 ?
	b.gt		dayValidityUpperBound
	b		invalid

dayValidityUpperBound:
	cmp		dd_r, 31					// dd_r <= 31 ?
	b.le		dayValidityLowerBound
	b		invalid

dayValidityLowerBound:
	cmp		dd_r, 1						// dd_r >= 1 ?
	b.ge		yearValidity
	b		invalid

yearValidity:
	cmp		yyyy_r, 0					// yyyy_r > 0?
	b.gt		validOutput
	b		invalid

validOutput:
	// Adjust the computer counting offset by -1
	sub		mm_r, mm_r, 1
	sub		dd_r, dd_r, 1

	adrp		x25, month_m					// Setup for first argument in output (Month)
	add		x25, x25, :lo12:month_m
	ldr		x1, [x25, mm_r, SXTW 3]

	add		w2, dd_r, 1					// Setup for second argument in output (Date) and add 1 to re-offset

	adrp		x25, days_m					// Setup for third argument in output (Date suffix)
	add		x25, x25, :lo12:days_m
	ldr		x3,[x25, dd_r, SXTW 3]

	mov		w4, yyyy_r					// Setup for fourth argument in output (Year)

	adrp		x0, validInput					// Setup for printing
	add		x0, x0, :lo12:validInput
	bl		printf

	b		exit						// Exit program

invalid:
	adrp		x0, invalidInput
	add		x0, x0, :lo12:invalidInput
	bl		printf

exit:
	mov		w0, 0
	ldp		x29, x30, [sp], 16
	ret
