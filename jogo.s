.data
CHAR_POS: 	.half 0, 0
OLD_CHAR_POS:	.half 0, 0

.text
SETUP:
		la,a0,map
		li a1, 0
		li a2, 0
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
	
GAME_LOOP:
		call KEY2
		
		xori s0, s0, 1

		la t0, CHAR_POS
		la a0, char
		lh a1, 0(t0)
		lh a2, 2(t0)
		mv a3, s0
		call PRINT
		li t0, 0XFF200604
		sw s0, 0(t0)

		j GAME_LOOP
	
KEY2: 
		li t1, 0xFF200000
		lw t0, 0(t1)
		andi t0, t0, 0x0001
		beq t0, zero, FIM
		lw t2, 4(t1)

		li a0, 'a'
		beq t2, t0, CHAR_ESQ

		li t0, 'd'
		beq t2, t0, CHAR_DIR

FIM:
		ret

CHAR_ESQ:
		la t0, CHAR_POS
		la_t1, OLD_CHAR_POS
		lw t2, 0(t0)
		sw t2, 0(t1)
		

		lh t1, 0(t0)
		addi t1, t1, -16
		sh t1, 0(t0)
		ret
		
CHAR_DIR:
		la t0, CHAR_POS
		la_t1, OLD_CHAR_POS
		lw t2, 0(t0)
		sw t2, 0(t1)

		lh t1, 0(t0)
		addi t1, t1, 16
		sh t1, 0(t0)
		ret
		
.data
.include "sprites/tile.s"
.include "sprites/map.s"
.include "sprites/char.s"
