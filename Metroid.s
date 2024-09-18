.text
# s0 = CONTADOR DE FRAME PARA GAME_LOOP

# s1 = GUARDA O �NDICE DA LINHA NA HORA DE PRINTAR O MAPA / ARMAZENA SE O PERSONAGEM IR� COLIDIR OU N�O (1 PARA SIM E 0 PARA N�O)
# S2 = GUARDA O �NDICE DA COLUNA NA HORA DE PRINTAR O MAPA

# S3 = PONTEIRO DA CABE�A DAS LISTAS ENTIDADES_INFO, OLD ENTIDADES_INFO E NEXT_ENTIDADES_INFO
# S4 = PONTEIRO QUE INDICA O ENDERE�O PARA ADICIONAR O PR�XIMO ITEM NA LISTAS

# S5 = ARMAZENA QUANTAS VEZES O PERSONAGEM PODE IR PARA CIMA NO PULO 
# S6 = IN�RCIA, ARMAZENA SE O PERSONAGEM PULOU PARA A DIREITA OU PARA A ESQUERDA (0 = ESQUERDA, 1, RETO, 2 DIREITA)

# S7 = ITENS DA SAMUS, SE S7 = 0, SAMUS N�O TEM NENHUM ITEM, S7 = 1, SAMUS GANHA A HABILIDADE DE VIRAR A BOLA, S7 = 2, SAMUS GANHA DOBRO DE DANO
# S8 = SALVA QUANTAS CHAVES O JOGADOR J� RECOLHEU PARA GANHAR O JOGO / SALVA SE O JOGADOR GANHOU O JOGO

# S9 =  n�mero de passos da Samus at� trocar de mapa
# S10 = SALVA O QUANTO A SAMUS PODE ANDAR
# S11 = SALVA O MAPA ATUAL

MAIN: la s3, ENTIDADES_INFO       # ENDERE�O DA LISTA CONTENDO AS ENTIDADES
      addi s4, s3, 24             # ENDERE�O DA LISTA ONDE DEVE SER SALVO O PR�XIMO ITEM
      
      la, s11, mapa_1
      addi s9, s11, 4
      li s10, 16
      
      li s5, 0 
      li s7, 0
      li s8, 0
      call SETUP
      
      la s11, mapa_2
      addi s9, s11, 4
      li s10, 36
      sh s10, 0(s3)
      sh s10, 8(s3)
      sh s10, 16(s3)
      
      li s5, 0
      li s7, 0
      li s8, 0
      call SETUP
      
      #la s11, mapa_3
      #addi s9, s11, 4
      #li s10, 36
      #sh s10, 0(s3)
      #sh s10, 8(s3)
      #sh s10, 16(s3)
      
      #li s5, 0
      #li s7, 0
      #li s8, 0
      #call SETUP
      
      li a7, 10
      ecall
      
      # SALVA OS OUTROS MAPAS

#------------------------JOGO----------------------------------------------

SETUP:     addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
    	   li a1, 0                    # INICIALIZA X E Y COMO ZERO
    	   li a2, 0
    	   li s1, 0                    # �ndice da linha
	   li s2, 0                    # �ndice da coluna
           call PRINT_MAP
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
	   
	   li s1, 0                    # frame de colis�o
	   addi s9, s11, 4
	   li s0, 0                    # Frame de in�cio
    	   
	   addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call GAME_LOOP
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
	   
	   ret
	   
GAME_OVER: li a7, 10                  # VEM PARA C� SE A VIDA DA SAMUS FOR ZERO
           ecall 
	   
#------------------------------------------------------------------------GAME LOOP--------------------------------------------------------------------
       
GAME_LOOP: xori s0, s0, 1
            
           li t1, 320
           addi t0, s10, 16
           rem t2,t0, t1
           beq t2, zero, ANDA_MAPA_DIR
           
           
	   rem t0, s10, t1
	   beq t0, zero, ANDA_MAPA_ESQ
           
           #li a7, 5
           #ecall 
           
           j SEGUE_LOOP
           
           #-------------------------------------------------------------------------------------------------------
ANDA_MAPA_DIR:
            addi s4, s3, 24             # REINICIA A LISTA DE ENTIDADES
            
            addi s10, s10, 20
            addi s9, s9, 20
            
            li t0, 4
            sh t0, 0(s3)
            sh t0, 8(s3)              # COLOCA A SAMUS NA POSI��O ZERO EM CHAR_POS, OLD_CHAR_POS E NEXT_CHAR_POS
            sh t0, 16(s3)
            
            j PRINTA_MAPA
ANDA_MAPA_ESQ:
           addi s4, s3, 24              # REINICIA A LISTA DE ENTIDADES
          
           addi s10, s10, -20
           addi s9, s9, -20
           
           li t0, 300
           sh t0, 0(s3)
           sh t0, 8(s3)              # COLOCA A SAMUS NA POSI��O 304 EM CHAR_POS, OLD_CHAR_POS E NEXT_CHAR_POS
           sh t0, 16(s3)

PRINTA_MAPA:
           mv a6, s9
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
    	   li a1, 0                    # INICIALIZA X E Y COMO ZERO
    	   li a2, 0
    	   li s1, 0                    # �ndice da linha
	   li s2, 0                    # �ndice da coluna
           call PRINT_MAP
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           mv s9, a6
           
           #--------------------------------------------------------------------------------------------------------

SEGUE_LOOP:addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call IA_ENTIDADES
           lw ra, 0(sp)                # Restaura ra da pilhad
           addi sp, sp, 4              # Ajusta a pilha de volta
           
#DELAY:     li t0, 5000                    # Define o valor do contador (ajuste para o atraso desejado)
  
#DELAY_LOOP:addi t0, t0, -1             # Decrementa o contador
#           beq t0, zero, VOLTA_LOOP    # Se o contador n�o chegou a 0, continua o loop
#           j DELAY_LOOP                # Retorna quando o contador atingir 0

VOLTA_LOOP:li t0, 0xFF200604
 	   sw s0, 0(t0)
 	   
 	   lh t0, 4(s3)                # SE A VIDA DA SAMUS FOR ZERO, ENCERRA O JOGO
 	   beq t0, zero, GAME_OVER
 	   
 	   addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call PRINT_VIDA_E_ITENS
           lw ra, 0(sp)                # Restaura ra da pilhad
           addi sp, sp, 4              # Ajusta a pilha de volta
 	   
 	   li t0, 4
 	   beq s8, t0, NEXT_LEVEL
 	   j GAME_LOOP
 	   
NEXT_LEVEL:  ret                       # QUANDO O PERSONAGEM PASSA DE FASE, O LOOP ACABA E ELE VOLTA PARA SETUP, ONDE O SEGUNDO MAPA SER� CARREGADO E O LOOP RETORNA

#------------------------------------------------A��ES QUE O JOGADOR PODE FAZER COM O TECLADO PARA A SAMUS REALIZAR-----------------------------------------------------------------------

KEY: li t1, 0xFF200000                 # carrega o endere�o do controle do KDMMIO
     lw t0, 0(t1)                      # Le bit de Controle Teclado
     andi t0, t0, 0x0001               # mascara o bit menos significativo
     beq t0, zero, FIM                 # Se n�o h� tecla pressionada ent�o vai para FIM
     lw t2, 4(t1)                      # le o valor da tecla tecla
     
     lh t0, 6(a3)                      # DEPENDENDO DO ESTADO EM QUE A SAMUS SE ENCONTRA, SUAS A��ES POSS�VEIS S�O DIFERENTES
     
     beq t0, zero, SAMUS_NORMAL        # SAMUS EM P�
     
     li t1, 2
     beq t0, t1, SAMUS_AGACHADA
     
     li t1, 1
     beq t0, t1, SAMUS_BOLA         
     
 #---------------------------------------------
SAMUS_NORMAL:
     
     li t6, 'f'
     beq t2, t6, ATIRAR
     
     #------------------------------------------
     
     li t6, 'a'
     beq t2, t6, CHAR_ESQ
     
     #-------------------------------------------
     
     li t6, 'd'
     beq t2, t6, CHAR_DIR
     
     #------------------------------------------             NENHUMA DAS PR�XIMAS A��ES PODE SER REALIZADA DURANTE UM PULO OU QUEDA
     
     li t6, 'e'
     beq t2, t6, QUER_VIRAR_BOLA
     j SEGUE_NORMAL
     
