.text
# s0 = CONTADOR DE FRAME PARA GAME_LOOP

# s1 = GUARDA O ÍNDICE DA LINHA NA HORA DE PRINTAR O MAPA / ARMAZENA SE O PERSONAGEM IRÁ COLIDIR OU NÃO (1 PARA SIM E 0 PARA NÃO)
# S2 = GUARDA O ÍNDICE DA COLUNA NA HORA DE PRINTAR O MAPA

# S3 = PONTEIRO DA CABEÇA DAS LISTAS ENTIDADES_INFO, OLD ENTIDADES_INFO E NEXT_ENTIDADES_INFO
# S4 = PONTEIRO QUE INDICA O ENDEREÇO PARA ADICIONAR O PRÓXIMO ITEM NA LISTAS

# S5 = ARMAZENA QUANTAS VEZES O PERSONAGEM PODE IR PARA CIMA NO PULO 
# S6 = INÉRCIA, ARMAZENA SE O PERSONAGEM PULOU PARA A DIREITA OU PARA A ESQUERDA (0 = ESQUERDA, 1, RETO, 2 DIREITA)

# S7 = ITENS DA SAMUS, SE S7 = 0, SAMUS NÃO TEM NENHUM ITEM, S7 = 1, SAMUS GANHA A HABILIDADE DE VIRAR A BOLA, S7 = 2, SAMUS GANHA O TIRO FOGUETE
# S8 = 
# S9 =  

# S10 = SALVA SE O PERSONAGEM GANHOU O JOGO / PASSOU DE Nï¿½VEL
# S11 = SALVA O MAPA ATUAL

MAIN: la s3, ENTIDADES_INFO       # ENDEREï¿½O DA LISTA CONTENDO AS ENTIDADES
      addi s4, s3, 24             # ENDEREï¿½O DA LISTA ONDE DEVE SER SALVO O PRï¿½XIMO ITEM
      
      la s11, mapa_1
      li s5, 0 
      li s7, 0
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
	   li s1, 0                    # í½ndice da linha
	   li s2, 0                    # índice da coluna
	   
	   addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call PRINT_MAP
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
	   
	   li s1, 0                    # frame de colisão
	   
	   li s0, 0                    # Frame de início
    	   li s10, 1                   # Pointer de vitória
    	   
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
           
           beq s5, zero, SEGUE_LOOP
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
    	   mv a3, s3
    	   addi a4, a3, 8
    	   addi a5, a4, 8
           call CHAR_SOBE
           lw ra, 0(sp)                # Restaura ra da pilhad
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           j PULA_GRAV

SEGUE_LOOP:addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
    	   mv a3, s3
    	   addi a4, a3, 8
    	   addi a5, a4, 8
           jal ra, CHAR_BAIXO
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
PULA_GRAV: addi sp, sp, -4            # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)               # Salva ra na pilha
           call IA_INIMIGO
           lw ra, 0(sp)               # Restaura ra da pilhad
           addi sp, sp, 4             # Ajusta a pilha de volta
          
	   xori s0, s0, 1
	   
	   la a0, samus_parada
	   
	   lh t1, 12(s3)               # frame atual da Samus
	   li t2, 520
	   mul t1, t1, t2
	   
	   add a0, a0, t1	   
	   
 	   lh a1, 0(s3)                # Imprime a posição X do personagem
 	   lh a2, 2(s3)                # Imprime a posição Y do personagem
 	   mv a7, s0
 	   
#	   lh t0, 20(t0)
# 	   beq t0, zero, PRINT_DIR    # SE A SAMUS ESTIVER INDO PARA A DIREITA, PRINTE O SPRITE NORMAL, CASO A SAMUS ESTEJA INDO PARA A ESQUERDA, PRINTA ESPELHADO
 	   
#PRINT_ESQ: addi sp, sp, -4             # Ajusta a pilha para salvar ra
#    	   sw ra, 0(sp)                # Salva ra na pilha
#           call PRINT_ESPELHAR
#           lw ra, 0(sp)                # Restaura ra da pilha
#           addi sp, sp, 4              # Ajusta a pilha de volta
           
#           j VOLTA_LOOP 
 	   
PRINT_DIR: addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call PRINT
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
#DELAY:     li t0, 1000                 # Define o valor do contador (ajuste para o atraso desejado)
  
#DELAY_LOOP:addi t0, t0, -1             # Decrementa o contador
#           beq t0, zero, VOLTA_LOOP    # Se o contador não chegou a 0, continua o loop
#           j DELAY_LOOP                # Retorna quando o contador atingir 0
 	   
VOLTA_LOOP:li t0, 0xFF200604
 	   sw s0, 0(t0)
 	   
 	   beq s10, zero, FIM_LOOP
 	   j GAME_LOOP
 	   
FIM_LOOP:  ret                         # QUANDO O PERSONAGEM PASSA DE FASE, O LOOP ACABA E ELE VOLTA PARA SETUP, ONDE O SEGUNDO MAPA SERï¿½ CARREGADO E O LOOP RETORNA

#------------------------------------------------AÇÕES QUE O JOGADOR PODE FAZER COM O TECLADO PARA A SAMUS REALIZAR-----------------------------------------------------------------------

KEY: la a3, ENTIDADES_INFO             # SALVA EM A3 A POSIï¿½ï¿½O X, Y DA SAMUS E OS ATRIBUTOS DE ENTIDADES_INFO (VIDA E TIPO)
     addi a4, a3, 8                    # SALVA EM A4 A POSIï¿½ï¿½O ANTIGA DA SAMUS E OS ATRIBUTOS DE OLD_ENTIDADES_INFO (FRAME ATUAL E FRAME ANTIGO)
     addi a5, a4, 8                    # SALVA EM A5 A PRï¿½XIMA POSIï¿½ï¿½O X DA SAMUS E OS ATRIBUTOS DE NEXT_ENTIDADES_INFO (CIMA/BAIXO E ESQUERDA/DIRETIA)

     li t1, 0xFF200000                 # carrega o endereï¿½o do controle do KDMMIO
     lw t0, 0(t1)                      # Le bit de Controle Teclado
     andi t0, t0, 0x0001               # mascara o bit menos significativo
     beq t0, zero, FIM                 # Se nï¿½o hï¿½ tecla pressionada entï¿½o vai para FIM
     lw t2, 4(t1)                      # le o valor da tecla tecla
     
     lh t0, 6(a3)                      # DEPENDENDO DO ESTADO EM QUE A SAMUS SE ENCONTRA, SUAS AÇÕES POSSÍVEIS SÃO DIFERENTES
     
     beq t0, zero, SAMUS_NORMAL        # SAMUS EM PÉ
     
     li t1, 2
     beq t0, t1, SAMUS_AGACHADA
     
     li t1, 3
     beq t0, t1, SAMUS_BOLA         
     
 #-------------------------------------------
SAMUS_NORMAL:
     
     li t6, 'f'
     beq t2, t6, ATIRAR
     
     #------------------------------------------
     
     li t6, 's'
     beq t2, t6, CHAR_AGACHA
     
     #------------------------------------------
     
     li t6, 'a'
     beq t2, t6, CHAR_ESQ
     
     #-------------------------------------------
     
     li t6, 'd'
     beq t2, t6, CHAR_DIR
     
     #-------------------------------------------
     
     li t6, 'w'
     bne s5, zero, FIM                 # O PERSONAGEM NÃO PODE SE MOVER ENQUANTO ESTIVER PULANDO
     
     lh t0, 6(a4)
     beq t0, zero, FIM                 # O PERSONAGEM NÃO PODE PULAR SE ESTIVER CAINDO
     
     beq t2, t6, CHAR_PULA
     
     J FIM
     
#-------------------------------------------
SAMUS_AGACHADA:

     li t6, 'f'
     beq t2, t6, ATIRAR
     
     #------------------------------------------
     
     li t6, 's'
     beq t2, t6, CHAR_LEVANTA
     
     j FIM
     
