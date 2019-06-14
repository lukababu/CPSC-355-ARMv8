// Assignment 5 (part a) | Global Variables and Separate Compilation
// Name: Luke Iremadze
// UCID: 10163614
// Tutorial: T01
// Version: 04.26.2017
	.text
maxval:	.word 100

	.balign 4
	.global push, pop, clear, getop, getch, ungetch

sp_r = 0
alloc = -(16 * maxval * 4) & -16
dealloc = -alloc

push:	stp x29, x30, [sp, alloc]!
	mov x29, sp


	ldp x29, x30, [sp], dealloc
	ret

pop:	stp x29, x30, [sp, -16]!
        mov x29, sp

        ldp x29, x30, [sp], 16
        ret

clear:	stp x29, x30, [sp, -16]!
        mov x29, sp

        ldp x29, x30, [sp], 16
        ret

getop:	stp x29, x30, [sp, -16]!
        mov x29, sp

        ldp x29, x30, [sp], 16
        ret

getch:	stp x29, x30, [sp, -16]!
        mov x29, sp

        ldp x29, x30, [sp], 16
        ret

ungetch:	stp x29, x30, [sp, -16]!
		mov x29, sp

		ldp x29, x30, [sp], 16
		ret
