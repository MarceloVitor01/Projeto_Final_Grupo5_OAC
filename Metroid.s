.text
# s0 = CONTADOR DE FRAME PARA GAME_LOOP

# s1 = GUARDA O �NDICE DA LINHA NA HORA DE PRINTAR O MAPA / ARMAZENA SE O PERSONAGEM IR� COLIDIR OU N�O (0 PARA SIM E 1 PARA N�O)
# S2 = GUARDA O �NDICE DA COLUNA NA HORA DE PRINTAR O MAPA

# S3 = PONTEIRO DA CABE�A DAS LISTAS ENTIDADES_INFO, OLD ENTIDADES_INFO E NEXT_ENTIDADES_INFO
# S4 = PONTEIRO QUE INDICA O ENDERE�O PARA ADICIONAR O PR�XIMO ITEM NA LISTAS

# S5 = ARMAZENA SE O PERSONAGEM EST� CAINDO, PARADO ou SUBINDO (0 PARA CAINDO, 1 PARA NO CH�O E 2 PARA SUBINDO) / ARMAZENA O PULO DO PERSONAGEM 
# S6 =
# S7 =
# S8 = 
# S9 =  

# S10 = SALVA SE O PERSONAGEM GANHOU O JOGO / PASSOU DE N�VEL
# S11 = SALVA O MAPA ATUAL

MAIN: la s3, ENTIDADES_INFO       # ENDERE�O DA LISTA CONTENDO AS ENTIDADES
      addi s4, s3, 24             # ENDERE�O DA LISTA ONDE DEVE SER SALVO O PR�XIMO ITEM
      
      la s11, mapa_1
      li s5, 1 
      call SETUP
      
      #la s11, mapa_2
      #call SETUP
      #la s11, mapa_3
      
      # SALVA OS OUTROS MAPAS

#------------------------JOGO----------------------------------------------

SETUP:    # INICIALIZA X E Y COMO ZERO
	   li a1, 0
	   li a2, 0
	   
	   # Loop para percorrer cada linha e coluna do mapa
	   li s1, 0                    # �ndice da linha
	   li s2, 0                    # �ndice da coluna
	   
	   addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call PRINT_MAP
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
	   
	   li s1, 0                    # Verificador de Colis�o
	   li s2, 0                    # Verificador de Gravidade
	   
	   li s0, 0                    # Frame de in�cio
    	   li s10, 1                   # Pointer de vit�ria
    	   
	   addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call GAME_LOOP
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
	   
	   ret
       
GAME_LOOP: addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call KEY
           lw ra, 0(sp)                # Restaura ra da pilhad
           addi sp, sp, 4              # Ajusta a pilha de volta
          
	   xori s0, s0, 1
 	   
 	   la t0, ENTIDADES_INFO
	   lh t1, 12(t0)                # LOAD O FRAME ATUAL DA SAMUS (t0 + 8 = OLD_ENTIDADES_INFO)
	   
	   li t2, 520
	   mul t1, t1, t2
	   
	   la a0, samus_parada
	   add a0, a0, t1	   
	   
 	   lh a1, 0(t0)                # Imprime a posi��o X do personagem
 	   lh a2, 2(t0)                # Imprime a posi��o Y do personagem
 	   mv a3, s0
 	   
 #	   lh t0, 20(t0)
# 	   beq t0, zero, PRINT_DIR    # SE A SAMUS ESTIVER INDO PARA A DIREITA, PRINTE O SPRITE NORMAL, CASO A SAMUS ESTEJA INDO PARA A ESQUERDA, PRINTA ESPELHADO
 	   
#PRINT_ESQ: addi sp, sp, -4             # Ajusta a pilha para salvar ra
#    	   sw ra, 0(sp)                # Salva ra na pilha
#           call PRINT_ESPELHAR
#           lw ra, 0(sp)                # Restaura ra da pilha
#           addi sp, sp, 4              # Ajusta a pilha de volta
#           
#           j VOLTA_LOOP 
 	   
PRINT_DIR: addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call PRINT
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
 	   
VOLTA_LOOP:li t0, 0xFF200604
 	   sw s0, 0(t0)
 	   
 	   beq s10, zero, FIM_LOOP
 	   j GAME_LOOP
 	   
FIM_LOOP:  ret                         # QUANDO O PERSONAGEM PASSA DE FASE, O LOOP ACABA E ELE VOLTA PARA SETUP, ONDE O SEGUNDO MAPA SER� CARREGADO E O LOOP RETORNA

#------------------------------------------------ MOVIMENTA��O DA SAMUS, BOSSES E ENTIDADES-----------------------------------------------------------------------

KEY: la a3, ENTIDADES_INFO                       # SALVA EM A3 A POSI��O X, Y DA SAMUS E OS ATRIBUTOS DE ENTIDADES_INFO (VIDA E TIPO)
     addi a4, a3, 8                              # SALVA EM A4 A POSI��O ANTIGA DA SAMUS E OS ATRIBUTOS DE OLD_ENTIDADES_INFO (FRAME ATUAL E FRAME ANTIGO)
     addi a5, a4, 8                              # SALVA EM A5 A PR�XIMA POSI��O X DA SAMUS E OS ATRIBUTOS DE NEXT_ENTIDADES_INFO (CIMA/BAIXO E ESQUERDA/DIRETIA)

     li t1, 0xFF200000                 # carrega o endere�o do controle do KDMMIO
     lw t0, 0(t1)                      # Le bit de Controle Teclado
     andi t0, t0, 0x0001               # mascara o bit menos significativo
     beq t0, zero, FIM                 # Se n�o h� tecla pressionada ent�o vai para FIM
     lw t2, 4(t1)                      # le o valor da tecla tecla
     
     #------------------------------------------
     
     li t6, 'w'
     beq s5, zero, CHAR_RET            # S2 ARMAZENA SE O PERSONAGEM EST� CAINDO, 0 PARA CAINDO E 1 PARA N�O, CASO ELE ESTEJA CAINDO, N�O PODE PULAR
     beq t2, t6, CHAR_PULA
     
     #-------------------------------------------
     
     li t6, 'a'
     beq t2, t6, CHAR_ESQ
     
     #-------------------------------------------
     
     li t6, 's'
     #beq t2, t6, CHAR_AGACHA
     
     #-------------------------------------------
     
     li t6, 'd'
     beq t2, t6, CHAR_DIR
     
     #-------------------------------------------

FIM: #sh zero, 4(a4)                    # CARREGA O FRAME ATUAL E O FRAME ANTIGO COMO ZERO
     #sh zero, 6(a4)
     ret