#------------------------------------------
SAMUS_BOLA:
     
     li t6, 'a'
     beq t2, t6, CHAR_ESQ
     
     #-------------------------------------------
     
     li t6, 'd'
     beq t2, t6, CHAR_DIR
     
     #-------------------------------------------
     
     li t6, 'w'
     bne s5, zero, FIM                 # O PERSONAGEM NÃO PODE SE MOVER ENQUANTO ESTIVER PULANDO
     
     lh t0, 6(a4)
     beq t0, zero, FIM                 # O PERSONAGEM NÃO PODE PULAR SE ESTIVER CAINDO
     
     beq t2, t6, CHAR_PULA
     
#-------------------------------------------
FIM: 
     lh t0, 4(a5)                      # ESQ/PARADO_ESQ/PARADO_DIR/DIR
     
     li t1, 0                          # ANDANDO PARA A ESQUERDA
     beq t1, t0, PARA_OLHANDO_ESQ
     
     li t1, 2                          # ANDANDO PARA A DIREITA
     beq t1, t0, PARA_OLHANDO_DIR
     ret
     
PARA_OLHANDO_ESQ:     
     #sh zero, 4(a4)                   # CARREGA O FRAME ATUAL E O FRAME ANTIGO COMO ZERO
     li t0, 1
     sh t0, 4(a5)
     ret

PARA_OLHANDO_DIR:
     #sh zero, 4(a4)                   # CARREGA O FRAME ATUAL E O FRAME ANTIGO COMO ZERO
     li t0, 3
     sh t0, 4(a5)
     ret

#---------------------------------------------------------CRIAR UM PROOJÉTIL E ATIRAR------------------------------------------------------------------

ATIRAR:    lh a1, 0(a3)
           lh a2, 2(a3)
           
           lh t0, 4(a3)                # PEGA O TIPO DA ENTIDADE QUE ATIROU (PRECISA SER A ENTIDADE E NÃO O ÍNDICE POIS A SAMUS MUDA DE TIPO)
           lh t1, 4(a5)                # ESQ/PARADO_ESQ/PARADO_DIR/DIR
          
           beq t0, zero, TIRO_SAMUS
           
           #-------------------------------------------
           
TIRO_ENTIDADE:   
           li t2, 0        
           beq t2, t1, CRIA_ESQUERDA_PRO_ENT
           
           li t2, 1
           beq t2, t1, CRIA_ESQUERDA_PRO_ENT
           
           li t2, 2
           beq t2, t1, CRIA_DIREITA_PRO_ENT
           
           li t2, 3
           beq t2, t1, CRIA_DIREITA_PRO_ENT
           
CRIA_ESQUERDA_PRO_ENT:
           addi a1, a1, -4
           addi a2, a2, 6
           li a5, 0
           j CRIA_PROJETIL

CRIA_DIREITA_PRO_ENT:
           addi a1, a1, 16
           addi a2, a2, 6
           li a5, 2
           j CRIA_PROJETIL
       
       #-------------------------------------------
       
TIRO_SAMUS:li t2, 0
           beq t2, t1, CRIA_ESQUERDA_PRO_SAMUS
           
           li t2, 1
           beq t2, t1, CRIA_ESQUERDA_PRO_SAMUS
           
           li t2, 2
           beq t2, t1, CRIA_DIREITA_PRO_SAMUS
           
           li t2, 3
           beq t2, t1, CRIA_DIREITA_PRO_SAMUS
           

CRIA_ESQUERDA_PRO_SAMUS:
           addi a1, a1, -4
           addi a2, a2, 10
           li a5, 0
           j CRIA_PROJETIL

CRIA_DIREITA_PRO_SAMUS:
           addi a1, a1, 16
           addi a2, a2, 10
           li a5, 2
           j CRIA_PROJETIL

           #-------------------------------------------

CRIA_PROJETIL:           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
	   sw ra, 0(sp)                # Salva ra na pilha
	   li a3, 1                    # VIDA DA ENTIDADE
	   li a4, 3                    # TIPO DA ENTIDADE
	   call ADD_ITEM
	   lw ra, 0(sp)                # Restaura ra da pilha
	   addi sp, sp, 4              # Ajusta a pilha de volta
	   
	   ret

#---------------------------------------------------SAMUS AGACHAR E LEVANTAR----------------------------------------------------------------------------------

CHAR_AGACHA:
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call OLD_POS
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
	   
	   mv a3, s3
	   
	   lh a2, 2(a3)                # AUMENTA A POS Y DA SAMUS EM 16
           addi a2, a2, 16
           sh a2, 2(a5)
           sh a2, 2(a3)
           sh a2, 2(a4)
	   
           li t0, 2
           sh t0, 6(a3)                # MUDA O TIPO DA SAMUS PARA O TIPO DE UN INIMIGO 16 X 16 PIXELS
           
           li t0, 6
           sh t0, 4(a4)                # MUDA O FRAME ATUAL DA SAMUS PARA O FRAME AGACHAR
           ret
           
CHAR_LEVANTA:
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call OLD_POS
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           mv a3, s3
           
           lh a2, 2(a3)                # AUMENTA A POS Y DA SAMUS EM 16
           addi a2, a2, -16
           sh a2, 2(a5)
           sh a2, 2(a3)
           sh a2, 2(a4)

           sh zero, 6(a3)              # MUDA O TIPO DE ENTIDADE DA SAMUS
           sh zero, 4(a4)              # MUDA O FRAME ATUAL DA SAMUS PARA PARADA
           ret
           
#------------------------------------------------CHAR DEFINE A ALTURA DO PULO E A INÉRCIA--------------------------------------------------------------------------------------------

CHAR_PULA:       li s5, 24             # 36 PIXELS PARA CIMA E 16 PARA OS LADOS, CASO HAJA INÉRCIA, OU APENAS 48 PIXELS PARA CIMA
  
                 lh t0, 4(a5)          # ESQ/PARADO/DIR
                 
                 li t1, 0
                 beq t1, t0, INERCIA_ESQ
                 
                 li t1, 1
                 beq t1, t0, SEM_INERCIA
                 
                 li t1, 3
                 beq t1, t0, SEM_INERCIA
                 
                 li t1, 2
                 beq t1, t0, INERCIA_DIR
                 

INERCIA_ESQ:     li s6, 0              
                 ret

SEM_INERCIA:     li s6, 1            
                 ret

INERCIA_DIR:     li s6, 2
                 ret
                 
#------------------------------------------------MOVIMENTAÇÃO EM 4 EIXOS DA SAMUS-------------------------------------------------------------------------------------
CHAR_ESQ:  sh zero, 4(a5)              # muda o valor ESQUERDA/DIREITA do personagem para 0, pois ele esta´andando para a ESQUERDA

           lh a1, 0(a5) 
           addi a1, a1, -4             # altera NEXT_CHAR_POS 4 PIXELS PARA A ESQUERDA
           sh a1, 0(a5)
           lh a2, 2(a5)                # Carrega a NEXT coordenada Y
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO_HOR
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           lh t0, 6(a5)                # CHAMA O ÍNDICE DA ENTIDADE QUE SERïÁ CALCULADA A COLISÃO, POIS A SAMUS TEM COLISÃO ESPECIAL
           li t1, 1
           beq t0, t1, COL_SAMUS_HOR
           
           j COL_ENTIDADE_HOR
           
           #-------------------------------------------------------------------------------------------------------------------------------------
	  