QUER_VIRAR_BOLA:
     lh t0, 6(a4)
     beq t0, zero, FIM                 # O PERSONAGEM N�O PODE VIRAR BOLA SE ESTIVER CAINDO
     
     li t0, 1
     beq s7, t0, VIRAR_BOLA
     
     #------------------------------------------
SEGUE_NORMAL: 
     li t6, 's'
     beq t2, t6, QUER_AGACHAR
     j SEGUE_NORMAL_2
     
QUER_AGACHAR:
     lh t0, 6(a4)
     beq t0, zero, SEGUE_NORMAL_2      # O PERSONAGEM N�O PODE AGACHAR SE ESTIVER CAINDO
     
     beq t2, t6, CHAR_AGACHA
     
     #-------------------------------------------
SEGUE_NORMAL_2:     
     li t6, 'w'
     bne s5, zero, FIM                 # O PERSONAGEM N�O PODE SE MOVER ENQUANTO ESTIVER PULANDO
     
     lh t0, 6(a4)
     beq t0, zero, FIM                 # O PERSONAGEM N�O PODE PULAR SE ESTIVER CAINDO
     
     beq t2, t6, CHAR_PULA
     
     J FIM
     
#-------------------------------------------
SAMUS_AGACHADA:

     li t6, 'f'
     beq t2, t6, ATIRAR
     
     #------------------------------------------
     
     li t6, 's'
     beq t2, t6, CHAR_LEVANTA
     
     #------------------------------------------
     
     li t6, 'p'
     beq t2, t6, GANHOU_A_FASE
     j FIM
     
GANHOU_A_FASE:
     li s8, 4
     j FIM
     
#------------------------------------------
SAMUS_BOLA:

     li t6, 'e'
     beq t2, t6, VIRAR_HUMANA
     
     #-------------------------------------------
     
     li t6, 'a'
     beq t2, t6, CHAR_ESQ
     
     #-------------------------------------------
     
     li t6, 'd'
     beq t2, t6, CHAR_DIR
     
     #-------------------------------------------
     
     li t6, 'w'
     bne s5, zero, FIM                 # O PERSONAGEM N�O PODE SE MOVER ENQUANTO ESTIVER PULANDO
     
     lh t0, 6(a4)
     beq t0, zero, FIM                 # O PERSONAGEM N�O PODE PULAR SE ESTIVER CAINDO
     
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

#-----------------------------------------------------------MODO BOLA---------------------------------------------------------------------------------

VIRAR_BOLA:
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
	   
           li t0, 1
           sh t0, 6(a3)                # MUDA O TIPO DA SAMUS PARA O TIPO DE UN INIMIGO 16 X 16 PIXELS
           
           li t0, 7
           sh t0, 4(a4)                # MUDA O FRAME ATUAL DA SAMUS PARA O FRAME AGACHAR
           ret

VIRAR_HUMANA:
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

#---------------------------------------------------------CRIAR UM PROJ�TIL E ATIRAR------------------------------------------------------------------

ATIRAR:    lh a1, 0(a3)
           lh a2, 2(a3)
           
           lh t0, 6(a3)                # PEGA O TIPO DA ENTIDADE QUE ATIROU (PRECISA SER A ENTIDADE E N�O O �NDICE POIS A SAMUS MUDA DE TIPO)
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
       
       #------------------------------------------------------------
       
TIRO_SAMUS:
           li t2, 0
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
           lh t0, 22(a3)
           li t1, 1
           beq t0, t1, PRO_SAMUS
           j PRO_ENT

PRO_SAMUS: li a7, 1
           li t0, 2
           beq s7, t0, DANO_EXTRA
           
           li a3, 1
           j CRIA_TIRO

DANO_EXTRA: li a3, 3
            j CRIA_TIRO
                
PRO_ENT:   li a7, 2
           li a3, 1
                                                
CRIA_TIRO: addi sp, sp, -4             # Ajusta a pilha para salvar ra
	   sw ra, 0(sp)                # Salva ra na pilha
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
           
#------------------------------------------------CHAR DEFINE A ALTURA DO PULO E A IN�RCIA--------------------------------------------------------------------------------------------

CHAR_PULA: li s5, 32                   # 36 PIXELS PARA CIMA E 16 PARA OS LADOS, CASO HAJA IN�RCIA, OU APENAS 48 PIXELS PARA CIMA
  
           lh t0, 4(a5)                # ESQ/PARADO/DIR
                 
           li t1, 0
           beq t1, t0, INERCIA_ESQ
                 
           li t1, 1
           beq t1, t0, SEM_INERCIA
                 
           li t1, 3
           beq t1, t0, SEM_INERCIA
                 
           li t1, 2
           beq t1, t0, INERCIA_DIR

INERCIA_ESQ:
           li s6, 0              
           ret

SEM_INERCIA:     
           li s6, 1            
           ret

INERCIA_DIR:     
           li s6, 2
           ret
                 
#------------------------------------------------MOVIMENTA��O EM 4 EIXOS DA SAMUS-------------------------------------------------------------------------------------
CHAR_ESQ:  sh zero, 4(a5)              # muda o valor ESQUERDA/DIREITA do personagem para 0, pois ele esta�andando para a ESQUERDA

           lh t0, 6(a5)
           li t1, 1
           beq t0, t1, SAMUS_HOR_POS_ESQ
           j ENTIDADE_HOR_POS_ESQ

SAMUS_HOR_POS_ESQ:
           mv a1, s10
           addi a1, a1, -4
           sh a1, 0(a5)
           lh a2, 2(a5)
           j SEGUE_CHAR_ESQ
           
ENTIDADE_HOR_POS_ESQ:
           lh a1, 0(a5) 
           addi a1, a1, -4             # altera NEXT_CHAR_POS 4 PIXELS PARA A ESQUERDA
           sh a1, 0(a5)
           lh a2, 2(a5)                # Carrega a NEXT coordenada Y
           
SEGUE_CHAR_ESQ:           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO_HOR
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           lh t0, 6(a5)                # CHAMA O �NDICE DA ENTIDADE QUE SER�� CALCULADA A COLIS�O, POIS A SAMUS TEM COLIS�O ESPECIAL
           li t1, 1
           beq t0, t1, COL_SAMUS_HOR
           
           j COL_ENTIDADE_HOR
           
           #-------------------------------------------------------------------------------------------------------------------------------------
	  
CHAR_DIR:  li t0, 2
           sh t0, 4(a5)                # muda o valor ESQUERDA/DIREITA do personagem para 2, pois ele est� andando para a DIREITA
           
           lh t0, 6(a5)
           li t1, 1
           beq t0, t1, SAMUS_HOR_POS_DIR
           j ENTIDADE_HOR_POS_DIR

SAMUS_HOR_POS_DIR:
           mv a1, s10
           addi a1, a1, 4
           sh a1, 0(a5)
           lh a2, 2(a5)
           j SEGUE_CHAR_DIR
           
ENTIDADE_HOR_POS_DIR:
           lh a1, 0(a5) 
           addi a1, a1, 4              # altera NEXT_CHAR_POS 4 PIXELS PARA A DIRETIA
           sh a1, 0(a5)
           lh a2, 2(a5)                # Carrega a NEXT coordenada Y
           
SEGUE_CHAR_DIR:           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO_HOR
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
              
           lh t0, 6(a5)                # CHAMA O �NDICE DA ENTIDADE QUE SER�� CALCULADA A COLIS�O, POIS A SAMUS TEM COLIS�O ESPECIAL
           li t1, 1
           beq t0, t1, COL_SAMUS_HOR
           
           j COL_ENTIDADE_HOR
           
           #-------------------------------------------------------------------------------------------------------------------------------------
           
COL_SAMUS_HOR:
           bne s1, zero, BATEU_NUMA_PAREDE  
           
           lh t0, 6(a3)
           beq t0, zero, SAMUS_HUMANA
           
           li t1, 1
           beq t0, t1, SAMUS_BOLA_DIRECAO

SAMUS_BOLA_DIRECAO:
           lh t0, 4(a5)
           beq t0, zero, S10_MENOS_4_BOLA
           j S10_MAIS_4_BOLA
           
S10_MENOS_4_BOLA:
           addi s10, s10, -4
           j SAMUS_RESUL_COL
           