CHAR_ESQ:  li t0, 1
           sh t0, 4(a5)                # muda o valor ESQUERDA/DIREITA do personagem para 1, pois ele est� andando para a ESQUERDA

           lh a1, 0(a5) 
           addi a1, a1, -4             # altera NEXT_CHAR_POS 4 PIXELS PARA A ESQUERDA
           sh a1, 0(a5)
           lh a2, 2(a5)                # Carrega a NEXT coordenada Y
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           lh t0, 6(a3)               # CHAMA O TIPO DA ENTIDADE QUE SER� CALCULADA A COLIS�O, POIS A SAMUS TEM COLIS�O ESPECIAL
           beq t0, zero, COL_SAMUS
           j RESUL_COL
           
           #-------------------------------------------------------------------------------------------------------------------------------------
	  
CHAR_DIR:  sh zero, 4(a5)              # muda o valor ESQUERDA/DIREITA do personagem para 0, pois ele est� andando para a DIREITA
           
           lh a1, 0(a5) 
           addi a1, a1, 4              # altera NEXT_CHAR_POS 4 PIXELS PARA A DIRETIA
           sh a1, 0(a5)
           lh a2, 2(a5)                # Carrega a NEXT coordenada Y
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
              
           lh t0, 6(a3)                # CHAMA O TIPO DA ENTIDADE QUE SER� CALCULADA A COLIS�O, POIS A SAMUS TEM COLIS�O ESPECIAL
           beq t0, zero, COL_SAMUS
           j RESUL_COL
           
           #-------------------------------------------------------------------------------------------------------------------------------------
           
COL_SAMUS: beq s1, zero, RESUL_COL      
           mv s9, s1                  # SALVA O RESULTADO DA COLIS�O (X, Y) DA SAMUS (OU SEJA, A PARTE SUPERIOR DA SAMUS)

           addi a2, a2, 16            # ADICIONA 16 � POSI��O Y DA SAMUS E CHAMA A COLIS�O DE NOVO, OU SEJA, CALCULA A COLIS�O DA PARTE DE BAIXO
           
           addi sp, sp, -4            # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)               # Salva ra na pilha
           call CHECK_COLISAO
           lw ra, 0(sp)               # Restaura ra da pilha
           addi sp, sp, 4             # Ajusta a pilha de volta
           
           and s1, s1, s9
           j RESUL_COL
           
           #-------------------------------------------------------------------------------------------------------------------------------------
           
CHAR_CIMA: lh a1, 0(a5)                # Carrega a NEXT coordenada X
           lh a2, 2(a5) 
           addi a2, a2, -4              # altera NEXT_CHAR_POS 4 PIXELS PARA CIMA
           sh a2, 2(a5)

           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           j RESUL_COL
           #----------------------------------------------------------------------------------
	   
CHAR_DOWN: # lh a1, 0(a5)              # Carrega a NEXT coordenada X e Y
           # lh a2, 2(a5) 
           
           li t0, 2
           sh t0, 4(a5)                # Isso precisa ser 1 para n�o somar 15 
           
           addi a2, a2, 4              # altera NEXT_CHAR_POS 4 PIXELS PARA BAIXO
           sh a2, 2(a5)

           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           ret
           
           #----------------------------------------------------------------------------------

#---------------------------------------OPERA��ES QUE USAM CHAR_CIMA E CHAR_DOWN-----------------------------------------------------------------------------
	   
CHAR_PULA: # USAR A FUN��O CHAR_CIMA PARA IMPLEMENTAR A FUN��O CHAR_PULAR
           

GRAVIDADE: lh a1, 0(a5)                # Load da next posi��o x, y da entidade
           lh a2, 2(a5)
           
           lh t0, 6(a3)                # CHAMA O TIPO DA ENTIDADE QUE SER� CALCULADA A COLIS�O, POIS A SAMUS TEM 32 DE ALTURA, E N�O 16
           beq t0, zero, GRAVIDADE_SAMUS
           
           addi a2, a2, 15
           j GRAVIDADE_LOOP
           
GRAVIDADE_SAMUS: addi a2, a2, 31

GRAVIDADE_LOOP : addi sp, sp, -4             # Ajusta a pilha para salvar ra
		 sw ra, 0(sp)                # Salva ra na pilha
           	 call CHAR_DOWN
           	 lw ra, 0(sp)                # Restaura ra da pilha
           	 addi sp, sp, 4              # Ajusta a pilha de volta
           	 
           	 mv s9, s1
           	 
           	 addi a1, a1, 10             # SOMA 10 PARA TERMOS A POSI��O DO SEGUNDO P� DA SAMUS
           	 
           	 addi sp, sp, -4             # Ajusta a pilha para salvar ra
		 sw ra, 0(sp)                # Salva ra na pilha
           	 call CHAR_DOWN
           	 lw ra, 0(sp)                # Restaura ra da pilha
           	 addi sp, sp, 4              # Ajusta a pilha de volta
           	 
           	 addi a1, a1, -10            # Volta para a posi��o original da Samus
           	 
           	 mv s8, s1
		
		 and s1, s9, s8              # SE UM DOS DOIS P�S DA SAMUS ESTIVEREM TOCANDO O CH�O, ENT�O O RESULTADO DO AND SER� 0
		 
		 li t0, 1
		 beq s1, t0, ENTIDADE_CAI
		 
		 lw t3, 0(a3)  # CORRIGE NEXT_CHAR_POS PARA O CASO EM QUE O PERSONAGEM COLIDE
	   	 sw t3, 0(a5)

		 ret
		 
ENTIDADE_CAI:   lw t3, 0(a3)                # COMO O PERSONAGEM N�O IR� COLIDIR, PODEMOS ATUALIZAR CHAR_POS E OLD_CHAR_POS 
                sw t3, 0(a4)                # AGORA OLD_CHAR_POS PASSA A SER CHAR_POS
                
                lh a1, 0(a3)                 # AGORA CHAR_POS PASSA A SER NEXT_CHAR_POS
                lh a2, 2(a3)
                
                sh zero, 4(a4)              # CARREGA O FRAME ATUAL E O FRAME ANTIGO COMO ZERO
    	        sh zero, 6(a4)
    	        
    	        j GRAVIDADE_LOOP
           
#----------------------------------------------------------COLIS�O--------------------------------------------------------------------------------------------------

CHECK_COLISAO: li t6, 16
               li t5, 20
               la s11, mapa_1
               
               lh t1, 4(a5)
               beq t1, zero, ANDANDO_DIR  # VERIFICA SE A ENTIDADE EST� ANDANDO PARA A DIREITA, NESSE CASO, � NECESS�RIO SOMAR 15 NA POS X PARA CALCULAR A POSI��O
               
               mv t1, a1
               mv t2, a2
               j COLIDE_NORMAL         
               