CHAR_DIR:  li t0, 2
           sh t0, 4(a5)                # muda o valor ESQUERDA/DIREITA do personagem para 2, pois ele está andando para a DIREITA
           
           lh a1, 0(a5) 
           addi a1, a1, 4              # altera NEXT_CHAR_POS 4 PIXELS PARA A DIRETIA
           sh a1, 0(a5)
           lh a2, 2(a5)                # Carrega a NEXT coordenada Y
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO_HOR
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
              
           lh t0, 6(a5)                # CHAMA O ÍNDICE DA ENTIDADE QUE SERïÁ CALCULADA A COLISÃO, POIS A SAMUS TEM COLISÃO ESPECIAL
           li t1, 1
           beq t0, t1, COL_SAMUS_HOR
           
           j COL_ENTIDADE_HOR
           
           #-------------------------------------------------------------------------------------------------------------------------------------
           
COL_SAMUS_HOR:
           bne s1, zero, BATEU_NUMA_PAREDE  
           mv s9, s1                   # SALVA O RESULTADO DA COLISï¿½O (X, Y) DA SAMUS (OU SEJA, A PARTE SUPERIOR DA SAMUS)

           addi a2, a2, 16             # ADICIONA 16 ï¿½ POSIï¿½ï¿½O Y DA SAMUS E CHAMA A COLISï¿½O DE NOVO, OU SEJA, CALCULA A COLISï¿½O DA PARTE DE BAIXO
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO_HOR
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           or s1, s1, s9
           
           bne s1, zero, BATEU_NUMA_PAREDE      # S1 ARMAZENA SE O PERSONAGEM IRÁ COLIDIR OU NÃO, 1 PARA COLIDIR E 0 PARA NÃO
           
           j SAMUS_RESUL_COL

COL_ENTIDADE_HOR:
           bne s1, zero, BATEU_NUMA_PAREDE      # S1 ARMAZENA SE O PERSONAGEM IRÁ COLIDIR OU NÃO, 1 PARA COLIDIR E 0 PARA NÃO
           j ENTIDADE_RESUL_COL       
           
           #----------------------------------------------------- 
           
BATEU_NUMA_PAREDE:

           lh t0, 4(a5)                # LOAD PARA SABER SE O PERSONAGEM ESTAVA INDO PARA A ESQUERDA OU PARA A DIREITA
           
           beq t0, zero, PAREDE_NA_ESQUERDA
           
           li t1, 2
           beq t0, t1, PAREDE_NA_DIREITA
           
PAREDE_NA_ESQUERDA:
           li t0, 1
           sh t0, 4(a5)
           j CHAR_RET

PAREDE_NA_DIREITA:
           li t0, 3
           sh t0, 4(a5)
           j CHAR_RET   
           
#-------------------------------------------------------------------------------------------------------------------------------------   
CHAR_BAIXO: sh zero, 6(a4)
           
            lh a1, 0(a5)
            lh a2, 2(a5)
            addi a2, a2, 4
            sh a2, 2(a5)
            
            addi sp, sp, -4            # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)               # Salva ra na pilha
            call CHECK_COLISAO_VER
            lw ra, 0(sp)               # Restaura ra da pilha
            addi sp, sp, 4             # Ajusta a pilha de volta
            
            bne s1, zero, ENTIDADE_COLIDE
            mv s9, s1
            
            addi a1, a1, 15
            
            addi sp, sp, -4            # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)               # Salva ra na pilha
            call CHECK_COLISAO_VER
            lw ra, 0(sp)               # Restaura ra da pilha
            addi sp, sp, 4             # Ajusta a pilha de volta
            
            addi a1, a1, -15
            
            or s1, s1, s9
            
            bne s1, zero, ENTIDADE_COLIDE
            
            
            j COL_VER_RESUL

ENTIDADE_COLIDE:
            lh t0, 4(a4)
            
            li t1, 0
            beq t0, t1, ENTIDADE_PARADA
            
            li t1, 5
            beq t0, t1, ENTIDADE_ATERRISA
            
ENTIDADE_PARADA:
            li t0, 1
            sh t0, 6(a4)

            j CHAR_RET
            
ENTIDADE_ATERRISA:
            sh zero, 4(a4)
            
            li t0, 1
            sh t0, 6(a4)
            
            addi sp, sp, -4            # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)               # Salva ra na pilha
            call OLD_POS
            lw ra, 0(sp)               # Restaura ra da pilha
            addi sp, sp, 4             # Ajusta a pilha de volta

            j CHAR_RET
            
COL_VER_RESUL:
            lh t0, 6(a5)               # CHAMA O ÍNDICE DA ENTIDADE
            li t1, 1
            beq t0, t1, SAMUS_RESUL_COL
            j ENTIDADE_RESUL_COL
            
        #------------------------------------------------------------------------------------------------------------------------------------- 
   
CHAR_CIMA:  li t1, 2
            sh t1, 6(a4)                # SALVA 2 NO VALOR DE DESCER/SUBIR
            
            lh a1, 0(a5)
            lh a2, 2(a5)
            addi a2, a2, -2
            sh a2, 2(a5)
            
            addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)                # Salva ra na pilha
            call CHECK_COLISAO_VER
            lw ra, 0(sp)                # Restaura ra da pilha
            addi sp, sp, 4              # Ajusta a pilha de volta
            
            bne s1, zero, BATEU_A_CABECA  
            mv s9, s1
            
            addi a1, a1, 15
            
            addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)                # Salva ra na pilha
            call CHECK_COLISAO_VER
            lw ra, 0(sp)                # Restaura ra da pilha
            addi sp, sp, 4              # Ajusta a pilha de volta
            
            addi a1, a1, -15
            
            or s1, s1, s9
            
            bne s1, zero, BATEU_A_CABECA
            j COL_VER_RESUL
            
BATEU_A_CABECA:  
            li s5, 0
            sh zero, 6(a4)
            j CHAR_RET
            
#---------------------------------------OPERAÇÕES QUE USAM CHAR_CIMA----------------------------------------------------------------------------

CHAR_SOBE:       li t1, 3
                 rem t0, s5, t1
                 
                 addi s5, s5, -1
	   
                 beq t0, zero, IMPULSO_CIMA
                 
                 li t1, 2
	         beq t0, t1, IMPULSO_CIMA
	   
	         li t1, 1
	         beq t0, t1, IMPULSO_INERCIA

IMPULSO_CIMA:    j CHAR_CIMA
           	 
          #----------------------------------------------------------------------------------
          
IMPULSO_INERCIA: beq s6, zero, IMPULSO_ESQ

                 li t0, 1
                 beq s6, t0, IMPULSO_CIMA
                 
                 li t0, 2
                 beq s6, t0, IMPULSO_DIR
                 
IMPULSO_ESQ:     j CHAR_ESQ

IMPULSO_DIR:     j CHAR_DIR
                 
#----------------------------------------------------------COLISÃO HORIZONTAL E VERTICAL--------------------------------------------------------------------------------------------------
CHECK_COLISAO_VER:
               li t6, 16
               li t5, 20
               la s11, mapa_1

               mv t1, a1                      # Carrega a NEXT coordenada X
               mv t2, a2                      # Carrega a NEXT coordenada Y
               
COLIDE_BAIXO:  lh t0, 6(a4)                   # PEGA O´VALOR QUE INDICA SE O PERSONAGEM ESTÁ INDO PARA BAIXO, PARADO, OU PARA CIMA
               
               beq t0, zero, DESCE            # VERIFICA SE A ENTIDADE ESTï¿½ ANDANDO PARA A CIMA, NESSE CASO, ï¿½ NECESSï¿½RIO SOMAR 15 NA POS X PARA CALCULAR A POSIï¿½ï¿½O
               j COLIDE_NORMAL
               
DESCE:         lh t0, 6(a3)
               
               beq t0, zero, SAMUS_DESCE
               j ENTIDADE_DESCE
               
SAMUS_DESCE:   addi t2, t2, 31
               j COLIDE_NORMAL
               
ENTIDADE_DESCE:addi t2, t2, 15
               j COLIDE_NORMAL