S10_MAIS_4_BOLA:
            addi s10, s10, 4
            j SAMUS_RESUL_COL

SAMUS_HUMANA:
           addi a2, a2, 16             # ADICIONA 16 � POSI��O Y DA SAMUS E CHAMA A COLIS�O DE NOVO, OU SEJA, CALCULA A COLIS�O DA PARTE DE BAIXO
           
           addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	   sw ra, 0(sp)                # Salva ra na pilha
           call CHECK_COLISAO_HOR
           lw ra, 0(sp)                # Restaura ra da pilha
           addi sp, sp, 4              # Ajusta a pilha de volta
           
           bne s1, zero, BATEU_NUMA_PAREDE      # S1 ARMAZENA SE O PERSONAGEM IR� COLIDIR OU N�O, 1 PARA COLIDIR E 0 PARA N�O
           
           lh t0, 4(a5)
           beq t0, zero, S10_MENOS_4
           
           li t1, 2
           beq t0, t1, S10_MAIS_4
           
S10_MAIS_4: addi s10, s10, 4
            j SAMUS_RESUL_COL


S10_MENOS_4:addi s10, s10, -4
            j SAMUS_RESUL_COL

COL_ENTIDADE_HOR:
            bne s1, zero, BATEU_NUMA_PAREDE      # S1 ARMAZENA SE O PERSONAGEM IR� COLIDIR OU N�O, 1 PARA COLIDIR E 0 PARA N�O
            j ENTIDADE_RESUL_COL       
           
           #----------------------------------------------------- 
           
BATEU_NUMA_PAREDE:
           lh t0, 4(a5)                         # LOAD PARA SABER SE O PERSONAGEM ESTAVA INDO PARA A ESQUERDA OU PARA A DIREITA
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

           lh t0, 6(a5)
           li t1, 1
           beq t0, t1, SAMUS_HOR_POS_BAIXO
           j ENTIDADE_HOR_POS_BAIXO

SAMUS_HOR_POS_BAIXO:
           mv a1, s10
           j SEGUE_CHAR_BAIXO
           
ENTIDADE_HOR_POS_BAIXO:
            lh a1, 0(a5)
         
SEGUE_CHAR_BAIXO:           
            lh a2, 2(a5)
            addi a2, a2, 1
            sh a2, 2(a5)

            addi sp, sp, -4            # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)               # Salva ra na pilha
            call CHECK_COLISAO_VER
            lw ra, 0(sp)               # Restaura ra da pilha
            addi sp, sp, 4             # Ajusta a pilha de volta
            
            bne s1, zero, ENTIDADE_COLIDE
            
            addi a1, a1, 15
            
            addi sp, sp, -4            # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)               # Salva ra na pilha
            call CHECK_COLISAO_VER
            lw ra, 0(sp)               # Restaura ra da pilha
            addi sp, sp, 4             # Ajusta a pilha de volta
            
            addi a1, a1, -15
            
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
            lh t0, 6(a5)               # CHAMA O �NDICE DA ENTIDADE
            li t1, 1
            beq t0, t1, SAMUS_RESUL_COL
            j ENTIDADE_RESUL_COL
            
        #------------------------------------------------------------------------------------------------------------------------------------- 
   
CHAR_CIMA:  li t1, 2
            sh t1, 6(a4)                # SALVA 2 NO VALOR DE DESCER/SUBIR
            
            lh t0, 6(a5)
            li t1, 1
            beq t0, t1, SAMUS_HOR_POS_CIMA
            j ENTIDADE_HOR_POS_CIMA

SAMUS_HOR_POS_CIMA:
            mv a1, s10
            j SEGUE_CHAR_CIMA
           
ENTIDADE_HOR_POS_CIMA:
            lh a1, 0(a5)
         
SEGUE_CHAR_CIMA:           
            lh a2, 2(a5)
            addi a2, a2, -2
            sh a2, 2(a5)
            
            addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)                # Salva ra na pilha
            call CHECK_COLISAO_VER
            lw ra, 0(sp)                # Restaura ra da pilha
            addi sp, sp, 4              # Ajusta a pilha de volta
            
            bne s1, zero, BATEU_A_CABECA  
            
            addi a1, a1, 15
            
            addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	    sw ra, 0(sp)                # Salva ra na pilha
            call CHECK_COLISAO_VER
            lw ra, 0(sp)                # Restaura ra da pilha
            addi sp, sp, 4              # Ajusta a pilha de volta
            
            addi a1, a1, -15
            
            bne s1, zero, BATEU_A_CABECA
            j COL_VER_RESUL
            
BATEU_A_CABECA:  
            li s5, 0
            sh zero, 6(a4)
            j CHAR_RET
            
#---------------------------------------OPERA��ES QUE USAM CHAR_CIMA----------------------------------------------------------------------------

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
                 
#----------------------------------------------------------COLIS�O HORIZONTAL E VERTICAL--------------------------------------------------------------------------------------------------
CHECK_COLISAO_VER:
               mv t1, a1                      # Carrega a NEXT coordenada X
               mv t2, a2                      # Carrega a NEXT coordenada Y
               
COLIDE_BAIXO:  lh t0, 6(a4)                   # PEGA O�VALOR QUE INDICA SE O PERSONAGEM EST� INDO PARA BAIXO, PARADO, OU PARA CIMA
               
               beq t0, zero, DESCE            # VERIFICA SE A ENTIDADE EST� ANDANDO PARA A CIMA, NESSE CASO, � NECESS�RIO SOMAR 15 NA POS X PARA CALCULAR A POSI��O
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
               mv t1, a1                      # Carrega a NEXT coordenada X
               mv t2, a2                      # Carrega a NEXT coordenada Y
               
COLIDE_DIR:    li t0, 2
               lh t3, 4(a5)
               
               beq t3, t0, ANDANDO_DIR   # VERIFICA SE A ENTIDADE EST� ANDANDO PARA A DIREITA, NESSE CASO, � NECESS�RIO SOMAR 15 NA POS X PARA CALCULAR A POSI��O
               j COLIDE_NORMAL

ANDANDO_DIR:   addi t1, t1, 15

#-------------------------------------------------------------------------------------------------------
COLIDE_NORMAL: li t6, 16
               #li t5, 60
               lw t5, 0(s11)             # largura do mapa

               div t1, t1, t6
               div t2, t2, t6
               
               mul t2, t2, t5            # AP�S A DIVIS�O, T2 POSSUI A LINHA Y DA MATRIZ MAPA ONDE A PARTE DE BAIXO DA SAMUS (OU UMA ENTIDADE DE TAMANHO 16) EST�
                                      
               add t2, t1, t2            # AP�S MULTIPLICAR POR 20 E SOMAR COM A COMPONENTE X, TEMOS EXATAMENTE O BYTE PARA ONDE SAMUS ANDAR�
               
               addi t4, s11, 4
               add t4, t4, t2            # SOMAMOS S11 A T2 PARA SABER QUAL BYTE DO MAPA �, SE ELE FOR DO TIPO QUE COLIDE (TIJOLO OU METAL) RETORNA 0
               
               lb t3, 0(t4)
               
               li t4, 0
               beq t3, t4, COLIDE
               
               li t4, 1
               beq t3, t4, COLIDE
               
               li t4, 2
               beq t3, t4, PORTA
               
               li t4, 3
               beq t3, t4, CHAVE
               
               li t4, 4
               beq t3, t4, BOLA_POWER_UP
               
               li t4, 5
               beq t3, t4, ARMA_POWER_UP
               
               li s1, 0
               ret
               
COLIDE:        li s1, 1
               ret
               
BOLA_POWER_UP: li s7, 1
               li s1, 0
               ret
               
ARMA_FOGUETE:  li s7, 2
               li s1, 0
               ret
               
CHAVE:         li s8, 1
               li s1, 0
               ret

PORTA:         beq s8, zero, COLIDE      # SE O JOGADOR N�O TIVER A CHAVE, SAMUS N�O PODER� PASSAR PELA PORTA

PORTA_ABRE:    li s1, 0
               li s8, 2
               ret
               
ARMA_POWER_UP: li s7, 2
               li s1, 0
               ret

#-------------------------------------------RESULTADO DA COLIS�O--------------------------------------------------------------------------------------------------------