ANDANDO_DIR:  mv t1, a1              # Carrega a NEXT coordenada X
              addi t1, t1, 15
              mv t2, a2              # Carrega a NEXT coordenada Y
              j COLIDE_NORMAL
               
COLIDE_NORMAL: div t1, t1, t6
               div t2, t2, t6
               
               mul t2, t2, t5            # AP�S A DIVIS�O, T2 POSSUI A LINHA Y DA MATRIZ MAPA ONDE A PARTE DE BAIXO DA SAMUS (OU UMA ENTIDADE DE TAMANHO 16) EST�
                                      
               add t2, t1, t2            # AP�S MULTIPLICAR POR 20 E SOMAR COM A COMPONENTE X, TEMOS EXATAMENTE O BYTE PARA ONDE SAMUS ANDAR�
               
               add s11, s11, t2          # SOMAMOS S11 A T2 PARA SABER QUAL BYTE DO MAPA �, SE ELE FOR DO TIPO QUE COLIDE (TIJOLO OU METAL) RETORNA 0
               
               lb t3, 0(s11)
               
               li t4, 0
               beq t3, t4, COLIDE
               
               li t4, 1
               beq t3, t4, COLIDE
               
               li s1, 1
               ret
               
COLIDE:        li s1, 0
               ret

#----------------------------------------------------------------------------------------------------------------------------------------------------
	  
RESUL_COL: beq s1, zero, CHAR_RET      # S1 ARMAZENA SE O PERSONAGEM IR� COLIDIR OU N�O, 0 PARA COLIDIR E 1 PARA N�O
	    
	   mv t0, s5
	   li t1, 2                    # SE O PERSONAGEM ESTIVER SUBINDO, SEU FRAME ATUAL SER� 4
	   beq t0, t1, SUBIR
          
           lh t0, 4(a4)                # CARREGA O FRAME ATUAL
           
           beq t0, zero, FRAME_1       # SE O PERSONAGEM EST� PARADO, ELE COME�A A ANDAR E VAI PARA O FRAME 1
            
           li t3, 1               
           beq t0, t3, F_ATUAL_1       # SE O PERSONAGEM EST� NO FRAME 1, ELE PODE IR PARA O FRAME 2 OU FRAME 3, DEPENDENDO DE QUAL � SEU FRAME ANTERIOR
            
           li t3, 2                    # SE O PERSONAGEM EST� NO FRAME 2, ELE VAI PARA O FRAME 1
           beq t0, t3, FRAME_1
            
           li t3, 3
           beq t0, t3, FRAME_1         # SE O PERSONAGEM EST� NO FRAME 3, ELE VAI PARA O FRAME 1

RESTO_COLISAO:
           lw t3, 0(a3)                # COMO O PERSONAGEM N�O IR� COLIDIR, PODEMOS ATUALIZAR CHAR_POS E OLD_CHAR_POS 
           sw t3, 0(a4)                # AGORA OLD_CHAR_POS PASSA A SER CHAR_POS
           
           lw t3, 0(a5)                # COMO O PERSONAGEM N�O IR� COLIDIR, PODEMOS ATUALIZAR CHAR_POS E NEXT_CHAR_POS 
           sw t3, 0(a3)                # AGORA CHAR_POS PASSA A SER NEXT_CHAR_POS
           
           j APAGA_OLD_POS

#-------------------------------------------ANIMA��OD DA MOVIMENTA��O DO PERSONAGEM E DAS ENTIDADES----------------------------------------------------------
     	   
SUBIR:    lh t0, 4(a4)                # PEGA O FRAME ATUAL E PASSA PARA A POIS��O DO FRAME ANTIGO
          sh t0, 6(a4)
          
          li t0, 4                    # SETA O FRAME 4 COMO FRAME ATUAL (samus_pulando, no caso da Samus)
     	  sh t0, 4(a4)    
     	  
     	  j RESTO_COLISAO 
     	   
FRAME_1:  lh t0, 4(a4)                # PEGA O FRAME ATUAL E PASSA PARA A POIS��O DO FRAME ANTIGO
          sh t0, 6(a4)
          
          li t0, 1                    # SETA O FRAME 1 COMO FRAME ATUAL (samus_andando_1, no caso da Samus e escorpiao_andando_1 no caso do escorpi�o)
          sh t0, 4(a4)
          
          j RESTO_COLISAO       
          
F_ATUAL_1:lh t0, 6(a4)               # CARREGA O FRAME ANTIGO, O CICLO DE CAMINHADA DA SAMUS � PARADA -> ANDANDO_1 -> ANDANDO_2 -> ANDANDO_1 -> ANDANDO_3 -> ANDANDO_ 1 -> ANDANDO_2 -> ..

          li t1, 2                    # SE O FRAME ANTIGO FOR ANDANDO_2, VAI PARA ANDANDO_3
          beq t0, t1, FRAME_3
             
          li t1, 3                    # SE O FRAME ANTIGO FOR ANDANDO_3, VAI PARA ANDANDO_2
          beq t0, t1, FRAME_2
          
          beq t0, zero, FRAME_2       # SE O FRAME ANTIGO FOR PARADA, VAI PARA ANDANDO_2
          
FRAME_2:  lh t0, 4(a4)               # PEGA O FRAME ATUAL E PASSA PARA A POIS��O DO FRAME ANTIGO
          sh t0, 6(a4)
          
          li t0, 2                   # SETA O FRAME 1 COMO FRAME ATUAL (samus_andando_1, no caso da Samus e escorpiao_andando_1 no caso do escorpi�o)
          sh t0, 4(a4)
          
          j RESTO_COLISAO       

FRAME_3:  lh t0, 4(a4)               # PEGA O FRAME ATUAL E PASSA PARA A POIS��O DO FRAME ANTIGO
          sh t0, 6(a4)
          
          li t0, 3                   # SETA O FRAME 1 COMO FRAME ATUAL (samus_andando_1, no caso da Samus e escorpiao_andando_1 no caso do escorpi�o)
          sh t0, 4(a4)      
     	   
     	  j RESTO_COLISAO 

		
CHAR_RET:  lw t3, 0(a3)  # CORRIGE NEXT_CHAR_POS PARA O CASO EM QUE O PERSONAGEM COLIDE
	   sw t3, 0(a5)
	   ret
	   
APAGA_OLD_POS: 
           la a0, old_char_pos         # Apaga a posi��o antiga da SAMUS no frame que vai ser escondido
 	   lh a1, 0(a4)
 	   lh a2, 2(a4)
 	   
 	   li a3, 0
 	   
 	   addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call PRINT
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           li a3, 1
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call PRINT
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           ret