#-------------------------------------------------------------------------------------------------------
CHECK_COLISAO_HOR: 
               li t6, 16
               li t5, 20
               la s11, mapa_1

               mv t1, a1                      # Carrega a NEXT coordenada X
               mv t2, a2                      # Carrega a NEXT coordenada Y
               
COLIDE_DIR:    li t0, 2
               lh t3, 4(a5)
               
               beq t3, t0, ANDANDO_DIR   # VERIFICA SE A ENTIDADE ESTï¿½ ANDANDO PARA A DIREITA, NESSE CASO, ï¿½ NECESSï¿½RIO SOMAR 15 NA POS X PARA CALCULAR A POSIï¿½ï¿½O
               j COLIDE_NORMAL

ANDANDO_DIR:   addi t1, t1, 15

#-------------------------------------------------------------------------------------------------------
COLIDE_NORMAL: 
               li t6, 16
               li t5, 20
               la s11, mapa_1

               div t1, t1, t6
               div t2, t2, t6
               
               mul t2, t2, t5            # APï¿½S A DIVISï¿½O, T2 POSSUI A LINHA Y DA MATRIZ MAPA ONDE A PARTE DE BAIXO DA SAMUS (OU UMA ENTIDADE DE TAMANHO 16) ESTï¿½
                                      
               add t2, t1, t2            # APï¿½S MULTIPLICAR POR 20 E SOMAR COM A COMPONENTE X, TEMOS EXATAMENTE O BYTE PARA ONDE SAMUS ANDARï¿½
               
               add s11, s11, t2          # SOMAMOS S11 A T2 PARA SABER QUAL BYTE DO MAPA ï¿½, SE ELE FOR DO TIPO QUE COLIDE (TIJOLO OU METAL) RETORNA 0
               
               lb t3, 0(s11)
               
               li t4, 0
               beq t3, t4, COLIDE
               
               li t4, 1
               beq t3, t4, COLIDE
               
               li t4, 2
               beq t3, t4, NOVO_ITEM
               
               li s1, 0
               ret
               
COLIDE:        li s1, 1
               ret
               
NOVO_ITEM:     addi s7, s7, 1
               li s1, 0
               ret

#-------------------------------------------RESULTADO DA COLISÃO--------------------------------------------------------------------------------------------------------

SAMUS_RESUL_COL:
           bne s5, zero, FRAME_5         # SE O PERSONAGEM ESTIVER SUBINDO, SEU FRAME ATUAL SERÁ 5 (CAINDO/SUBINDO)
	   
	   lh t0, 6(a4)
	   beq t0, zero, FRAME_5         # SE O PERSONAGEM ESTIVER CAINDO, SEU SPRITE NÃO PODE MUDAR
	   
	   lh t0, 4(a4)                  # CARREGA O FRAME ATUAL
           
           li t1, 4
	   beq t0, t1, VOLTA_FRAME_1
	   
	   addi t0, t0, 1
	   sh t0, 4(a4)
	   j ATUALIZA_POS


FRAME_5:   li t0, 5                      # SETA O FRAME 4 COMO FRAME ATUAL (samus_pulando, no caso da Samus)
     	   sh t0, 4(a4)
     	   j ATUALIZA_POS
 
          #---------------------------------------------------------------------------------------------------------------------------------------------------

ENTIDADE_RESUL_COL:
           lh t0, 6(a3) 
	   li t1, 3
	   beq t0, t1, ATUALIZA_POS      # SE A ENTIDADE QUE SE MOVEU FOPR UM PROJÉTIL, ELE PULA TODO O PROCESSOD DE ATUALIZAR O FRAME DE ANIMAÇÃO
	   
	   li t1, 1
	   beq t0, t1, RESUL_SCORPIO
	   
	   li t1, 2
	   beq t0, t1, RESUL_MARIPOSA
	   #---------------------------------------------------------------------------------------------------------------------------------------------------
	   
RESUL_MARIPOSA: ret
	   
	   #---------------------------------------------------------------------------------------------------------------------------------------------------
	   
RESUL_SCORPIO:
           lh t0, 6(a4)
           
           li t1, 0
           beq t1, t0, FRAME_5	   
	   
	   lh t0, 4(a4)                  # CARREGA O FRAME ATUAL
	  
	   li t1, 4
	   beq t0, t1, VOLTA_FRAME_1
	   
	   addi t0, t0, 1
	   sh t0, 4(a4)
	   j ATUALIZA_POS

VOLTA_FRAME_1:
           li t0, 1
           sh t0, 4(a4)
           
           #---------------------------------------------------------------------------------------------------------------------------------------------------
           
ATUALIZA_POS:           
           lw t3, 0(a3)                  # COMO O PERSONAGEM NÃO IRÁ COLIDIR, PODEMOS ATUALIZAR CHAR_POS E OLD_CHAR_POS 
           sw t3, 0(a4)                  # AGORA OLD_CHAR_POS PASSA A SER CHAR_POS
           
           lw t3, 0(a5)                  # COMO O PERSONAGEM NÃO IRÁ COLIDIR, PODEMOS ATUALIZAR CHAR_POS E NEXT_CHAR_POS 
           sw t3, 0(a3)                  # AGORA CHAR_POS PASSA A SER NEXT_CHAR_POS

           #----------------------------------APAGA A POSIÇÃO ANTIGA DA ENTIDADE--------------------------------------------
	   
OLD_POS:    lh t0, 6(a3)                  # PEGA O TIPO DA ENTIDADE
               
            beq t0, zero, T32_PIXELS      # SE FOR A SAMUS, APAGA COM O OLD_POS DE 16 X 32
               
            li t1, 1
            beq t0, t1, T16_PIXELS        # SE FOR UM INIMIGO, APAGA COM O OLD_POS DE 16 X 16
               
            li t1, 2
            beq t0, t1, T16_PIXELS
               
            li t1, 3
            beq t0, t1, T4_PIXELS         # SE FOR UM PROJETIL, APAGA COM O OLD_POS DE 4 X 4
       
T32_PIXELS: la a0, old_char_pos          # Apaga a posição antiga da SAMUS no frame que vai ser escondido (32 x 16)
            j APAGA

T16_PIXELS: la a0, half_old_char_pos     # Apaga a posição antiga de INIMIGOS no frame que vai ser escondido (16 x 16)
            j APAGA
            
T4_PIXELS:  la a0, projetil_old_pos      # Apaga a posição antiga de PROJÉTEIS no frame que vai ser escondido (4 x 4)

APAGA: 	    lh a1, 0(a4)
 	    lh a2, 2(a4)
 	    li a7, 0

            addi sp, sp, -4              # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)                 # Salva ra na pilha
            call PRINT
            lw ra, 0(sp)                 # Restaura ra da pilha
            addi sp, sp, 4               # Ajusta a pilha de volta
           
            li a7, 1
            
            addi sp, sp, -4              # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)                 # Salva ra na pilha
            call PRINT
            lw ra, 0(sp)                 # Restaura ra da pilha
            addi sp, sp, 4               # Ajusta a pilha de volta
           
            ret
               
CHAR_RET:   lw t3, 0(a3)                 # CORRIGE NEXT_CHAR_POS PARA O CASO EM QUE O PERSONAGEM COLIDE
	    sw t3, 0(a5)
	    ret

#---------------------------------------------------------------IAs DOS INIMIGOS-------------------------------------------------------------------

IA_INIMIGO:    mv a6, s3

	       lh t1, 0(s3)              # X e Y Samus
	       lh t2, 2(s3)
              
               addi sp, sp, -4           # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)              # Salva ra na pilha
               call INIMIGO_LOOP
               lw ra, 0(sp)              # Restaura ra da pilha
               addi sp, sp, 4            # Ajusta a pilha de volta
             
               ret
          