SAMUS_RESUL_COL:
           lh t0, 6(a3)
	   beq t0, zero, RESUL_HUMANA
	   
RESUL_BOLA:
           bne s5, zero, FRAME_7
           
           lh t0, 6(a4)
           beq t0, zero, FRAME_7         # SE O PERSONAGEM ESTIVER CAINDO, SEU SPRITE N�O PODE MUDAR
           
           lh t0, 4(a4)                  # CARREGA O FRAME ATUAL
           
           li t1, 10
	   beq t0, t1, FRAME_7
	   
	   addi t0, t0, 1
	   sh t0, 4(a4)
	   j ATUALIZA_POS

FRAME_7:   li t0, 7
           sh t0, 4(a4)
           j ATUALIZA_POS

RESUL_HUMANA:           
           bne s5, zero, FRAME_5         # SE O PERSONAGEM ESTIVER SUBINDO, SEU FRAME ATUAL SER� 5 (CAINDO/SUBINDO)
	   
	   lh t0, 6(a4)
	   beq t0, zero, FRAME_5         # SE O PERSONAGEM ESTIVER CAINDO, SEU SPRITE N�O PODE MUDAR
	   
	   lh t0, 4(a4)                  # CARREGA O FRAME ATUAL
           
           li t1, 4
	   beq t0, t1, FRAME_1
	   
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
	   beq t0, t1, ATUALIZA_POS      # SE A ENTIDADE QUE SE MOVEU FOPR UM PROJ�TIL, ELE PULA TODO O PROCESSOD DE ATUALIZAR O FRAME DE ANIMA��O
	   
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
	   beq t0, t1, FRAME_1
	   
	   addi t0, t0, 1
	   sh t0, 4(a4)
	   j ATUALIZA_POS

FRAME_1:
           li t0, 1
           sh t0, 4(a4)
           
           #---------------------------------------------------------------------------------------------------------------------------------------------------
           
ATUALIZA_POS:           
           lw t3, 0(a3)                  # COMO O PERSONAGEM N�O IR� COLIDIR, PODEMOS ATUALIZAR CHAR_POS E OLD_CHAR_POS 
           sw t3, 0(a4)                  # AGORA OLD_CHAR_POS PASSA A SER CHAR_POS
           
           lw t3, 0(a5)                  # COMO O PERSONAGEM N�O IR� COLIDIR, PODEMOS ATUALIZAR CHAR_POS E NEXT_CHAR_POS 
           sw t3, 0(a3)                  # AGORA CHAR_POS PASSA A SER NEXT_CHAR_POS

#---------------------------------------------------APAGA A POSI��O ANTIGA DA ENTIDADE--------------------------------------------
	   
OLD_POS:    lh t0, 6(a3)                 # PEGA O TIPO DA ENTIDADE
               
            beq t0, zero, T32_PIXELS     # SE FOR A SAMUS, APAGA COM O OLD_POS DE 16 X 32
               
            li t1, 1
            beq t0, t1, T16_PIXELS       # SE FOR UM INIMIGO, APAGA COM O OLD_POS DE 16 X 16
               
            li t1, 2
            beq t0, t1, T16_PIXELS
               
            li t1, 3
            beq t0, t1, T4_PIXELS        # SE FOR UM PROJETIL, APAGA COM O OLD_POS DE 4 X 4
       
T32_PIXELS: la a0, old_char_pos          # Apaga a posi��o antiga da SAMUS no frame que vai ser escondido (32 x 16)
            j APAGA

T16_PIXELS: la a0, half_old_char_pos     # Apaga a posi��o antiga de INIMIGOS no frame que vai ser escondido (16 x 16)
            j APAGA
            
T4_PIXELS:  la a0, projetil_old_pos      # Apaga a posi��o antiga de PROJ�TEIS no frame que vai ser escondido (4 x 4)

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

IA_ENTIDADES:  mv a6, s3
               
               j SAMUS_TURN              # SAMUS SEMPRE SER� A PRIMEIRA DA LISTA, ENT�O ELA INICIA O LOOP
          
ENTIDADES_LOOP:beq a6, s4, FINAL_LOOP    # QUANDO CHEGA NO FIM DA LISTA, ENCERRA O LOOP
               addi a6, a6, 24
               
               #li a7, 5
               #ecall
               
               lh t1, 0(s3)               # X e Y Samus
	       lh t2, 2(s3)
              
               lh t3, 4(a6)               # VIDA DA ENTIDADE
	       ble t3, zero, APAGA_INIMIGO # se o inimigo estiver morto, nada acontece
	       
	       lh t3, 6(a6)               # carrega o tipo da entidade
	       
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
# PULA PARA O FIM POIS A SAMUS N�O TEM IA, OU SEJA, DIRETO PARA A FASE DE PRINT
SAMUS_TURN:    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                # Salva ra na pilha
    	       mv a3, s3                   # SALVA EM A3 A POSI��O X, Y DA SAMUS E OS ATRIBUTOS DE ENTIDADES_INFO (VIDA E TIPO)
     	       addi a4, a3, 8              # SALVA EM A4 A POSI��O ANTIGA DA SAMUS E OS ATRIBUTOS DE OLD_ENTIDADES_INFO (FRAME ATUAL E FRAME ANTIGO)
     	       addi a5, a4, 8              # SALVA EM A5 A PR�XIMA POSI��O X DA SAMUS E OS ATRIBUTOS DE NEXT_ENTIDADES_INFO (CIMA/BAIXO E ESQUERDA/DIRETIA)
               call KEY
               lw ra, 0(sp)                # Restaura ra da pilhad
               addi sp, sp, 4              # Ajusta a pilha de volta
           
               beq s5, zero, GRAVIDADE_AFETA_SAMUS
           
               addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                # Salva ra na pilha
    	       mv a3, s3
    	       addi a4, a3, 8
    	       addi a5, a4, 8              # C�DIGO QUE FAZ COM QUE A SAMUS PULE
               call CHAR_SOBE
               lw ra, 0(sp)                # Restaura ra da pilhad
               addi sp, sp, 4              # Ajusta a pilha de volta
           
               j GRAVIDADE_NAO_AFETA_SAMUS

GRAVIDADE_AFETA_SAMUS:
               addi sp, sp, -4             # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                # Salva ra na pilha
    	       mv a3, s3
    	       addi a4, a3, 8
    	       addi a5, a4, 8
               jal ra, CHAR_BAIXO
               lw ra, 0(sp)                # Restaura ra da pilha
               addi sp, sp, 4              # Ajusta a pilha de volta
               
               #---------------------------------------------------------------------
               
GRAVIDADE_NAO_AFETA_SAMUS:               
               la a0, samus_parada         # PEGA O FRAME BASE DA SAMUS
	   
	       lh t1, 12(s3)               # FRAME ATUAL DA SAMUS
	       li t2, 520                  # CADA SPRITE DA SAMUS POSSUI 520 BYTES E EST�O ORGANIZADOS EM ORDEM
	       mul t1, t1, t2              
	   
	       add a0, a0, t1	           # N� SPRITE ATUAL X 520 + SPRITE BASE = ENDERE�O DO SPRITE QUE QUEREMOS IMPRIMIR  
 	       lh a1, 0(s3)                # Imprime a posi��o X do personagem
 	       lh a2, 2(s3)                # Imprime a posi��o Y do personagem
 	       mv a7, s0
 	       
 	       j PRINT_TURN
	       