#---------------------------------------------------------------IAs DOS INIMIGOS-------------------------------------------------------------------

IA_INIMIGO:    mv t0, s3

	       lh t1, 0(s3)                # X e Y Samus
	       lh t2, 2(s3)
              
               addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                # Salva ra na pilha
               call INIMIGO_LOOP
               lw ra, 0(sp)                # Restaura ra da pilha
               addi sp, sp, 4              # Ajusta a pilha de volta
             
               ret
          
INIMIGO_LOOP:  beq t0, s4, FINAL_LOOP      # QUANDO CHEGA NO FIM DA LISTA, ENCERRA O LOOP
               addi t0, t0, 24
               
               mv a3, t0                   # Salva ENTIDADE_INFO EM A3
               addi a5, a3, 16             # Salva NEXT_ENTIDADE_INFO EM A5
              
               lh t3, 4(a3)               # Vida dA ENTIDADE
	       beq t3, zero, INIMIGO_FIM  # se o inimigo estiver morto, nada acontece
	     
	       lh t3, 6(a3)               # carrega o tipo da entidade
	       
	       li t4, 1
	       beq t3, t4, SCORPIO_TURN
	      
	       li t4, 2
	       beq t3, t4, VOADOR_TURN
	       
	       #li t4, 3
	       #beq t3, t4, PROJETIL_INIMIGO
	       
	       #lh t4, 6(t0)
	       #li t5, 4
	       #beq t4, t5, PINWHEEL_TURN
	       
#--------------------------------------------------------------------------------------------------------------------------------------
# Descreve o comportamento do tipo de inimigo ESCORPI�O
SCORPIO_TURN:  lh a1, 0(a3)             # salva a posi��o X do Inimigo
	       lh a2, 2(a3)             # salva a posi��o Y do Inimigo
	       
	       sub t3, a2, a2
	       addi t3, t3, 16
	       
	       sub t4, a1, t1
	       
	       and t3, t4, t3
	       beq t3, zero, SAMUS_DANO
	     
	      # Fazer um AND entre "est� na mesma cordenada Y" e "Estar dentro do INTERVALO DE ATAQUE do inimigo"
	      
	      #----------------------------------------COMPARA A POSI��O Y DA SAMUS E DO ESCORPI�O----------------------------------------------------------
	      
	       lh t1, 2(s3)                 # SALVA EM T1 A POSICAO Y DA SAMUS
	       addi t1, t1, 16              # A POSI��O Y DA SAMUS � A DA CABE�A DELA, QUE TEM 32 PIXELS, PARA COMPARAR COM O ESCORPI�O PRECISAMOS SOMAR 16
	       
	       sub t1, t1, a2               # CASO A SAMUS E O ESCORPI�O ESTEJAM NO MESMO ANDAR, T4 SER� ZERO
	       bne t1, zero, SCORPIO_ANDA   # CASO ELES N�O ESTEJAM NO MESMO ANDAR, O ESCORPI�O APENAS ANDA
	       xori t1, t1, 1               # CASO T4 SEJA 0 (MESMA COORDENADA Y) TRANSFORMA T4 EM 1
	     
	      #-----------------------------------------COMPARA A POSI��O X DA SAMUS E DO ESCORPI�O-------------------------------------------------------------
	      
               lh t2, 0(s3)                 # COLOCA EM T1 A POSI��O X DA SAMUS
               
      	       addi t3, a1, -32             # verifica se o personagem est� 3 tiles na frente do inimigo
	       addi t4, a1, 32              # verifica se o personagem est� 2 tiles atr�s do inimigo
	     
	       slt t5, t2, t4               # T2 TEM que ser menor que T4 para que o inimigo ataque (SAMUS EST� DENTRO DO CAMPO DE VIS�O DA DIREITA DO INIMIGO)
	       slt t6, t3, t2               # T2 TEM que ser maior que T3 para que o inimigo ataque (SAMUS EST� DENTRO DO CAMPO DE VIS�O DA ESQUERDA DO INIMIGO)
	     
	       #----------------------------TABELA VERDADE DO ESCORPI�O ATACAR------------------------------
	       #
	       #        T5      T6          T2 (ATACAR)  |      T1    T2      ATACAR
	       #        0       0           0            |      0     0         0
	       #        0       1           0            |      0     1         0
	       #        1       0           0            |      1     0         0
	       #        1       1           1            |      1     1         1
	     
	       and t2, t6, t5                 # VERIFICA SE O SAMUS EST� NO RANGE DE ATAQUE DO INIMIGO
	     
	       #------------------------------------------------------------------------------------------------------------
	       and t4, t1, t2                 # VERIFICA SE A SAMUS EST� NO RANGE DE ATAQUE DO INIMIGO E NA MESMA ALTURA. 
	       xori t4, t4, 1                 # PRECISO TRANSFORMAR O RESULTADO EM ZERO PARA FAZER O BRANCH, CASO ELE SEJA 1
	       beq t4, zero, SCORPIO_ATACK
	       j SCORPIO_ANDA
	     
SCORPIO_ATACK: # C�DIGO PARA FAZER O ESCORPI�O LAN�AR UM PROJ�TIL NA DIRE��O DO PERSONAGEM
	       # C�DIGO PARA FAZER O ESCORP�O ANDAR NA DIRE��O DO PERSONAGEM
	       j INIMIGO_FIM
	     
SCORPIO_ANDA:  lh a1, 0(a5)
	       lh a2, 2(a5)

	       addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                # Salva ra na pilha
               jal ra, CHAR_ESQ            # Chama a fun��o CHAR_ESQ
               lw ra, 0(sp)                # Restaura ra da pilha
               addi sp, sp, 4              # Ajusta a pilha de volta
               
               
        
               j INIMIGO_FIM
#--------------------------------------------------------------------------------------------------------------------------------------
# Descreve o comportamento do tipo de inimigo VOADOR0
VOADOR_TURN:   lw a1, 0(t0) # salva a posi��o X do Inimigo
	       lw a2, 4(t0) # salva a posi��o Y do Inimigo

VOADOR_ATACK:

VOADOR_VOA:
#--------------------------------------------------------------------------------------------------------------------------------------
# DESCREVE O COMPORTAMENTO DE UM PROJ�TIL
PROJETIL_INIMIGO_TURN:

PROJETIL_INIMIGO_ATAK:

PROJETIL_INIMIGO_ANDA:
#--------------------------------------------------------------------------------------------------------------------------------------
# DESCREVE O COMPORTAMENTO DE UM PROJ�TIL
PROJETIL_SAMUS_1_TURN:

PROJETIL_SAMUS_1_ATAK:

PROJETIL_SAMUS_1_ANDA:
#-------------------------------------------------------------------------------------------------------------------------------------
# DESCREVE O COMPORTAMENTO DE UM PROJ�TIL
PROJETIL_SAMUS_2_TURN:

PROJETIL_SAMUS_2_ATAK:

PROJETIL_SAMUS_2_ANDA:
#-------------------------------------------------------------------------------------------------------------------------------------
SAMUS_DANO:    lh t3, 4(s3)
               addi t3, t3, -1
               sh t3, 3(s3)

INIMIGO_FIM:   j INIMIGO_LOOP

FINAL_LOOP:    ret
		    
#---------------------------------------------------------------LINKED LIST--------------------------------------------------------------------------
ADD_ITEM:
    # SE O �NDICE DO ITEM FOR 23, SIGNIFICA QUE A LISTA EST� CHEIA
    
    addi t6, s4, -24       # CALCULA O ENDERE�O DO �LTIMO ITEM
    lh t5, 22(t6)          # CARREGA O �NDICE DO ELEMENTO ANTERIOR
    addi t5, t5, 1
    
    li t4, 25
    beq t5, t4, LISTA_CHEIA
    
    mv t0, s4
    j ADD_ENTIDADE         

ADD_ENTIDADE:
    # Carregar endere�o atual para adicionar na lista `entidades_info`
    sh a1, 0(t0)           # Salvar posi��o x
    sh a2, 2(t0)           # Salvar posi��o y
    sh t0, 4(t0)           # Salva a vida da Entidade
    sh t1, 6(t0)           # Salva o tipo da Entidade
    
    sh a1, 8(t0)           # Salvar old_posi��o_x
    sh a2, 10(t0)          # Salvar old_posi��o_y
    sh zero, 12(t0)        # salva o frame atual 
    sh zero, 14(t0)        # salva o frame antigo
    
    sh a1, 16(t0)          # Salvar next_posi��o_x
    sh a2, 18(t0)          # Salvar next_posi��o_y
    sh t2, 20(t0)          # Salva esquerda/direita
    sh t5, 22(t0)          # Salva o �ndice
    
    addi s4, s4, 24
    ret

SOBRESCREVE_ITEM:
   mv t0, t5
   j ADD_ENTIDADE

LISTA_CHEIA:
    mv t6, s3
    j GARBAGE_COLLECTOR

GARBAGE_COLLECTOR:
   lw t5, 16(t6)
   
   li t4, 26
   beq t4, t5, SOBRESCREVE_ITEM
   
   li t4, 25
   beq t4, t5, SEM_ESPACOS_LIVRES
   
   addi t6, t6, 24
   j GARBAGE_COLLECTOR
   
SEM_ESPACOS_LIVRES:
   ret
#----------------------------------------------------------------PRINT--------------------------------------------------------------------------------

# a0 = endere�o imagem
# a1 = x (coluna)
# a2 = y (linha)
# a3 = frame (0 ou 1)
#
##
#
# t0 = endere�o do bitmap display
# t1 = endere�o da imagem
# t2 = contador de linha
# t3 = contador de coluna
# t4 = largura
# t5 = altura 
# 

PRINT_ESPELHAR: 
    li t0, 0xFF0               # Carrega valor base para calcular endere�o na VRAM
    add t0, t0, a3             # Adiciona posi��o X do tile
    slli t0, t0, 20            # Ajusta o endere�o da VRAM

    add t0, t0, a1             # Adiciona posi��o Y
                              
    li t1, 320                 # Largura da tela (em palavras)
    mul t1, t1, a2             # Multiplica pelo deslocamento em Y (a2 � a linha atual)
    add t0, t0, t1             # Ajusta o endere�o final na VRAM
                              
    addi t1, a0, 8             # Endere�o do come�o do array de dados do tile

    mv t2, zero                # t2 = linha atual
    mv t3, zero                # t3 = pixel atual na linha

    lw t4, 0(a0)               # t4 = largura do tile
    lw t5, 4(a0)               # t5 = altura do tile

PRINT_LINHA_ESP:
    add s9, t1, t4             # Calcula endere�o para o fim da linha
    addi s9, s9, -4            # Ajusta para o �ltimo pixel da linha (j� que usamos -4)

    # Inverte a linha atual, copiando de tr�s para frente
INVERTE_LINHA:
    lw t6, 0(s9)               # Carrega o �ltimo pixel na linha
    sw t6, 0(t0)               # Escreve na posi��o atual de destino

    addi t0, t0, 4             # Move o destino para o pr�ximo pixel
    addi s9, s9, -4            # Move para o pixel anterior na origem

    addi t3, t3, 4             # Conta pixels invertidos
    blt t3, t4, INVERTE_LINHA  # Continua enquanto n�o inverteu toda a linha

    addi t0, t0, 320           # Pula para a pr�xima linha na VRAM
    sub t0, t0, t4             # Ajusta posi��o inicial para pr�xima linha

    mv t3, zero                # Reseta pixel atual
    addi t2, t2, 1             # Vai para a pr�xima linha

    blt t2, t5, PRINT_LINHA_ESP # Continua enquanto n�o printou todas as linhas

    ret


PRINT:       
    li t0, 0xFF0
    add t0, t0, a3
    slli t0, t0, 20
    	     
    add t0, t0, a1
    	     
    li t1, 320
    mul t1, t1, a2
    add t0, t0, t1
    	     
    addi t1, a0, 8
    	     
    mv t2, zero
    mv t3, zero
    	     
    lw t4, 0(a0)
    lw t5, 4(a0)
    	     
       
PRINT_LINHA: 
    lw t6, 0(t1)
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
		     
    ret
	     
PRINT_TILE:
    li a3, 0
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    li a3, 1
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha 
    call PRINT
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    ret

PRINT_MAP:
    # Calcular a posi��o x e y com base nos �ndices de linha e coluna
    li t6, 16
    mul a1, s2, t6              # X = coluna DO MAPA * 16
    mul a2, s1, t6              # Y = linha DO MAPA * 16
    
    la a0, tijolos
    lb t2, 0(s11)               # Carrega o byte atual do mapa 
    
    li t6, 7
    beq t2, t6, ADD_VOADOR
    
    li t6, 8
    beq t2, t6, ADD_ESCORPIAO
    
    li t6, 9
    beq t2, t6, NEXT_PIXEL
    
    li t6, 264                  # CADA TILE DO MAPA TEM 256 BYTES (16 X 16 PIXELS, CADA PIXEL TEM 1 BYTE)
    mul t2, t2, t6
    add a0, a0, t2              # O ENDERE�O DO TILE METAL EST� 256 BYTES DEPOIS DE TIJOLOS, ENT�O SE T2 = 1 => TIJOLOS + (1 x 256) = METAL
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    j NEXT_PIXEL
    