INIMIGO_LOOP:  beq a6, s4, FINAL_LOOP    # QUANDO CHEGA NO FIM DA LISTA, ENCERRA O LOOP
               addi a6, a6, 24
               
               mv a3, a6                 # Salva ENTIDADE_INFO EM A3
              
               lh t3, 4(a3)              # VIDA DA ENTIDADE
	       beq t3, zero, INIMIGO_FIM # se o inimigo estiver morto, nada acontece
	     
	       lh t3, 6(a3)              # carrega o tipo da entidade
	       
	       li t4, 1
	       beq t3, t4, SCORPIO_TURN
	      
	       li t4, 2
	       beq t3, t4, VOADOR_TURN
	       
	       li t4, 3
	       beq t3, t4, PROJETIL_TURN
	       
	       #li t4, 4
	       #beq t3, t4, PROJETIL_SAMUS_TURN
	       
	       #lh t4, 6(t0)
	       #li t5, 4
	       #beq t4, t5, PINWHEEL_TURN
	       
#--------------------------------------------------------------------------------------------------------------------------------------
# Descreve o comportamento do tipo de inimigo ESCORPIÃO
SCORPIO_TURN:  lh a1, 0(a3)              # salva a posição X do Inimigo
	       lh a2, 2(a3)              # salva a posição Y do Inimigo
	       
	       sub t3, a2, t2
	       addi t3, t3, 16           # A POSIÇÃO Y DA SAMUS É A DA CABEÇA A DELA, QUE TEM 32 PIXELS, PARA COMPARAR COM O Y DO ESCORPIÃO PRECISAMOS SOMAR 16
	       
	       sub t4, a1, t1
	       
	       and t5, t4, t3
	       beq t5, zero, SAMUS_DANO
	     
	       # Fazer um AND entre "está na mesma cordenada Y" e "Estar dentro do INTERVALO DE ATAQUE do inimigo"
	      
	       #----------------------------------------COMPARA A POSIÇÃO Y DA SAMUS E DO ESCORPIÃO----------------------------------------------------------
	       
	       bne t3, zero, SCORPIO_ANDA     # CASO A SAMUS E O ESCORPIÃO NÃO ESTEJAM NO MESMO ANDAR, O ESCORPIÃO APENAS ANDA
	       
	       xori t3, t3, 1
	       mv s9, t3                      # estou precisando de mais um registrador para salvar t3
	     
	       #-----------------------------------------COMPARA A POSIÇÃOO X DA SAMUS E DO ESCORPIÃO--------------------------------------------------------
               
      	       addi t3, a1, -32               # verifica se o personagem está 3 tiles na frente do inimigo
	       addi t4, a1, 32                # verifica se o personagem está 2 tiles atrás do inimigo
	     
	       slt t5, t1, t4                 # T1 TEM que ser menor que T4 para que o inimigo ataque (SAMUS ESTï¿½ DENTRO DO CAMPO DE VISï¿½O DA DIREITA DO INIMIGO)
	       slt t6, t3, t1                 # T3 TEM que ser maior que T3 para que o inimigo ataque (SAMUS ESTï¿½ DENTRO DO CAMPO DE VISï¿½O DA ESQUERDA DO INIMIGO)
	     
	       #----------------------------TABELA VERDADE DO ESCORPIï¿½O ATACAR------------------------------
	       #
	       #        T5      T6          T2 (ATACAR)  |      T1    T2      ATACAR
	       #        0       0           0            |      0     0         0
	       #        0       1           0            |      0     1         0
	       #        1       0           0            |      1     0         0
	       #        1       1           1            |      1     1         1
	     
	       and t4, t6, t5                 # VERIFICA SE O SAMUS ESTÁ NO RANGE DE ATAQUE DO INIMIGO
	     
	       #------------------------------------------------------------------------------------------------------------
	       mv t3, s9
	       and t5, t4, t3                 # VERIFICA SE A SAMUS ESTÁ NO RANGE DE ATAQUE DO INIMIGO E NA MESMA ALTURA. 
	       
	       li t4, 1                     
	       beq t5, t4, SCORPIO_ATACK      # VERIFICA SE O ESCORPIÃO IRÁ ATACAR A SAMUS OU NÃO
	       j SCORPIO_ANDA
	     
SCORPIO_ATACK: slt t6, t1, a1

               bne t6, zero, MIRAR_ESQ
               j MIRAR_DIR
               
MIRAR_ESQ:     li t6, 1                       # VIRA A ENTIDADE PARA A ESQUERDA 
               sh t6, 4(a5)
               
               li t6, 5                       # MUDA O SPRITE PARA O SPRITE DE ATACAR
               sh t6, 4(a4)
               
               j ATIRA

MIRAR_DIR:     li t6, 3                       # VIRA A ENTIDADE PARA A DIREITA
               sh t6, 4(a5)
               
               li t6, 5                       # MUDA O SPRITE PARA O SPRITE DE ATACAR
               sh t6, 4(a4)

ATIRA:         addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
               addi a5, a3, 16
               jal ra, ATIRAR
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               mv a3, a6
               addi a4, a3, 8
               addi a5, a4, 8
               
               addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
               call OLD_POS
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               la a0, escorpiao_atirando
               lh t1, 12(a6)                  # frame atual da Samus
	   
	       li t2, 264
	       mul t1, t1, t2                
	       add a0, a0, t1	   
	   
 	       lh a1, 0(a6)                   # Imprime a posição X do personagem
 	       lh a2, 2(a6)                   # Imprime a posição Y do personagem
 	       mv a7, s0
               
               addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
               call PRINT
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
	       j INIMIGO_FIM
	     
SCORPIO_ANDA:  addi a5, a6, 16

               sh t0, 4(a5)                   # VERIFICA SE ESTÁ INDO PARA A ESQUERDA OU DIREITA
               
               beq t0, zero, SCORPIO_ESQ
               
               li t6, 1
               beq s1, t6, SCORPIO_DIR
               
               li t1, 2
               beq t0, t1, SCORPIO_DIR
                              
               li t6, 3
               beq s1, t6, SCORPIO_ESQ
          
               
SCORPIO_DIR:   addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
               addi a4, a3, 8
               addi a5, a4, 8
               jal ra, CHAR_DIR
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               #bne s1, zero, SCORPIO_COLIDE
               
               la a0, escorpiao_atirando
               lh t1, 12(a6)                  # frame atual da Samus
	   
	       li t2, 264
	       mul t1, t1, t2                
	       add a0, a0, t1	   
	   
 	       lh a1, 0(a6)                   # Imprime a posição X do personagem
 	       lh a2, 2(a6)                   # Imprime a posição Y do personagem
 	       mv a7, s0
               
               addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
               call PRINT
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               j SCORPIO_GRAVIDADE
               
SCORPIO_ESQ:   addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
               addi a4, a3, 8
               addi a5, a4, 8
               jal ra, CHAR_ESQ           
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               la a0, escorpiao_atirando
               lh t1, 12(a6)                  # frame atual da Samus
	   
	       li t2, 264
	       mul t1, t1, t2                
	       add a0, a0, t1	   
	   
 	       lh a1, 0(a6)                   # Imprime a posição X do personagem
 	       lh a2, 2(a6)                   # Imprime a posição Y do personagem
 	       mv a7, s0
               
               addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
               call PRINT
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta

SCORPIO_COLIDE:
               
SCORPIO_GRAVIDADE:
               addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
               addi a4, a3, 8
               addi a5, a4, 8
    	       mv a3, a6
               jal ra, CHAR_BAIXO
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               la a0, escorpiao_atirando
               lh t1, 12(a6)                  # frame atual da Samus
               li t2, 264
	       mul t1, t1, t2                
	       add a0, a0, t1	   
	   
 	       lh a1, 0(a6)                   # Imprime a posição X do personagem
 	       lh a2, 2(a6)                   # Imprime a posição Y do personagem
 	       mv a7, s0
               
               addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
               call PRINT
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
        
               j INIMIGO_FIM