#--------------------------------------------------------------------------------------------------------------------------------------
# Descreve o comportamento do tipo de inimigo ESCORPI�O
SCORPIO_TURN:  lh a1, 0(a6)                   # salva a posi��o X do Inimigo
	       lh a2, 2(a6)                   # salva a posi��o Y do Inimigo
	   
	       addi t4, t2, 31                # AGORA EM T2 EST� O PRIMEIRO BIT VERTICAL   DA SAMUS E EM T4 O �LTIMO BIT VERTICAL   DA SAMUS
	       
	       slt t6, a2, t4                 # VERIFICA SE PROJ_Y � MENOR QUE O BIT VERTICAL DE BAIXO DA SAMUS
	       slt t5, t2, a2                 # VERIFICA SE O BIT VERTICAL DE CIMA DA SAMUS � MENOR QUE PROJ_Y
	       
	       and t0, t6, t5                 # VERIFICA SE O PROJ�TIL EST� DENTRO DA SAMUS NA VERTICAL
	       
	       beq t0, zero, SCORPIO_ANDA
	       
	       addi t3, t1, 15                # AGORA EM T1 EST� O PRIMEIRO BIT HORIZONTAL DA SAMUS E EM T3 O �LTIMO BIT HORIZONTAL DA SAMUS
	       
	       slt t6, a1, t3                 # VERIFICA SE PROJ_X � MENOR QUE O BIT HORIZONTAL DA DIREITA DA SAMUS
	       slt t5, t1, a1                 # VERIFICA SE O BIT HORIZONTAL DA ESQUERDA DA SAMUS � MENOR QUE PROJ_X
	       
	       and t0, t0, t3                 # VERIFICA SE O PROJ�TIL EST� AO MESMO TEMPO DENTRO DA SAMUS HORIZONTALMENTE
	       
	       beq t0, zero, SCORPIO_ATACK
	       
	       j SCORPIO_ATACK
	     
	       # Fazer um AND entre "est� na mesma cordenada Y" e "Estar dentro do INTERVALO DE ATAQUE do inimigo"
	           
             #-----------------------------------------COMPARA A POSI��OO X DA SAMUS E DO ESCORPI�O--------------------------------------------------------
               
SCORPIO_ATACK: addi t3, a1, -32               # verifica se o personagem est� 3 tiles na frente do inimigo
	       addi t4, a1, 32                # verifica se o personagem est� 2 tiles atr�s do inimigo
	     
	       slt t5, t1, t4                 # T1 TEM que ser menor que T4 para que o inimigo ataque (SAMUS EST� DENTRO DO CAMPO DE VIS�O DA DIREITA DO INIMIGO)
	       slt t6, t3, t1                 # T3 TEM que ser maior que T3 para que o inimigo ataque (SAMUS EST� DENTRO DO CAMPO DE VIS�O DA ESQUERDA DO INIMIGO)
	     
	       #----------------------------TABELA VERDADE DO ESCORPI�O ATACAR------------------------------
	       #
	       #        T5      T6          T2 (ATACAR)  |      T1    T2      ATACAR
	       #        0       0           0            |      0     0         0
	       #        0       1           0            |      0     1         0
	       #        1       0           0            |      1     0         0
	       #        1       1           1            |      1     1         1
	     
	       and t0, t6, t5                 # VERIFICA SE O SAMUS EST� NO RANGE DE ATAQUE DO INIMIGO
	       
	       li t3, 1
	       beq t0, t3, SEGUE_SCORPIO_ATACK
	       
	       j SCORPIO_ANDA
	     
	       #------------------------------------------------------------------------------------------------------------
	       
SEGUE_SCORPIO_ATACK:
               addi a4, a6, 8
               addi a5, a4, 8
               
	       slt t6, t1, a1

               beq t6, zero, MIRAR_DIR
               
MIRAR_ESQ:     li t6, 1                       # VIRA A ENTIDADE PARA A ESQUERDA 
               sh t6, 4(a5)
              
               sh zero, 4(a4)                 # MUDA O SPRITE PARA O SPRITE DE ATACA
               j ATIRA

MIRAR_DIR:     li t6, 3                       # VIRA A ENTIDADE PARA A DIREITA
               sh t6, 4(a5)
               
               sh zero, 4(a4)                 # MUDA O SPRITE PARA O SPRITE DE ATACAR

ATIRA:         addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
               addi a5, a3, 16
               jal ra, ATIRAR
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               la a0, escorpiao_atirando
               lh a1, 0(a6)                   # Imprime na posi��o X do personagem
 	       lh a2, 2(a6)                   # Imprime na posi��o Y do personagem
 	       mv a7, s0
               
               j PRINT_TURN
               
               #---------------------------------------------------------------------
               
SCORPIO_ANDA:  addi a5, a6, 16
               sh t0, 4(a5)                   # VERIFICA SE EST� INDO PARA A ESQUERDA OU DIREITA
               
               beq t0, zero, SCORPIO_ESQ
               
               li t6, 1
               beq t0, t6, SCORPIO_DIR
               
               li t1, 2
               beq t0, t1, SCORPIO_DIR
                              
               li t6, 3
               beq t0, t6, SCORPIO_ESQ
          
               
SCORPIO_DIR:   addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
               addi a4, a3, 8
               addi a5, a4, 8
               jal ra, CHAR_DIR
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
               
               #---------------------------------------------------------------------
               
               la a0, escorpiao_atirando
               
               lh t1, 12(a6)                  # frame atual do Escorpi�o
	       li t2, 264
	       mul t1, t1, t2 
	                      
	       add a0, a0, t1	              # N� SPRITE ATUAL X 264 + SPRITE BASE = ENDERE�O DO SPRITE QUE QUEREMOS IMPRIMIR   
 	       lh a1, 0(a6)                   # Imprime na posi��o X do personagem
 	       lh a2, 2(a6)                   # Imprime na posi��o Y do personagem
 	       mv a7, s0
 	       
 	       j PRINT_TURN
#--------------------------------------------------------------------------------------------------------------------------------------
# Descreve o comportamento do tipo de inimigo VOADOR
VOADOR_TURN:   
	        
	       j FIM_DO_TURNO

VOADOR_ATACK:

VOADOR_VOA:
#--------------------------------------------------------------------------------------------------------------------------------------
# DESCREVE O COMPORTAMENTO DE UM PROJ�TIL
PROJETIL_TURN: lh a1, 0(a6)                   # salva a posi��o X do Proj�til
	       lh a2, 2(a6)                   # salva a posi��o Y do Proj�til
	       addi a4, a6, 8
	       mv a7, s3
	       
	       addi t0, a1, 4
	       li t3, 320
	       rem t4, t0, t3
	       beq t4, zero, PROJETIL_MORRE

               lh t0, 4(a4)
               li t3, 1
               beq t0, t3, PROJETIL_SAMUS_TURN
               
               li t3, 2
               beq t0, t3, PROJETIL_INIMIGO_TURN

PROJETIL_SAMUS_TURN:
               addi a7, a7, 24
               beq a7, s4, PROJETIL_ANDA
               
               lh t1, 0(a7)
               lh t2, 2(a7)                  # Y INIMIGO
               #lh t3, 6(a7) DANO PARA O PINWHEEL
               
               addi t5, t2, 15
               
               slt t0, a2, t5                 
	       slt t3, t2, a2   
	       
	       and t0, t3, t0
	       
	       beq t0, zero, PROJETIL_SAMUS_TURN
	       
	       addi t5, t1, 15   
	       
	       slt t0, a1, t5                 
	       slt t3, t1, a1       
	       
	       and t0, t3, t0
	       
	       beq t0, zero, PROJETIL_SAMUS_TURN
	       
	       lh t0, 4(a6)                 # SE O C�DIGO CHEGAR AT� AQUI � PQ O PROJ�TIL ACERTOU ALGU�M, ENT�O PRECISAMOS SABER QUANTO DE DANO ELE D�
	       lh t1, 4(a7)                 # VIDA ATUAL DO INIMIGO QUE FOI ATINGIDO
	       
	       sub t1, t1, t0
	       sh t1, 4(a7)                 # DIMINUI DA VIDA DO INIMIGO A QUANTIDADE DE DANO QUE O PROJ�TIL D�
	       
	       j PROJETIL_MORRE
                                             
PROJETIL_INIMIGO_TURN:      
 	       #li a7, 5
	       #ecall
	       
	       lh t1, 0(s3)
               lh t2, 2(s3)

	       addi t4, t2, 31                # AGORA EM T2 EST� O PRIMEIRO BIT VERTICAL   DA SAMUS E EM T4 O �LTIMO BIT VERTICAL   DA SAMUS
	       
	       slt t6, a2, t4                 # VERIFICA SE PROJ_Y � MENOR QUE O BIT VERTICAL DE BAIXO DA SAMUS
	       slt t5, t2, a2                 # VERIFICA SE O BIT VERTICAL DE CIMA DA SAMUS � MENOR QUE PROJ_Y
	       
	       and t0, t6, t5                 # VERIFICA SE O PROJ�TIL EST� DENTRO DA SAMUS NA VERTICAL
	       
	       beq t0, zero, PROJETIL_ANDA
	       
	       addi t3, t1, 15                # AGORA EM T1 EST� O PRIMEIRO BIT HORIZONTAL DA SAMUS E EM T3 O �LTIMO BIT HORIZONTAL DA SAMUS
	       
	       slt t6, a1, t3                 # VERIFICA SE PROJ_X � MENOR QUE O BIT HORIZONTAL DA DIREITA DA SAMUS
	       slt t5, t1, a1                 # VERIFICA SE O BIT HORIZONTAL DA ESQUERDA DA SAMUS � MENOR QUE PROJ_X
	       
	       and t0, t6, a5                 # VERIFICA SE O PROJ�TIL EST� DENTRO DA SAMUS NA HORIZONTAL
	       
	       beq t0, zero, PROJETIL_ANDA
	       j SAMUS_DANO                   # PULA PARA A SAMUS TOMANDO O DANO PULA PARA A SAMUS TOMANDO O DANO