ADD_VOADOR:
    la a0, voador_1
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta

    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha
    li t0, 2                    # VIDA DA ENTIDADE
    li t1, 2                    # TIPO DA ENTIDADE
    li t2, 0                    # ESQ/DIR
    call ADD_ITEM
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
	   
    j NEXT_PIXEL

ADD_ESCORPIAO:
    la a0, escorpiao_andando_1
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha
    li t0, 1                    # VIDA DA ENTIDADE
    li t1, 1                    # TIPO DA ENTIDADE
    li t2, 1                    # ESQ/DIR
    call ADD_ITEM
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
	   
    j NEXT_PIXEL
    
NEXT_PIXEL:
    # Avan�a para o pr�ximo pixel (coluna)
    addi s11, s11, 1    # Avan�a para o pr�ximo byte do mapa
    addi s2, s2, 1      # Pr�xima coluna
    
    li t3, 20           # Total de colunas
    blt s2, t3, PRINT_MAP
    mv s2, zero

    # Pr�xima linha
    addi s1, s1, 1
        
    li t3, 16         # Total de linhas (excluindo a primeira)
    blt s1, t3, PRINT_MAP
    
    ret
.data
#--------------------------------------------------LISTAS------------------------------------------------------------------------

ENTIDADES_INFO: .half 32, 32, 5, 0,              # X = 32, Y = 32, Vida = 10, Tipo da entidade = 0       (CHAR_POS, VIDA, TIPO)
                      32, 32, 0, 0,               # X = 32, Y = 32, Frame atual = 0, Frame passado = 0    (OLD_CHAR_POS, FRAMES_ANIMA��O)
                      32, 32, 0, 1                # X = 32, Y = 32, ESQ/DIR = 0, �NDICE                   (NEXT_CHAR_POS, ESQ/DIR, �NDICE)
                      
		.space 576                        # Cada entidade tem 24 bytes, quero que a lista tenha 25 entidades

#--------------------------------------------------TILES------------------------------------------------------------------------
tijolos: .word 16, 16
         .byte 173,173,173,173,0,0,173,173,173,173,173,0,173,173,173,0,
               173,173,173,173,173,0,173,173,173,173,173,0,173,173,173,0,
               173,173,173,173,173,0,173,173,173,173,173,0,0,173,173,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               173,173,173,0,173,173,173,173,0,0,0,173,173,173,173,0,
               173,173,173,0,173,173,173,173,173,0,173,173,173,173,173,0,
               173,173,0,0,173,173,173,173,173,0,173,173,173,173,173,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               173,173,173,173,173,0,0,173,173,173,173,0,173,173,173,0,
               173,173,0,173,173,0,173,173,173,173,173,0,173,173,173,0,
               173,0,0,173,173,0,173,173,173,173,173,0,173,173,173,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,173,173,0,173,173,173,173,173,0,173,173,173,173,173,0,
               173,173,173,0,0,173,173,173,173,0,173,173,173,173,173,0,
               173,173,173,0,0,173,173,173,173,0,173,173,173,173,0,0,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

metal: .word 16, 16
       .byte 164,164,164,164,164,164,164,0,0,164,164,164,164,164,164,164,
             164,164,164,164,164,164,164,0,0,164,164,164,164,164,164,164,
             164,164,  0,164,  0,164,164,0,0,164,164,  0,164,  0,164,164,
             164,164,  0,164,  0,164,164,0,0,164,164,  0,164,  0,164,164,
             164,164,  0,164,  0,164,164,0,0,164,164,  0,164,  0,164,164,
             164,164,164,164,164,164,164,0,0,164,164,164,164,164,164,164,
             164,164,164,164,164,164,164,0,0,164,164,164,164,164,164,164,
               0,  0,  0,  0,  0,  0,  0,0,0,  0,  0,  0,  0,  0,  0,  0,
               0,  0,  0,  0,  0,  0,  0,0,0,  0,  0,  0,  0,  0,  0,  0,
             164,164,164,164,164,164,164,0,0,164,164,164,164,164,164,164,
             164,164,164,164,164,164,164,0,0,164,164,164,164,164,164,164,
             164,164,  0,164,  0,164,164,0,0,164,164,  0,164,  0,164,164,
             164,164,  0,164,  0,164,164,0,0,164,164,  0,164,  0,164,164,
             164,164,  0,164,  0,164,164,0,0,164,164,  0,164,  0,164,164,
             164,164,164,164,164,164,164,0,0,164,164,164,164,164,164,164,
             164,164,164,164,164,164,164,0,0,164,164,164,164,164,164,164


# PR�XIMO TILE,  QUE SER� IDENTIFICADO COMO 2

# PR�XIMO TILE, QUE SER� IDENTIFICADO COMO 3

# ETC...

# 7 � PARA VOADOR, N�O PODE SER TILE
# 8 � PARA ESCORPI�O, N�O PODE SER TILE
# 9 � VAZIO, N�O PODE SER TILE 

#--------------------------------------------------MAPAS------------------------------------------------------------------------
mapa_1: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	      0,9,9,9,9,9,9,9,9,9,7,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,8,9,9,1,9,9,9,8,9,9,9,8,0,
              0,0,0,0,0,0,0,0,0,9,9,9,0,0,0,0,0,0,0,0,
              0,0,9,9,9,9,9,9,0,9,9,9,0,9,9,9,9,9,0,0,
              0,9,9,9,9,9,9,9,0,9,9,1,0,9,9,9,9,9,9,0,
              0,9,9,9,9,9,7,9,0,9,7,9,0,8,9,9,7,9,9,0,
              0,9,9,9,9,9,9,1,0,1,9,9,0,0,0,9,9,9,9,0,
              0,9,9,9,1,0,0,0,0,9,9,9,0,9,9,9,0,0,0,0,
              0,9,9,1,0,9,9,9,9,9,9,1,0,9,9,9,0,0,0,0,
              0,9,9,0,9,9,9,9,9,9,9,9,0,9,9,1,0,0,0,0,
              0,1,9,9,9,9,9,9,9,1,9,9,9,8,9,0,0,0,0,0,
              0,0,9,9,9,1,9,9,9,1,1,9,9,9,1,0,0,0,0,0,
              0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

#-------------------------------------------------SPRITES SAMUS-------------------------------------------------------------------