#--------------------------------------------------------------------------------------------------------------------------------------
# Descreve o comportamento do tipo de inimigo VOADOR0
VOADOR_TURN:   
	        
	       j INIMIGO_FIM

VOADOR_ATACK:

VOADOR_VOA:
#--------------------------------------------------------------------------------------------------------------------------------------
# DESCREVE O COMPORTAMENTO DE UM PROJÉTIL
PROJETIL_TURN: lh a1, 0(a3)                    # salva a posição X do Projétil
	       lh a2, 2(a3)                    # salva a posição Y do Projétil
	       
	       addi t3, t1, 15                 # AGORA EM T1 ESTÁ O PRIMEIRO BIT HORIZONTAL DA SAMUS E EM T3 O ÚLTIMO BIT HORIZONTAL DA SAMUS
	       addi t4, t2, 31                 # AGORA EM T2 ESTÁ O PRIMEIRO BIT VERTICAL   DA SAMUS E EM T4 O ÚLTIMO BIT VERTICAL   DA SAMUS
	       
	       slt t6, a1, t3                  # VERIFICA SE PROJ_X É MENOR QUE O BIT HORIZONTAL DA DIREITA DA SAMUS
	       slt a5, t1, a1                  # VERIFICA SE O BIT HORIZONTAL DA ESQUERDA DA SAMUS É MENOR QUE PROJ_X
	       
	       and s9, t6, a5                  # VERIFICA SE O PROJÉTIL ESTÁ DENTRO DA SAMUS NA HORIZONTAL
	       mv a4, s9
	       
	       slt t6, a2, t4                  # VERIFICA SE PROJ_Y É MENOR QUE O BIT VERTICAL DE BAIXO DA SAMUS
	       slt a5, t2, a2                  # VERIFICA SE O BIT VERTICAL DE CIMA DA SAMUS É MENOR QUE PROJ_Y
	       
	       and s9, t6, a5                  # VERIFICA SE O PROJÉTIL ESTÁ DENTRO DA SAMUS NA VERTICAL
	       mv a5, s9
	       
	       and s1, a4, a5                  # VERIFICA SE O PROJÉTIL ESTÁ AO MESMO TEMPO DENTRO DA SAMUS VERTICALMENTE E HORIZONTALMENTE
	       
	       li t1, 1
	       beq s1, t1, PROJETIL_ATAK
	       j PROJETIL_ANDA
	       
PROJETIL_ATAK: sh zero, 4(a6)                  # MUDA A VIDA DO PROJÉTIL PARA ZERO E APAGA O PROJETO

               addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
               addi a4, a3, 8
               call OLD_POS
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta

               j SAMUS_DANO                    # PULA PARA A SAMUS TOMANDO O DANO

PROJETIL_ANDA: addi a5, a6, 16
               lh t1, 4(a5)               # VERIFICA SE O PROJÉTIL ESTÁ INDO PARA A ESQUERDA OU PARA A DIREITA
               beq t1, zero, PROJETIL_ESQ
               j PROJETIL_DIR

PROJETIL_DIR:  addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                # Salva ra na pilha
    	       mv a3, a6
    	       addi a4, a3, 8
    	       addi a5, a4, 8
               jal ra, CHAR_DIR            
               lw ra, 0(sp)                # Restaura ra da pilha
               addi sp, sp, 4              # Ajusta a pilha de volta
               
               bne s1, zero, PROJETIL_MORRE
               
               la a0, projetil
               lh a1, 0(a6)                   # Imprime a posição X do personagem
 	       lh a2, 2(a6)                   # Imprime a posição Y do personagem
 	       mv a7, s0
               
               addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
               call PRINT
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
              
               j INIMIGO_LOOP

PROJETIL_ESQ: addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	      sw ra, 0(sp)                # Salva ra na pilha
    	      mv a3, a6
    	      addi a4, a3, 8
    	      addi a5, a4, 8
              jal ra, CHAR_ESQ            
              lw ra, 0(sp)                # Restaura ra da pilha
              addi sp, sp, 4              # Ajusta a pilha de volta
              
              bne s1, zero, PROJETIL_MORRE
              
              la a0, projetil
              lh a1, 0(a6)                   # Imprime a posição X do personagem
 	      lh a2, 2(a6)                   # Imprime a posição Y do personagem
 	      mv a7, s0
               
              addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	      sw ra, 0(sp)                   # Salva ra na pilha
              call PRINT
              lw ra, 0(sp)                   # Restaura ra da pilha
              addi sp, sp, 4                 # Ajusta a pilha de volta
              
              j INIMIGO_LOOP
              
PROJETIL_MORRE:
              sh zero, 4(a6)
              
              addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	      sw ra, 0(sp)                   # Salva ra na pilha
    	      mv a3, a6
              mv a4, a6
              call OLD_POS
              lw ra, 0(sp)                   # Restaura ra da pilha
              addi sp, sp, 4                 # Ajusta a pilha de volta
              
              j INIMIGO_LOOP
              
#-------------------------------------------------------------------------------------------------------------------------------------

SAMUS_DANO:    lh t0, 4(s3)
               addi t0, t0, -1
               sh t0, 4(s3)
               j INIMIGO_LOOP

INIMIGO_FIM:   j INIMIGO_LOOP

FINAL_LOOP:    ret
		    
#---------------------------------------------------------------LINKED LIST--------------------------------------------------------------------------
ADD_ITEM:
    # SE O ÍNDICE DO ITEM FOR 25, SIGNIFICA QUE A LISTA ESTÁ CHEIA
    
    addi t6, s4, -24       # CALCULA O ENDEREÇO DO ÚLTIMO ITEM
    lh t5, 22(t6)          # CARREGA O ÍNDICE DO ELEMENTO ANTERIOR
    
    li t4, 25
    beq t5, t4, LISTA_CHEIA
    
    mv t0, s4
    addi t5, t5, 1
    j ADD_ENTIDADE         

ADD_ENTIDADE:
    # Carregar endereï¿½o atual para adicionar na lista `entidades_info`
    sh a1, 0(t0)           # Salvar posição x
    sh a2, 2(t0)           # Salvar posição y
    sh a3, 4(t0)           # Salva a vida da Entidade
    sh a4, 6(t0)           # Salva o tipo da Entidade
    
    sh a1, 8(t0)           # Salvar old_posição_x
    sh a2, 10(t0)          # Salvar old_posição_y
    sh zero, 12(t0)        # salva o frame atual 
    li t1, 1
    sh t1, 14(t0)          # salva BAIXO/PARADO/CIMA
    
    sh a1, 16(t0)          # Salvar next_posição_x
    sh a2, 18(t0)          # Salvar next_posição_y
    sh a5, 20(t0)          # Salva esquerda/direita
    sh t5, 22(t0)          # Salva o índice
    
    addi s4, s4, 24
    ret

SOBRESCREVE_ITEM:
   mv t0, t6
   j ADD_ENTIDADE

LISTA_CHEIA:
    mv t6, s3
    addi t6, t6, 24
    j GARBAGE_COLLECTOR

GARBAGE_COLLECTOR:
   lh t5, 22(t6)
   
   li t4, 25
   beq t4, t5, SEM_ESPACOS_LIVRES
   
   lh t3, 4(t6)
   beq t3, zero, SOBRESCREVE_ITEM
   
   addi t6, t6, 24
   j GARBAGE_COLLECTOR
   
SEM_ESPACOS_LIVRES:
   ret
#----------------------------------------------------------------PRINT--------------------------------------------------------------------------------

# a0 = endereço imagem
# a1 = x (coluna)
# a2 = y (linha)
# a3 = frame (0 ou 1)
#
##
#
# t0 = endereço do bitmap display
# t1 = endereço da imagem
# t2 = contador de linha
# t3 = contador de coluna
# t4 = largura
# t5 = altura 
# 