PROJETIL_ANDA: addi a5, a6, 16
               lh t1, 4(a5)                   # VERIFICA SE O PROJ�TIL EST� INDO PARA A ESQUERDA OU PARA A DIREITA
               beq t1, zero, PROJETIL_ESQ
               j PROJETIL_DIR

PROJETIL_DIR:  addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
    	       addi a4, a3, 8
    	       addi a5, a4, 8
               jal ra, CHAR_DIR            
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               bne s1, zero, PROJETIL_MORRE
               
               j ESCOLHE_FRAME_PROJETIL
               
PROJETIL_ESQ:  addi sp, sp, -4               # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                  # Salva ra na pilha
    	       mv a3, a6
    	       addi a4, a3, 8
    	       addi a5, a4, 8
               jal ra, CHAR_ESQ            
               lw ra, 0(sp)                  # Restaura ra da pilha
               addi sp, sp, 4                # Ajusta a pilha de volta
              
               bne s1, zero, PROJETIL_MORRE
               
               
ESCOLHE_FRAME_PROJETIL:   
               lh t0, 4(a6)
               li t1, 3
               beq t0, t1, TIRO_FORTE
               j TIRO_NORMAL
               
TIRO_FORTE:    la a0, projetil_forte
               j PRINTA_TIRO

TIRO_NORMAL:   la a0, projetil

PRINTA_TIRO:   lh a1, 0(a6)                   # Imprime a posi��o X do personagem
 	       lh a2, 2(a6)                   # Imprime a posi��o Y do personagem
 	       mv a7, s0
               j PRINT_TURN
               
PROJETIL_MORRE:
              sh zero, 4(a6)
              
              addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	      sw ra, 0(sp)                   # Salva ra na pilha
    	      mv a3, a6
              mv a4, a6
              call OLD_POS
              lw ra, 0(sp)                   # Restaura ra da pilha
              addi sp, sp, 4                 # Ajusta a pilha de volta
              
              j FIM_DO_TURNO
              
#-------------------------------------------------------------------------------------------------------------------------------------
# FASE FINAL DO TURNO DE CADA ENTIDADE, ONDE � PRINTADA A SUA POSI��O

PRINT_TURN:    #addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       #sw ra, 0(sp)                   # Salva ra na pilha
    	       #mv a3, a6
               #addi a4, a3, 8
               #call OLD_POS
               #lw ra, 0(sp)                   # Restaura ra da pilha
               #addi sp, sp, 4                 # Ajusta a pilha de volta
               
               #li a7, 5
               #ecall
               
               addi a5, a6, 16
               lh t0, 4(a5)                   # VALOR QUE INDICa PARA QUAL DIRE��O O PERSONAGEM EST� INDO     
               beq t0, zero, PRINT_ESQ
               j PRINT_DIR
               
PRINT_ESQ:     addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
               call PRINT
               # A FUN��O PRINT_ESQ AINDA N�O EXISTE, ENT�O ESTOU CHAMANDO A FUN��O DE IMPRIMIR NORMAL
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
               
               j FIM_DO_TURNO

               
PRINT_DIR:     addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
               call PRINT
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta

               j FIM_DO_TURNO

#-------------------------------------------------------------------------------------------------------------------------------------
APAGA_INIMIGO: addi sp, sp, -4                # Ajusta a pilha para salvar ra
    	       sw ra, 0(sp)                   # Salva ra na pilha
    	       mv a3, a6
               mv a4, a6
               call OLD_POS
               lw ra, 0(sp)                   # Restaura ra da pilha
               addi sp, sp, 4                 # Ajusta a pilha de volta
              
               j FIM_DO_TURNO

SAMUS_DANO:    lh t0, 4(s3)
               addi t0, t0, -1                # DIMINUI UM DA VIDA DA SAMUS
               sh t0, 4(s3)
               
               li s7, 0                       # QUANDO A SAMUS LEVA DANO, ELA PERDE QUALQUER ITEM QUE ELA ESTIVER PERGUNTANDO
               
               j FIM_DO_TURNO

FIM_DO_TURNO:  j ENTIDADES_LOOP

FINAL_LOOP:    ret
		    
#---------------------------------------------------------------LINKED LIST--------------------------------------------------------------------------
ADD_ITEM:
    # SE O �NDICE DO ITEM FOR 25, SIGNIFICA QUE A LISTA EST� CHEIA
    
    addi t6, s4, -24       # CALCULA O ENDERE�O DO �LTIMO ITEM
    lh t5, 22(t6)          # CARREGA O �NDICE DO ELEMENTO ANTERIOR
    
    li t4, 24
    beq t5, t4, LISTA_CHEIA
    
    mv t0, s4
    addi t5, t5, 1
    addi s4, s4, 24
    j ADD_ENTIDADE         

ADD_ENTIDADE:
    # Carregar endere�o atual para adicionar na lista `entidades_info`
    sh a1, 0(t0)           # Salvar posi��o x
    sh a2, 2(t0)           # Salvar posi��o y
    sh a3, 4(t0)           # Salva a vida da Entidade
    sh a4, 6(t0)           # Salva o tipo da Entidade
    
    sh a1, 8(t0)           # Salvar old_posi��o_x
    sh a2, 10(t0)          # Salvar old_posi��o_y
    
    sh a7, 12(t0)          # salva o frame atual OU O �NDICE DE QUEM ATIROU PARA PROJ�TEIS
    
    li t1, 1
    sh t1, 14(t0)          # salva BAIXO/PARADO/CIMA
    
    sh a1, 16(t0)          # Salvar next_posi��o_x
    sh a2, 18(t0)          # Salvar next_posi��o_y
    sh a5, 20(t0)          # Salva esquerda/direita
    sh t5, 22(t0)          # Salva o �ndice
    
    ret

SOBRESCREVE_ITEM:
   mv t0, t6
   j ADD_ENTIDADE

LISTA_CHEIA:
    mv t6, s3
    addi t6, t6, 24
    j GARBAGE_COLLECTOR

GARBAGE_COLLECTOR:
   beq t6, s4, SEM_ESPACOS_LIVRES
   
   lh t3, 4(t6)
   ble t3, zero,  SOBRESCREVE_ITEM
   
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

PRINT_VIDA_E_ITENS: 
    li t0, 1
    beq s7, t0, PRINT_BOLA
    
    li t0, 2
    beq s7, t0, PRINT_ARMA
    
    j PRINT_VIDA
    
PRINT_BOLA: 
    la a0, ITEM_BOLA
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    li a1, 0
    li a2, 0
    li t1, 0
    li t2, 0
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    j PRINT_VIDA

PRINT_ARMA:
    la a0, ARMA
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    li a1, 0
    li a2, 0
    li t1, 0
    li t2, 0
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
PRINT_VIDA: 
    #li a7, 5
    #ecall

    li a1, 0
    lh t0, 4(s3)
    
    li t1, 10
    div s1, t0, t1
    li a6, 0

VIDA_LOOP:
    la a0, CORACAO
    
    #li a7, 5
    #ecall
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    addi a1, a1, 16
    li a2, 0
    li t1, 0
    li t2, 0
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    #li a7, 5
    #ecall
    
    addi a6, a6, 1
    beq a6, s1, SAIDA_LOOP
    j VIDA_LOOP
   