samus_parada:   .word 16, 32
		.byte 199,199,199,199,199,91,91,91,199,199,199,199,199,199,199,199,
		199,199,199,91,91,91,91,91,91,91,199,199,199,199,199,199,
		199,199,91,114,91,0,47,0,91,91,91,199,199,199,199,199,
		199,91,114,91,91,47,0,47,91,114,47,199,199,199,199,199,
		199,91,91,91,91,91,91,91,91,114,114,47,199,199,199,199,
		199,91,91,91,91,91,91,91,91,114,114,114,199,199,199,199,
		199,199,91,24,24,24,24,91,91,91,114,114,199,199,199,199,
		199,199,24,24,24,24,47,24,91,91,91,91,199,199,199,199,
		199,24,24,24,24,47,24,47,24,91,24,47,47,91,47,199,
		199,24,24,24,47,24,24,24,24,24,24,47,47,47,47,47,
		199,24,24,24,24,24,24,24,91,91,47,47,114,114,114,47,
		199,24,24,24,24,47,24,91,91,91,47,47,47,91,47,199,
		199,199,24,24,24,47,24,91,91,91,199,199,199,199,199,199,
		199,199,24,24,24,24,24,91,24,91,91,91,199,199,199,199,
		199,199,199,24,24,24,24,199,24,24,91,91,91,199,199,199,
		199,199,199,24,24,24,24,199,199,91,91,91,91,199,199,199,
		199,199,24,24,24,24,24,199,199,199,199,199,199,199,199,199,
		199,199,24,24,24,24,24,24,199,199,199,199,199,199,199,199,
		199,199,24,24,24,24,24,24,24,199,199,199,199,199,199,199,
		199,199,199,24,24,24,24,24,24,24,199,199,199,199,199,199,
		199,199,199,24,24,24,199,24,24,24,199,199,199,199,199,199,
		199,199,199,24,24,24,199,199,24,47,47,199,199,199,199,199,
		199,199,199,24,24,24,199,199,24,24,47,199,199,199,199,199,
		199,199,199,24,24,47,47,24,24,24,199,199,199,199,199,199,
		199,199,24,24,47,47,47,24,24,199,199,199,199,199,199,199,
		199,24,24,24,24,47,24,24,24,199,199,199,199,199,199,199,
		24,24,24,24,199,199,24,24,91,199,199,199,199,199,199,199,
		24,91,91,199,199,91,24,91,91,199,199,199,199,199,199,199,
		91,91,199,199,199,91,91,91,114,91,199,199,199,199,199,199,
		114,114,199,199,199,91,91,114,91,91,91,199,199,199,199,199,
		91,91,91,199,199,199,91,114,91,91,91,91,199,199,199,199,
		91,91,91,91,199,199,199,199,199,199,199,199,199,199,199,199

samus_andando_1:.word 16, 32
		.byte 199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,
		199,199,199,199,199,199,199,199,199,91,91,91,199,199,199,199,
		199,199,199,199,199,199,199,91,91,91,91,91,91,91,199,199,
		199,199,199,199,199,199,91,47,91,0,47,0,91,91,91,199,
		199,199,199,199,199,91,47,91,91,47,0,47,91,114,47,199,
		199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,47,
		199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,114,
		199,199,199,199,199,199,91,24,91,91,91,91,91,91,114,114,
		199,199,199,199,199,199,47,24,24,24,24,91,91,91,91,91,
		199,199,199,199,199,199,24,24,24,24,24,24,91,91,91,199,
		199,199,199,199,199,24,24,47,24,24,24,24,24,199,199,199,
		199,199,199,199,24,24,24,24,47,24,24,24,199,199,199,199,
		199,199,199,199,24,24,24,24,24,47,24,24,199,199,199,199,
		199,199,199,199,47,47,24,24,47,24,47,47,47,47,199,199,
		199,199,199,199,47,24,24,24,24,47,47,47,47,47,47,199,
		199,199,199,199,199,24,24,24,24,47,47,114,114,114,47,199,
		199,199,199,199,199,199,24,24,24,24,47,47,47,47,199,199,
		199,199,199,199,199,199,24,24,24,24,199,199,199,199,199,199,
		199,199,199,199,199,24,24,24,24,24,199,199,199,199,199,199,
		199,199,199,199,199,24,24,24,24,199,199,199,199,199,199,199,
		199,199,199,199,199,24,24,24,24,199,199,199,199,199,199,199,
		199,199,199,199,199,199,24,24,24,91,199,199,199,199,199,199,
		199,199,199,199,199,199,24,24,24,91,199,199,199,199,199,199,
		199,199,199,199,199,91,24,24,24,199,199,199,199,199,199,199,
		199,199,199,199,91,91,91,24,91,91,199,199,199,199,199,199,
		199,199,199,91,91,91,24,24,24,199,199,199,199,199,199,199,
		199,199,91,91,114,24,24,24,24,199,199,199,199,199,199,199,
		199,199,91,91,24,24,24,24,199,199,199,199,199,199,199,199,
		199,199,199,24,24,24,91,199,199,199,199,199,199,199,199,199,
		199,199,91,24,24,91,91,91,199,199,199,199,199,199,199,199,
		199,199,91,91,91,91,114,91,91,199,199,199,199,199,199,199,
		199,199,199,91,91,114,91,91,91,91,199,199,199,199,199,199
		
samus_andando_2:.word 16, 32
		.byte 199,199,199,199,199,199,199,199,199,91,91,91,199,199,199,199,
		199,199,199,199,199,199,199,91,91,91,91,91,91,91,199,199,
		199,199,199,199,199,199,91,47,91,0,47,0,91,91,91,199,
		199,199,199,199,199,91,47,91,91,47,0,47,91,114,47,199,
		199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,47,
		199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,114,
		199,199,199,199,199,199,24,24,24,91,91,91,91,91,114,114,
		199,199,199,199,199,47,24,47,24,24,91,91,91,91,91,91,
		199,199,199,199,199,24,24,24,24,24,24,91,91,91,91,199,
		199,199,199,199,24,24,47,24,24,24,24,24,91,91,199,199,
		199,199,199,199,24,24,47,24,24,24,24,24,199,199,199,199,
		199,199,199,199,199,24,24,24,24,24,24,24,24,199,199,199,
		199,199,199,199,199,199,24,24,24,24,24,24,24,24,199,199,
		199,199,199,199,199,199,199,24,24,24,24,199,24,24,24,199,
		199,199,199,199,199,199,199,24,24,24,24,199,47,24,24,199,
		199,199,199,199,199,199,199,24,24,24,24,199,47,114,47,47,
		199,199,199,199,199,199,24,24,24,24,24,24,199,47,114,47,
		199,199,199,199,199,199,24,24,24,24,24,24,24,199,199,199,
		199,199,199,199,199,199,24,24,24,24,24,24,24,24,47,47,
		199,199,199,199,199,199,199,24,24,24,199,24,24,24,24,47,
		199,199,199,199,199,199,199,24,24,24,199,199,199,24,24,47,
		199,199,199,199,199,199,24,24,24,199,199,199,199,24,24,24,
		199,199,199,199,199,24,24,24,24,199,199,199,24,24,24,24,
		199,199,199,199,24,24,47,24,199,199,199,91,91,24,24,199,
		199,199,199,24,24,24,47,47,199,199,91,91,24,24,24,199,
		91,24,24,24,24,24,47,199,199,199,91,91,114,114,199,199,
		91,114,24,24,24,199,199,199,199,199,91,91,91,91,114,199,
		91,91,114,24,199,199,199,199,199,199,199,91,91,91,91,199,
		91,91,91,199,199,199,199,199,199,199,199,199,91,91,91,91,
		91,91,91,199,199,199,199,199,199,199,199,199,199,91,91,91,
		91,91,91,91,199,199,199,199,199,199,199,199,199,199,199,199,
		199,91,91,91,91,199,199,199,199,199,199,199,199,199,199,199
		