PRINT:       
    li t0, 0xFF0
    add t0, t0, a7
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
    li a7, 0
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    li a7, 1
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha 
    call PRINT
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    ret

PRINT_MAP:
    # Calcular a posiï¿½ï¿½o x e y com base nos ï¿½ndices de linha e coluna
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
    add a0, a0, t2              # O ENDEREï¿½O DO TILE METAL ESTï¿½ 256 BYTES DEPOIS DE TIJOLOS, ENTï¿½O SE T2 = 1 => TIJOLOS + (1 x 256) = METAL
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    j NEXT_PIXEL
    
ADD_VOADOR:
    la a0, mariposa_parada
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta

    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha
    li a3, 2                    # VIDA DA ENTIDADE
    li a4, 2                    # TIPO DA ENTIDADE
    li a5, 2                    # ESQ/DIR
    call ADD_ITEM
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
	   
    j NEXT_PIXEL

ADD_ESCORPIAO:
    la a0, escorpiao_atirando
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha
    li a3, 1                    # VIDA DA ENTIDADE
    li a4, 1                    # TIPO DA ENTIDADE
    li a5, 0                    # ESQ/DIR
    call ADD_ITEM
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
	   
    j NEXT_PIXEL
    
NEXT_PIXEL:
    # Avanï¿½a para o prï¿½ximo pixel (coluna)
    addi s11, s11, 1    # Avanï¿½a para o prï¿½ximo byte do mapa
    addi s2, s2, 1      # Prï¿½xima coluna
    
    li t3, 20           # Total de colunas
    blt s2, t3, PRINT_MAP
    mv s2, zero

    # Prï¿½xima linha
    addi s1, s1, 1
        
    li t3, 15         # Total de linhas (excluindo a primeira)
    blt s1, t3, PRINT_MAP
    
    ret
.data
#--------------------------------------------------LISTAS------------------------------------------------------------------------

ENTIDADES_INFO: .half 32, 32, 5, 0,              # X = 32, Y = 32, Vida = 10, Tipo da entidade = 0       (CHAR_POS, VIDA, TIPO)
                      32, 32, 0, 0,               # X = 32, Y = 32, Frame atual = 0, BAIXO (0) /PARADO (1) / CIMA (2) = 1    (OLD_CHAR_POS, FRAMES_ANIMAÇÃO)
                      32, 32, 3, 1                # X = 32, Y = 32, ESQ (0)/ PARADO (1) /DIR (2) = 1, ÍNDICE                   (NEXT_CHAR_POS, ESQ/DIR, ÍNDICE)
                      
		.space 576                        # Cada entidade tem 24 bytes, quero que a lista tenha 25 entidades

#--------------------------------------------------TILES------------------------------------------------------------------------
tijolo_coracao: .word 16, 16
                .byte 

tijolos: .word 16, 16
         .byte 173,173,173,173,0,0,173,173,173,173,173,0,173,173,173,173,
               173,173,173,173,173,0,173,173,173,173,173,0,173,173,173,173,
               173,173,173,173,173,0,173,173,173,173,173,0,0,173,173,173,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               173,173,173,0,173,173,173,173,0,0,0,173,173,173,173,173,
               173,173,173,0,173,173,173,173,173,0,173,173,173,173,173,173,
               173,173,0,0,173,173,173,173,173,0,173,173,173,173,173,173,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               173,173,173,173,173,0,0,173,173,173,173,0,173,173,173,173,
               173,173,0,173,173,0,173,173,173,173,173,0,173,173,173,173,
               173,0,0,173,173,0,173,173,173,173,173,0,173,173,173,173,
               0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
               0,173,173,0,173,173,173,173,173,0,173,173,173,173,173,173,
               173,173,173,0,0,173,173,173,173,0,173,173,173,173,173,173,
               173,173,173,0,0,173,173,173,173,0,173,173,173,173,0,173,
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


# PRï¿½XIMO TILE,  QUE SERï¿½ IDENTIFICADO COMO 2

# PRï¿½XIMO TILE, QUE SERï¿½ IDENTIFICADO COMO 3

# ETC...

# 7 ï¿½ PARA VOADOR, Nï¿½O PODE SER TILE
# 8 ï¿½ PARA ESCORPIï¿½O, Nï¿½O PODE SER TILE
# 9 ï¿½ VAZIO, Nï¿½O PODE SER TILE 

#--------------------------------------------------MAPAS------------------------------------------------------------------------
mapa_1: .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	      0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,8,9,9,9,0,0,0,0,0,0,0,0,0,
              0,0,0,0,0,0,0,0,0,9,9,9,0,9,9,9,9,9,0,0,
              0,0,9,9,9,9,9,9,0,1,9,9,0,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,9,0,9,9,9,0,9,8,9,9,9,9,0,
              0,9,9,9,9,9,9,0,0,9,9,9,0,0,0,9,9,9,9,0,
              0,9,9,9,9,0,0,0,9,9,9,1,0,9,9,9,9,0,0,0,
              0,9,9,9,0,0,9,9,9,9,9,9,0,9,9,9,9,0,0,0,
              0,9,9,0,0,9,9,9,9,9,9,9,0,9,9,9,0,0,0,0,
              0,9,9,9,9,9,9,9,9,9,1,9,9,9,9,0,0,0,0,0,
              0,1,9,9,9,8,9,9,9,1,1,9,9,9,1,0,0,0,0,0,
              0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

#-------------------------------------------------SPRITES SAMUS-------------------------------------------------------------------

samus_parada:   .word 16, 32
		.byte 7,199,199,199,199,91,91,91,199,199,199,199,199,199,199,7,
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
		7,91,91,91,199,199,199,199,199,199,199,199,199,199,199,7

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
		
samus_andando_3:.word 16, 32  # NA VERDADE É O FRAME 1 REPETIDO
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
		
samus_andando_4:.word 16, 32
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

Samus_agachada: .word 16, 16
		.byte 0,0,0,0,0,91,91,91,91,91,91,91,0,0,0,0,
		0,0,0,0,91,114,91,0,47,0,91,91,91,0,0,0,
		0,0,0,91,114,91,91,47,0,47,91,114,47,0,0,0,
		0,0,0,91,91,91,91,91,91,91,91,114,114,47,0,0,
		0,0,0,24,24,24,24,47,24,91,91,114,114,114,0,0,
		0,0,24,24,24,24,47,24,47,24,91,24,47,47,91,47,
		0,0,24,24,24,47,24,24,24,24,24,24,47,47,47,47,
		0,0,47,47,24,24,24,24,24,24,24,47,47,114,114,114,
		0,0,47,24,24,24,47,24,0,24,24,47,47,47,91,47,
		0,0,0,24,24,24,47,24,24,0,0,0,0,0,0,0,
		0,0,0,0,24,24,24,24,24,24,24,24,47,47,0,0,
		0,0,0,0,24,24,24,24,24,24,24,24,24,47,0,0,
		0,0,0,0,0,24,24,24,24,24,0,24,24,0,0,0,
		91,91,0,0,24,24,24,0,0,0,24,24,24,0,0,0,
		91,114,91,24,24,24,24,0,0,91,91,114,0,0,0,0,
		114,91,91,47,47,24,0,0,0,91,114,91,91,0,0,0
		.space 256