SAIDA_LOOP: 
    ret

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
    # Calcular a posi��o x e y com base nos �ndices de linha e coluna
    li t6, 16
    mul a1, s2, t6              # X = coluna DO MAPA * 16
    mul a2, s1, t6              # Y = linha DO MAPA * 16
    
    la a0, TIJOLOS
    lb t2, 0(s9)               # Carrega o byte atual do mapa 
    
    li t6, 7
    beq t2, t6, ADD_VOADOR
    
    li t6, 8
    beq t2, t6, ADD_ESCORPIAO
    
    li t6, 9
    beq t2, t6, print_fundo
    
    li t6, 264                  # CADA TILE DO MAPA TEM 256 BYTES (16 X 16 PIXELS, CADA PIXEL TEM 1 BYTE)
    mul t2, t2, t6
    add a0, a0, t2              # O ENDERE�O DO TILE METAL EST� 256 BYTES DEPOIS DE TIJOLOS, ENT�O SE T2 = 1 => TIJOLOS + (1 x 256) = METAL
    
    addi sp, sp, -4             # Ajusta a pilha para salvar ra
    sw ra, 0(sp)                # Salva ra na pilha   
    call PRINT_TILE
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
    
    j NEXT_PIXEL
    
print_fundo:
    la a0, FUNDO_PRETO
    
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
    li a3, 3                    # VIDA DA ENTIDADE
    li a4, 2                    # TIPO DA ENTIDADE
    li a5, 2                    # ESQ/DIR
    li a7, 0                    # FRAME
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
    li a3, 6                    # VIDA DA ENTIDADE
    li a4, 1                    # TIPO DA ENTIDADE
    li a5, 0                    # ESQ/DIR
    li a7, 0                    # FRAME
    call ADD_ITEM
    lw ra, 0(sp)                # Restaura ra da pilha
    addi sp, sp, 4              # Ajusta a pilha de volta
	   
    j NEXT_PIXEL
    
NEXT_PIXEL:
    # Avan�a para o pr�ximo pixel da linha (pr�xima coluna)
    addi s9, s9, 1      # Avan�a para o pr�ximo byte do mapa
    addi s2, s2, 1      # Pr�xima coluna
    
    li t3, 20           # Total de colunas
    blt s2, t3, PRINT_MAP
    
    #lw t0, 0(s11)
    #addi t0, t0, -20
    #add s9, s9, t0
    
    lw t0, 0(s11)
    addi t0, t0, -20
    add s9, s9, t0
    
    mv s2, zero

    # Pr�xima linha
    addi s1, s1, 1
        
    li t3, 15         # Total de linhas (excluindo a primeira)
    blt s1, t3, PRINT_MAP
    ret
.data
#--------------------------------------------------LISTAS------------------------------------------------------------------------

ENTIDADES_INFO: .half 16, 32, 100, 0,              # X = 32, Y = 32, Vida = 10, Tipo da entidade = 0       (CHAR_POS, VIDA, TIPO)
                      16, 32, 0, 1,               # X = 32, Y = 32, Frame atual = 0, BAIXO (0) /PARADO (1) / CIMA (2) = 1    (OLD_CHAR_POS, FRAMES_ANIMA��O)
                      16, 32, 3, 1                # X = 32, Y = 32, ESQ (0)/ PARADO (1) /DIR (2) = 1, �NDICE                   (NEXT_CHAR_POS, ESQ/DIR, �NDICE)
                      
		.space 576                        # Cada entidade tem 24 bytes, quero que a lista tenha 25 entidades
		
		
		#PARA PROJ�TEIS:   X, Y, DANO, TIPO DE ENTIDADE
		                #  X, Y, QUEM ATIROU O PROJ�TIL, CIMA/BAIXO
		                #  X, Y, FRENTE/TR�S, �NDICE

#--------------------------------------------------TILES------------------------------------------------------------------------

TIJOLOS: .word 16, 16
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

METAL: .word 16, 16
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
             
PORTA_VERMELHA: .word 16, 16
		.byte 0,0,0,0,0,7,7,255,7,7,7,7,7,255,7,7,
		0,0,0,0,0,7,7,255,7,7,7,7,7,255,7,7,
		0,0,0,0,0,7,7,255,7,7,7,7,7,255,7,7,
		0,0,0,0,0,7,7,255,7,7,7,7,6,255,6,6,
		0,0,0,0,0,7,7,255,7,7,6,6,6,255,6,6,
		0,0,0,0,0,7,7,255,7,6,6,6,6,255,6,6,
		0,0,0,0,0,7,7,255,6,91,91,91,6,255,6,6,
		0,0,0,0,0,7,7,255,6,91,91,91,6,255,6,6,
		0,0,0,0,0,7,7,255,6,91,91,91,6,255,6,6,
		0,0,0,0,0,7,7,255,6,91,91,91,6,255,6,6,
		0,0,0,0,0,7,7,255,6,6,6,6,6,255,6,6,
		0,0,0,0,0,7,7,255,6,6,6,6,6,255,6,6,
		0,0,0,0,0,7,7,255,6,6,6,6,6,255,6,6,
		0,0,0,0,0,7,7,255,6,6,6,6,6,255,6,6,
		0,0,0,0,0,7,7,255,6,6,6,6,6,255,6,6,
		0,0,0,0,0,7,7,255,7,6,6,6,6,255,6,6,

CHAVE_VERMELHA: .word 16, 16
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,7,7,7,7,7,7,7,7,7,7,7,7,0,0,
		0,0,7,0,0,0,0,0,0,0,0,0,0,7,0,0,
		0,0,7,0,255,0,255,0,255,0,0,0,0,7,0,0,
		0,0,7,0,255,0,255,0,255,0,0,91,91,7,0,0,
		0,0,7,0,255,0,255,0,255,0,0,91,91,7,0,0,
		0,0,7,7,7,7,7,7,7,7,7,7,7,7,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,

ITEM_BOLA:      .word 16, 16
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,145,145,0,0,0,0,0,0,0,
		0,0,0,0,0,145,145,240,63,145,145,0,0,0,0,0,
		0,0,0,0,145,240,240,240,63,63,63,145,0,0,0,0,
		0,0,0,145,240,240,240,240,63,63,63,63,145,0,0,0,
		0,0,0,145,240,240,240,63,63,63,63,240,145,0,0,0,
		0,0,0,145,240,240,63,63,63,63,240,240,145,0,0,0,
		0,0,0,145,240,63,63,63,63,240,240,240,145,0,0,0,
		0,0,0,145,63,63,63,63,240,240,240,240,145,0,0,0,
		0,0,0,0,145,63,63,63,240,240,240,145,0,0,0,0,
		0,0,0,0,0,145,145,63,240,145,145,0,0,0,0,0,
		0,0,0,0,0,0,0,145,145,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		
ARMA: 		.word 16, 16
		.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,22,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,22,0,0,0,0,0,0,0,0,164,0,
		0,0,0,73,22,22,22,22,22,22,22,22,22,164,164,0,
		0,0,73,73,22,22,22,22,22,22,22,22,22,164,164,0,
		0,73,73,73,22,22,22,22,22,22,22,22,22,164,164,0,
		73,73,73,73,22,22,22,22,22,22,22,22,22,164,164,0,
		73,73,73,73,0,0,0,73,0,0,0,0,0,0,164,0,
		73,73,73,73,0,0,73,0,0,0,0,0,0,0,0,0,
		73,73,73,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,



FUNDO_PRETO: 	.word 16, 16
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
             
CORACAO: 	.word 16, 16
		.byte 173,173,173,173,0,0,173,173,173,173,173,0,173,173,173,173,
		173,173,173,173,173,0,173,173,173,173,173,0,173,173,173,173,
		173,173,63,63,63,63,63,173,173,63,63,63,63,63,173,173,
		0,0,63,63,63,63,63,63,63,63,63,63,63,63,0,0,
		173,63,63,63,63,63,63,63,63,63,63,63,63,63,63,173,
		173,63,63,63,63,63,63,63,63,63,63,63,63,63,63,173,
		173,63,63,63,63,63,63,63,63,63,63,63,63,63,63,173,
		0,63,63,63,63,63,63,63,63,63,63,63,63,63,63,0,
		173,173,63,63,63,63,63,63,63,63,63,63,63,63,173,173,
		173,173,0,63,63,63,63,63,63,63,63,63,63,173,173,173,
		173,0,0,173,63,63,63,63,63,63,63,63,0,173,173,173,
		0,0,0,0,0,63,63,63,63,63,63,0,0,0,0,0,
		0,173,173,0,173,173,63,63,63,63,173,173,173,173,173,173,
		173,173,173,0,0,173,173,63,63,0,173,173,173,173,173,173,
		173,173,173,0,0,173,173,173,173,0,173,173,173,173,173,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,