samus_andando_3:.word 16, 32
		.byte 199,199,199,199,199,199,199,199,199,91,91,91,199,199,199,199,
		199,199,199,199,199,199,199,91,91,91,91,91,91,91,199,199,
		199,199,199,199,199,199,91,47,91,0,47,0,91,91,91,199,
		199,199,199,199,199,91,47,91,91,47,0,47,91,114,47,199,
		199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,47,
		199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,114,
		199,199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,
		199,199,24,47,24,24,24,24,24,24,24,91,91,91,91,91,
		199,24,24,24,47,47,24,24,24,24,24,24,91,91,91,199,
		199,24,24,24,24,24,47,47,47,47,47,24,91,24,199,199,
		199,24,24,24,24,24,24,47,47,47,47,47,24,24,24,199,
		199,199,199,24,24,24,24,47,114,114,114,47,24,24,24,199,
		199,199,199,199,199,24,47,47,47,47,47,24,24,24,199,199,
		199,199,199,199,199,199,24,24,24,24,47,199,199,199,199,199,
		199,199,199,199,199,199,24,24,24,24,199,199,199,199,199,199,
		199,199,199,199,199,24,24,24,24,24,199,199,199,199,199,199,
		91,91,199,199,199,24,24,24,24,24,199,199,199,199,199,199,
		91,91,199,199,199,24,24,24,24,24,24,199,199,199,199,199,
		91,114,91,199,199,199,24,24,24,24,24,24,199,199,199,199,
		91,114,24,24,199,24,24,24,199,24,24,24,199,199,199,199,
		114,91,24,24,47,24,24,199,199,199,24,24,24,199,199,199,
		199,91,24,24,47,24,24,199,199,199,24,24,24,199,199,199,
		199,199,199,24,24,47,199,199,199,199,199,47,47,47,199,199,
		199,199,199,199,47,47,199,199,199,199,199,24,24,47,199,199,
		199,199,199,199,199,199,199,199,199,199,24,24,24,24,199,199,
		199,199,199,199,199,199,199,199,199,24,24,24,24,199,199,199,
		199,199,199,199,199,199,199,199,24,24,24,24,199,199,199,199,
		199,199,199,199,199,199,199,199,91,24,24,91,199,199,199,199,
		199,199,199,199,199,199,199,91,91,91,91,91,199,199,199,199,
		199,199,199,199,199,199,199,91,91,91,114,114,91,199,199,199,
		199,199,199,199,199,199,199,199,91,114,91,91,91,91,199,199,
		199,199,199,199,199,199,199,199,199,199,91,91,91,91,91,199
		
samus_pulando:  .word 16, 32
	        .byte 199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,
		199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,
		199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,
		199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,
		199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,
		199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,199,
		199,199,199,199,199,199,199,199,199,91,91,91,199,199,199,199,
		199,199,199,199,199,199,199,91,91,91,91,91,91,91,199,199,
		199,199,199,199,199,199,91,47,91,0,47,0,91,91,91,199,
		199,199,199,199,199,91,47,91,91,47,0,47,91,114,47,199,
		199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,47,
		199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,114,
		199,199,199,199,199,199,91,91,91,91,91,91,91,91,114,114,
		199,199,199,199,199,199,199,24,24,24,24,91,91,91,91,91,
		199,199,199,199,199,199,24,47,24,24,24,24,91,91,91,199,
		199,199,199,199,199,24,24,24,47,24,24,24,199,199,199,199,
		199,199,199,199,24,24,24,24,47,24,24,199,199,199,199,199,
		199,199,199,199,47,47,24,24,24,24,24,199,199,199,199,199,
		199,199,199,199,47,24,24,24,24,47,47,47,47,199,199,199,
		199,199,199,199,199,24,24,24,47,47,47,47,47,47,199,199,
		199,199,199,199,199,199,24,24,47,47,114,114,114,47,199,199,
		199,199,199,199,199,24,24,24,24,47,47,47,47,199,199,199,
		91,91,199,199,199,24,24,24,24,24,24,24,24,24,199,199,
		91,91,199,199,199,24,24,24,24,24,24,24,24,47,47,199,
		114,91,91,199,199,199,24,24,24,24,24,199,24,24,47,199,
		114,91,24,24,199,24,24,24,199,199,199,24,24,24,199,199,
		199,91,24,24,47,24,24,24,199,91,24,24,91,199,199,199,
		199,91,24,24,47,24,24,199,91,91,91,91,199,199,199,199,
		199,199,199,24,24,47,24,199,91,91,114,114,199,199,199,199,
		199,199,199,199,47,47,199,199,91,114,91,91,91,199,199,199,
		199,199,199,199,199,199,199,199,199,199,91,91,91,91,199,199,
		199,199,199,199,199,199,199,199,199,199,199,91,91,91,91,199


#---------------------------------------------------------------------------------------------------------------------------------
.include "sprites\data\samus\old_char_pos.s"

#.include "sprites\data\tiles\tijolos.s"
#.include "sprites\data\tiles\metal.s"
#.include "sprites\data\mapas\mapa_1.s"

.include "sprites\data\voador\voador_1.s"
.include "sprites\data\voador\voador_2.s"

.include "sprites\data\escorpiao\escorpiao_andando_1.s"

#.include "sprites\data\samus\samus_parada.s"
.include "sprites\data\pinwheel\pinwheel_parado.s"