samus_bola:       .word 16, 16
		  .byte 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
			255,255,255,255,255,255, 24, 24, 91,255,255,255,255,255,255,255,
			255,255,255,255,24,24,24,24,91,91,91,255,255,255,255,255,
			255,255,255,24,47,47,47,24,91,91,91,91,255,255,255,255,
			255,255,24,47,47,47,24,24,91,91,91,91,91,255,255,255,
			255,24,24,47,47,24,24,24,91,91,91,47,91,91,255,255,
			255,24,24,47,24,24,24,24,91,91,47,91,91,91,255,255,
			24,24,24,24,24,24,24,24,24,91,91,91,91,91,91,255,
			24,24,24,24,47,47,24,24,24,24,91,91,91,91,91,255,
			24,24,24,24,24,24,47,24,24,24,24,91,91,91,91,255,
			255,24,24,24,24,24,24,47,24,24,24,24,24,91,255,255,
			255,24,24,24,24,24,24,24,47,47,24,24,24,24,255,255,
			255,255,91,91,114,24,24,24,47,47,47,24,24,255,255,255,
			255,255,255,91,91,114,24,24,24,47,47,24,255,255,255,255,
			255,255,255,255,91,91,91,24,24,24,24,255,255,255,255,255,
			255,255,255,255,255,255,91,24,24,255,255,255,255,255,255,255,


#---------------------------------------------------------------------------------------------------------------------------------

mariposa_parada:   .word 16, 32
                   .byte
                 
mariposa_voando_1: .word 16, 32
                   .byte
                   
mariposa_voando_2: .word 16, 32
                   .byte

mariposa_voando_3: .word 16, 32
                   .byte

mariposa_voando_4: .word 16, 32
                   .byte
                   
#---------------------------------------------------------------------------------------------------------------------------------

escorpiao_atirando:  .word 16, 16
		     .byte 0,0,82,7,0,0,0,0,0,0,0,0,0,0,0,0,
		           0,82,7,7,7,0,7,0,0,0,0,0,0,0,0,0,
			   82,39,7,7,7,7,0,0,0,0,0,0,0,0,0,0,
			   82,39,28,7,7,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,
			   82,39,39,28,82,82,82,82,0,0,0,0,0,0,0,0,
			   82,39,39,39,28,39,39,39,82,82,82,0,0,0,0,0,
			   0,82,39,28,39,39,39,28,39,39,39,82,82,82,82,0,
			   0,82,28,82,39,39,28,28,39,39,28,39,39,255,39,82,
			   0,0,82,39,82,28,28,82,28,28,28,82,28,28,28,82,
			   0,0,82,39,82,82,82,39,82,82,82,39,82,82,82,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,0,82,0,0,0,82,0,0,0,82,0,0,0,0

                 
escorpiao_andando_1: .word 16, 16
		     .byte 0,0,82,7,0,0,0,0,0,0,0,0,0,0,0,0,
		           0,82,7,7,7,0,7,0,0,0,0,0,0,0,0,0,
			   82,39,7,7,7,7,0,0,0,0,0,0,0,0,0,0,
			   82,39,28,7,7,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,
			   82,39,39,28,82,82,82,82,0,0,0,0,0,0,0,0,
			   82,39,39,39,28,39,39,39,82,82,82,0,0,0,0,0,
			   0,82,39,28,39,39,39,28,39,39,39,82,82,82,82,0,
			   0,82,28,82,39,39,28,28,39,39,28,39,39,255,39,82,
			   0,0,82,39,82,28,28,82,28,28,28,82,28,28,28,82,
			   0,0,82,39,82,82,82,39,82,82,82,39,82,82,82,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,0,82,0,0,0,82,0,0,0,82,0,0,0,0
                   
escorpiao_andando_2: .word 16, 16
		     .byte 0,0,82,7,0,0,0,0,0,0,0,0,0,0,0,0,
		           0,82,7,7,7,0,7,0,0,0,0,0,0,0,0,0,
			   82,39,7,7,7,7,0,0,0,0,0,0,0,0,0,0,
			   82,39,28,7,7,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,
			   82,39,39,28,82,82,82,82,0,0,0,0,0,0,0,0,
			   82,39,39,39,28,39,39,39,82,82,82,0,0,0,0,0,
			   0,82,39,28,39,39,39,28,39,39,39,82,82,82,82,0,
			   0,82,28,82,39,39,28,28,39,39,28,39,39,255,39,82,
			   0,0,82,39,82,28,28,82,28,28,28,82,28,28,28,82,
			   0,0,82,39,82,82,82,39,82,82,82,39,82,82,82,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,0,82,0,0,0,82,0,0,0,82,0,0,0,0

escorpiao_andando_3: .word 16, 16
		     .byte 0,0,82,7,0,0,0,0,0,0,0,0,0,0,0,0,
		           0,82,7,7,7,0,7,0,0,0,0,0,0,0,0,0,
			   82,39,7,7,7,7,0,0,0,0,0,0,0,0,0,0,
			   82,39,28,7,7,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,
			   82,39,39,28,82,82,82,82,0,0,0,0,0,0,0,0,
			   82,39,39,39,28,39,39,39,82,82,82,0,0,0,0,0,
			   0,82,39,28,39,39,39,28,39,39,39,82,82,82,82,0,
			   0,82,28,82,39,39,28,28,39,39,28,39,39,255,39,82,
			   0,0,82,39,82,28,28,82,28,28,28,82,28,28,28,82,
			   0,0,82,39,82,82,82,39,82,82,82,39,82,82,82,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,0,82,0,0,0,82,0,0,0,82,0,0,0,0

escorpiao_andando_4: .word 16, 16
		     .byte 0,0,82,7,0,0,0,0,0,0,0,0,0,0,0,0,
		           0,82,7,7,7,0,7,0,0,0,0,0,0,0,0,0,
			   82,39,7,7,7,7,0,0,0,0,0,0,0,0,0,0,
			   82,39,28,7,7,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,
			   82,39,39,28,82,82,82,82,0,0,0,0,0,0,0,0,
			   82,39,39,39,28,39,39,39,82,82,82,0,0,0,0,0,
			   0,82,39,28,39,39,39,28,39,39,39,82,82,82,82,0,
			   0,82,28,82,39,39,28,28,39,39,28,39,39,255,39,82,
			   0,0,82,39,82,28,28,82,28,28,28,82,28,28,28,82,
			   0,0,82,39,82,82,82,39,82,82,82,39,82,82,82,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,0,82,0,0,0,82,0,0,0,82,0,0,0,0
			   
escorpiao_caindo:    .word 16, 16
		     .byte 0,0,82,7,0,0,0,0,0,0,0,0,0,0,0,0,
		           0,82,7,7,7,0,7,0,0,0,0,0,0,0,0,0,
			   82,39,7,7,7,7,0,0,0,0,0,0,0,0,0,0,
			   82,39,28,7,7,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,0,
			   39,39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,
			   82,39,39,28,82,82,82,82,0,0,0,0,0,0,0,0,
			   82,39,39,39,28,39,39,39,82,82,82,0,0,0,0,0,
			   0,82,39,28,39,39,39,28,39,39,39,82,82,82,82,0,
			   0,82,28,82,39,39,28,28,39,39,28,39,39,255,39,82,
			   0,0,82,39,82,28,28,82,28,28,28,82,28,28,28,82,
			   0,0,82,39,82,82,82,39,82,82,82,39,82,82,82,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,82,28,82,0,82,28,82,0,82,28,82,0,0,0,
			   0,0,0,82,0,0,0,82,0,0,0,82,0,0,0,0
                   
#---------------------------------------------------------------------------------------------------------------------------------

projetil: .word 4, 4
	  .byte 199,7,7,199,
		7, 55, 55,7,
		7, 55, 55,7,
		199,7,7,199
		
projetil_inimigo: .word 4, 4
	          .byte 199,114,114,199,
		        114, 55, 55,114,
		        114, 55, 55,114,
		        199,114,114,199
		
#---------------------------------------------------------------------------------------------------------------------------------
old_char_pos:   .word 16, 32
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

projetil_old_pos: .word 4, 4
	   	  .byte 0,0,0,0,
		        0,0,0,0,
		        0,0,0,0,
		        0,0,0,0

half_old_char_pos: .word 16, 16
	  	   .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		 	 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

#--------------------------------------------------------------------------------------------------------------------------------