# PR�XIMO TILE,  QUE SER� IDENTIFICADO COMO 2

# PR�XIMO TILE, QUE SER� IDENTIFICADO COMO 3

# ETC...

# 7 � PARA VOADOR, N�O PODE SER TILE
# 8 � PARA ESCORPI�O, N�O PODE SER TILE
# 9 � VAZIO, N�O PODE SER TILE 

#--------------------------------------------------MAPAS------------------------------------------------------------------------

mapa_1: .word 60,
        .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,9,0,9,0,9,0,9,0,9,0,9,0,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	      0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,9,8,9,9,1,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,0,0,0,0,0,0,0,0,9,9,9,0,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,0,9,9,9,9,9,9,0,1,9,9,0,9,9,9,9,9,9,0,9,9,1,1,1,1,0,0,0,0,9,9,9,9,9,9,9,9,9,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,9,0,9,9,9,0,5,9,9,9,9,9,2,9,9,9,9,9,9,1,0,0,0,0,9,9,9,9,9,9,9,4,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,9,9,3,0,9,9,9,0,1,0,9,9,9,9,2,9,9,9,9,9,9,9,1,0,0,0,0,9,9,9,9,9,9,1,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,9,0,0,1,9,9,9,1,0,9,9,9,9,9,0,0,0,9,9,9,9,9,9,9,1,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,0,0,9,9,9,9,9,9,0,9,9,9,9,0,0,0,1,0,9,9,9,9,9,9,9,1,1,1,1,1,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,0,0,9,9,9,9,9,9,9,0,9,9,9,0,0,0,0,0,1,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,9,9,9,0,9,9,9,9,1,9,9,9,9,9,0,0,0,0,0,0,0,1,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,1,9,9,9,9,9,9,1,1,9,9,9,9,1,0,0,0,0,0,0,0,0,1,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,
              0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
              
mapa_2: .word 80,
        .byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,9,9,9,9,9,9,9,0,0,0,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,0,9,9,9,9,9,9,9,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,0,9,9,9,9,9,9,9,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,0,9,9,9,9,9,9,9,0,0,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,0,9,9,9,9,9,9,9,0,0,9,9,9,9,9,9,9,9,9,9,9,0,0,9,9,9,9,9,9,9,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,0,9,0,9,9,9,9,9,9,9,0,0,9,9,9,9,9,9,9,9,9,9,9,0,0,0,0,0,0,0,0,0,0,0,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,0,0,
	      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

#-------------------------------------------------SPRITES SAMUS-----------------------------------------------------------------

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
		
samus_andando_3:.word 16, 32  # NA VERDADE � O FRAME 1 REPETIDO
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
		
		#-----------------------------------------------------------------------------------------------

samus_bola_1: .word 16, 16
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,24,24,24,24,0,0,0,0,0,0,0,
0,0,0,24,24,24,91,91,91,91,91,0,0,0,0,0,
0,0,24,24,24,24,91,91,91,91,91,91,0,0,0,0,
0,24,24,24,24,24,24,91,91,91,91,91,91,0,0,0,
24,24,24,24,47,47,24,24,91,91,114,91,91,91,0,0,
24,24,24,24,47,24,24,24,24,91,114,114,91,91,0,0,
24,24,24,24,24,24,24,24,24,24,91,114,91,91,0,0,
24,24,24,24,24,47,47,24,24,24,24,91,91,91,0,0,
24,24,24,24,24,24,47,47,24,24,24,24,24,24,0,0,
24,24,24,24,24,24,24,24,24,24,47,24,24,24,0,0,
0,24,24,24,24,91,24,24,24,24,24,24,24,0,0,0,
0,0,24,24,91,114,91,24,24,24,24,24,0,0,0,0,
0,0,0,24,91,91,114,91,91,91,24,0,0,0,0,0,
0,0,0,0,0,91,91,91,91,0,0,0,0,0,0,0
.space 256

samus_bola_2: .word 16, 16
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,24,24,24,24,24,24,0,0,0,0,0,0,
0,0,0,24,24,24,24,24,24,24,24,0,0,0,0,0,
0,0,24,24,24,24,24,24,24,24,24,24,0,0,0,0,
0,24,24,24,24,24,24,24,24,24,24,24,24,0,0,0,
0,91,91,24,24,24,24,24,47,47,24,24,24,0,0,0,
91,91,114,91,24,24,47,24,24,47,24,24,24,24,0,0,
91,114,91,24,24,47,47,24,24,24,24,91,91,24,0,0,
91,91,24,24,24,47,24,24,24,24,91,91,91,24,0,0,
91,91,24,24,24,24,24,24,24,91,91,91,91,24,0,0,
0,91,24,24,24,24,24,24,91,91,91,91,91,0,0,0,
0,24,24,24,47,24,24,91,114,114,91,91,91,0,0,0,
0,0,24,24,24,24,91,114,114,91,91,91,0,0,0,0,
0,0,0,24,24,24,91,91,91,91,91,0,0,0,0,0,
0,0,0,0,24,24,91,91,91,91,0,0,0,0,0,0
.space 256

samus_bola_3: .word 16, 16
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,91,91,91,91,0,0,0,0,0,0,0,
0,0,0,24,91,91,91,114,91,91,24,0,0,0,0,0,
0,0,24,24,24,24,24,91,114,91,24,24,0,0,0,0,
0,24,24,24,24,24,24,24,91,24,24,24,24,0,0,0,
24,24,24,47,24,24,24,24,24,24,24,24,24,24,0,0,
24,24,24,24,24,24,47,47,24,24,24,24,24,24,0,0,
91,91,91,24,24,24,24,47,47,24,24,24,24,24,0,0,
91,91,114,91,24,24,24,24,24,24,24,24,24,24,0,0,
91,91,114,114,91,24,24,24,24,47,24,24,24,24,0,0,
91,91,91,114,91,91,24,24,47,47,24,24,24,24,0,0,
0,91,91,91,91,91,91,24,24,24,24,24,24,0,0,0,
0,0,91,91,91,91,91,91,24,24,24,24,0,0,0,0,
0,0,0,91,91,91,91,91,24,24,24,0,0,0,0,0,
0,0,0,0,0,24,24,24,24,0,0,0,0,0,0,0
.space 256

samus_bola_4: .word 16, 16
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,91,91,91,91,24,24,0,0,0,0,0,0,
0,0,0,91,91,91,91,91,24,24,24,0,0,0,0,0,
0,0,91,91,91,114,114,91,24,24,24,24,0,0,0,0,
0,91,91,91,114,114,91,24,24,47,24,24,24,0,0,0,
0,91,91,91,91,91,24,24,24,24,24,24,91,0,0,0,
24,91,91,91,91,24,24,24,24,24,24,24,91,91,0,0,
24,91,91,91,24,24,24,24,47,24,24,24,91,91,0,0,
24,91,91,24,24,24,24,47,47,24,24,91,114,91,0,0,
24,24,24,24,47,24,24,47,24,24,91,114,91,91,0,0,
0,24,24,24,47,47,24,24,24,24,24,91,91,0,0,0,
0,24,24,24,24,24,24,24,24,24,24,24,24,0,0,0,
0,0,24,24,24,24,24,24,24,24,24,24,0,0,0,0,
0,0,0,24,24,24,24,24,24,24,24,0,0,0,0,0,
0,0,0,0,24,24,24,24,24,24,0,0,0,0,0,0
.space 256

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
		     .byte 0,0,82,2,7,0,0,0,0,0,0,0,0,0,0,0,
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
		     .byte 0,0,82,7,0,0,0,0,0,0,0,0,0,0,0,7,
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
		           0,82,7,7,7,0,7,0,0,0,0,0,0,0,0,7,
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
			   82,39,7,7,7,7,0,0,0,0,0,0,0,0,0,7,
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
			   82,39,28,7,7,0,0,0,0,0,0,0,0,0,0,7,
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
			   39,28,82,0,0,0,0,0,0,0,0,0,0,0,0,7,
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
		
projetil_forte: .word 4, 4
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
