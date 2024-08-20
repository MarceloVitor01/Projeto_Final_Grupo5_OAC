.text
SETUP:		la a0, map
		li a1, 0
		li a2, 0
		li a3, 0
		call PRINT
		li a3, 1
		call PRINT
	
GAME_LOOP:	xori s0, s0, 1

		la a0, char
		li a1, 16
		li a2, 0
		mv a3, s0
		call PRINT
		
		li t0, 0xFF200604
		sw s0, 0(t0)
	
#
#	a0 = endereço imagem
#	a1 = x
#	a2 = y
#	a3 = frame (0 ou 1)
##
#
#	t0 = endereço do bitmap display
#	t1 = endereço da imagem
#	t2 = contador de linha
#	t3 = contador de coluna
#	t4 = largura
#	t5 = altura
#
PRINT:		li t0, 0xFF0
		add t0, t0, a3
		slli t0, t0, 20
		
		add t0, t0, a1
		
		li t1, 320
		mul t1, t1, a2
		add t0, t0, a1
		
		addi t1, a0, 8
		
		mv t2, zero
		mv t3, zero
		
		lw t4, 0(a0)
		lw t5, 4(a0)
	
PRINT_LINHA:	lw t6, 0(t1)
		sw t6, 0(t0)
		
		addi t0, t0, 4
		addi t1, t1, 4
		
		addi t3, t3, 4
		blt t3, t4, PRINT_LINHA
		
		addi t0, t0, 320
		sub t0, t0, t4
		
		mv t3, zero
		addi t2, t2, 1
		bgt t5, t2, PRINT_LINHA
		
.data
.include "sprites/flamengo.s"
.include "sprites/map.s"
.include "sprites/char.s"