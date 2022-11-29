; ====================== CONSTANTES
elementos       EQU     80            ;dimensão (número de posições) do vector
alturaM         EQU     4     ;altura máxima que os cactos podem assumir
iniciar         EQU     0
maxjump         EQU     8    ;altura de cada salto

; Endereços de E/S
TERM_READ       EQU     FFFFh
TERM_WRITE      EQU     FFFEh
TERM_CURSOR     EQU     FFFCh

;Display de 7 segmentos
DISP7_D0        EQU     FFF0h
DISP7_D1        EQU     FFF1h
DISP7_D2        EQU     FFF2h
DISP7_D3        EQU     FFF3h
DISP7_D4        EQU     FFEEh
DISP7_D5        EQU     FFEFh

;Stack
STACKBASE       EQU     7000h

;TEMPORIZADOR
TIMER_CONTROL   EQU     FFF7h
TIMER_COUNTER   EQU     FFF6h
TIMER_SETSTART  EQU     1
TIMER_SETSOP    EQU     0
TIMERCOUNT_INIT EQU     1 ;100ms
TIMERCOUNT_MET  EQU     5

; INTERRUPÇÕES
INT_MASK        EQU     FFFAh
INT_MASK_VALUE  EQU     8009h

;======================= Variáveis
                ORIG    0000h
                
TIME            WORD    0
TIMER_TICK      WORD    0
VERIFICA_ZERO   WORD    0
VERIFICA_UP     WORD    0
dinoHeight      WORD    0
dinoupdown      WORD    0



;======================= MAIN

                ORIG            4000h
                
tabela          TAB     elementos
X               WORD    5

                
                
                ORIG    0000h
MAIN:           MVI     R6, STACKBASE
                
                ;Configurar o temporizador
                ;mask
                
                MVI     R1, INT_MASK
                MVI     R2, INT_MASK_VALUE
                
                STOR    M[R1], R2
                ENI

                ; START TIMER
                MVI     R2,TIMERCOUNT_INIT
                MVI     R1,TIMER_COUNTER
                STOR    M[R1],R2          ; set timer to count 100ms
                MVI     R1,TIMER_TICK
                STOR    M[R1],R0          ; clear all timer ticks
                MVI     R1,TIMER_CONTROL
                MVI     R2,TIMER_SETSTART
                STOR    M[R1],R2          ; start timer
                
loop:           
                MVI     R1, TIMER_TICK
                LOAD    R2, M[R1]
                CMP     R2, R0
                BR.Z    loop
                DSI      ; critical region: if an interruption occurs, value might become wrong
                DEC     R2
                STOR    M[R1], R2
                MVI     R1, TIME
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                ENI

                MVI     R1,VERIFICA_ZERO
                LOAD    R2,M[R1]
                CMP     R2,R0                ;LOOP ate o utilizador carregar no botao 0
                BR.NZ   start_game
                MVI     R1,TIME
                STOR    M[R1],R0
                
                BR      loop
                
start_game:     ;Start timer         
                MVI     R1, TIMER_COUNTER  
                MVI     R2, TIMERCOUNT_INIT
                STOR    M[R1], R2 ; Definir o tempo para 100ms
                
                MVI     R1, TIMER_CONTROL
                MVI     R2, TIMER_SETSTART 
                STOR    M[R1], R2

                MVI     R1, TIME
                LOAD    R2, M[R1]
                
                ;MOSTRAR TEMPO NO DISPLAY DE 7 SEGM 0
                MVI     R3, Fh
                AND     R3, R2, R3
                MVI     R1, DISP7_D0
                MVI     R4,10
                CMP     R3,R4
                BR.NN   algarismo1
                STOR    M[R1], R3
                BR      display1
                
algarismo1:     SUB     R3,R3,R4
                STOR    M[R1], R3
                
                
display1:               ; MOSTRAR TEMPO NO DISPLAY DE 7 SEGM 1
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3, Fh
                AND     R3, R2, R3
                MVI     R1, DISP7_D1
                MVI     R4,10
                CMP     R3,R4
                BR.NN   algarismo2
                STOR    M[R1], R3
                BR      display2
                
algarismo2:     SUB     R3,R3,R4
                STOR    M[R1], R3
                MVI     R3,0010h
                ADD     R2,R2,R3
                
display2:       ; MOSTRAR TEMPO NO DISPLAY DE 7 SEGM 2
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3, Fh
                AND     R3, R2, R3
                MVI     R1, DISP7_D2
                MVI     R4,10
                CMP     R3,R4
                BR.NN   algarismo3
                STOR    M[R1], R3
                BR      display3
                
algarismo3:     SUB     R3,R3,R4
                STOR    M[R1], R3
                MVI     R3,0010h
                ADD     R2,R2,R3
                
display3:       ; MOSTRAR TEMPO NO DISPLAY DE 7 SEGM 3
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3, Fh
                AND     R3, R2, R3
                MVI     R1, DISP7_D3
                MVI     R4,10
                CMP     R3,R4
                BR.NN   algarismo4
                STOR    M[R1], R3
                BR      display4
                
algarismo4:     SUB     R3,R3,R4
                STOR    M[R1], R3
                MVI     R3,0010h
                ADD     R2,R2,R3
                

             
                
display4:       ; MOSTRAR TEMPO NO DISPLAY DE 7 SEGM 4
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3, Fh
                AND     R3, R2, R3
                MVI     R1, DISP7_D4
                MVI     R4,10
                CMP     R3,R4
                BR.NN   algarismo5
                STOR    M[R1], R3
                BR      display5
                
algarismo5:     SUB     R3,R3,R4
                STOR    M[R1], R3
                MVI     R3,0010h
                ADD     R2,R2,R3
                
display5:       ; MOSTRAR TEMPO NO DISPLAY DE 7 SEGM 5
                SHR     R2
                SHR     R2
                SHR     R2
                SHR     R2
                MVI     R3, Fh
                AND     R3, R2, R3
                MVI     R1, DISP7_D5
                STOR    M[R1], R3   

                MVI     R1, TERM_CURSOR
                MVI     R2, FFFFh    ;Limpar terminal 
                STOR    M[R1], R2
                

    
        ;desenhar o TERRENO DE JOGO:
chao0:          MVI 	R1, TERM_WRITE
                MVI 	R2, TERM_CURSOR
                MVI     R4,aa00h
                MVI     R5,79
                STOR    M[R2],R4
                
LOOP0:          MVI     R4,'-'
                STOR    M[R1],R4
                CMP     R5,R0
                BR.Z    chao1
                DEC     R5
                BR      LOOP0
                
chao1:          MVI     R4,ab00h
                MVI     R5,79
                STOR    M[R2],R4
                
LOOP1:          MVI     R4,'*'
                STOR    M[R1],R4
                CMP     R5,R0
                BR.Z    chao2
                DEC     R5
                BR      LOOP1
                
chao2:          MVI     R4,ac00h
                MVI     R5,79
                STOR    M[R2],R4
                
LOOP2:          MVI     R4,'-'
                STOR    M[R1],R4
                CMP     R5,R0
                BR.Z    dino
                DEC     R5
                BR      LOOP2
                

dino:           DEC     R6
                STOR    M[R6],R4
                DEC     R6 
                STOR    M[R6],R5
                DEC     R6        ;PUSH
                STOR    M[R6],R1
                DEC     R6
                STOR    M[R6],R2
                DEC     R6
                STOR    M[R6],R3
                

                MVI     R1,dinoHeight
                LOAD    R2,M[R1]
                
                MVI     R4,a9h
                MVI     R5,100h
                SUB     R4,R4,R2
                SHL     R4
                SHL     R4 
                SHL     R4
                SHL     R4         ;Meter o a9h nos bits mais significativos
                SHL     R4 
                SHL     R4
                SHL     R4
                SHL     R4
                
                MVI     R3,9h     ;Bits menos significativos               
                ADD     R4,R4,R3 ;a900h+0009h=a909h        
                
                ;Construção do dinossauro:
                MVI     R2,TERM_CURSOR      
                MVI     R1, TERM_WRITE      
                STOR    M[R2],R4
                MVI     R3,')'
                STOR    M[R1],R3   
                SUB     R4,R4,R5 ;linha acima
                
                STOR    M[R2],R4
                MVI     R3,'|'                                 
                STOR    M[R1],R3
                SUB     R4,R4,R5
                
                STOR    M[R2],R4
                MVI     R3,'|'
                STOR    M[R1],R3
                SUB     R4,R4,R5
                
                STOR    M[R2],R4
                MVI     R3,'o'
                STOR    M[R1],R3
                
                
                
                LOAD    R3,M[R6]
                INC     R6
                LOAD    R2,M[R6]
                INC     R6
                LOAD    R1,M[R6] ;POP
                INC     R6
                LOAD    R5,M[R6]
                INC     R6
                LOAD    R4,M[R6]
                INC     R6
                
                
                                                
;-----------------------------------------------
;            Gerar   Cactos     

Ciclo1:         ;timer
                MVI     R1,tabela       ;Guardar no R1 o endereço da tabela
                
                MVI     R2,elementos    ;Guardar no R2 o numero de posiçoes da tabela

                JAL     atualizajogo
                
                BR      Ciclo1           ;Chamar infinitamente atualizajogo
                
                          
atualizajogo:   DEC     R6
                STOR    M[R6], R7        ;Guardar o endereço de R7 na pilha pois este será alterado
                
                DEC     R6               ;Guardar o R4 na pilha pois este é um registo de uso geral que deverá ser preservado pela função 
                STOR    M[R6], R4        
                
                ADD     R2, R2, R1       ;Guarda em R2 o endereço da posição imediatamente a seguir à última  
                
                DEC     R2               ;Decrementa R2 para este ficar com o endereço da última posição da tabela 
                

ciclo2:          
                CMP     R1, R2    ;Enquanto R1 for diferente de R2,ou seja, enquanto o valor que se encontra na última posição não chegar à primeira
                
                BR.Z    skip      ;Caso R1=R2 salta para skip e termina com o ciclo
                
                INC     R1        ;Ir buscar o valor que se encontra na posiçao seguinte (n+1)  
                LOAD    R4,M[R1]   
                
                DEC     R1        ;Armazená-lo na posicao inicial(n)
                STOR    M[R1],R4
                
                INC     R1        ;Incrementamos R1 e repetimos o ciclo para repetir o processo para todas as colunas(N)
                
                BR      ciclo2
                
skip:                          
                
                DEC     R6
                STOR    M[R6],R1    ;Guardar o endereço de R1(endereço da última posição da tabela) na pilha para o preservarmos 
                
                MVI     R1,alturaM  ;Argumento da função geracacto
                
                JAL     geracacto      ;Invocar a função geracacto
                                      
                LOAD    R1,M[R6]    ;Recuperar o R1 original da pilha
                INC     R6
                
                STOR    M[R1],R3    ;Guardar o resultado da função geracacto no endereço apontado por R1
                
                LOAD    R4,M[R6]  ;Recuperar o valor original de R4 que está guardado na pilha 
                INC     R6
                
                LOAD    R7,M[R6]  ;Recuperar o endereço original de R7 que está guardado na pilha 
                INC     R6
                
                DEC     R6
                STOR    M[R6], R7
                DEC     R6
                STOR    M[R6], R4     ;PUSH 
                DEC     R6
                STOR    M[R6], R5
                
                
                JAL     ProcessaSalto
                
                LOAD    R5,M[R6]    
                INC     R6  
                LOAD    R4,M[R6]    
                INC     R6           ;POP
                LOAD    R7,M[R6]    
                INC     R6

                DEC     R6
                STOR    M[R6], R7
                DEC     R6
                STOR    M[R6], R4 ;PUSH 
                DEC     R6
                STOR    M[R6], R5

                JAL     passaterminal
                
                LOAD    R5,M[R6]    
                INC     R6  
                LOAD    R4,M[R6]    
                INC     R6           ;POP
                LOAD    R7,M[R6]    
                INC     R6
                
                
                
                JMP     R7
;----------------------------------------------------------------------                
                
geracacto:      DEC     R6       
                STOR    M[R6],R4
                                   ;Guardar R4 e R5 na pilha pois são registos de uso geral
                DEC     R6
                STOR    M[R6],R5
                
                MVI     R4,X
                
                LOAD    R5,M[R4]   ;Ir buscar o valor da seed à memória
                
                MOV     R3,R5
                SHR     R3         ;Do pseudo-código em python: x = x >> 1
                
                MVI     R4,1
                
                TEST    R5,R4      ;Do pseudo-código em python: bit = x & 1
                BR.Z    skip2
                
                MVI     R4,B400h
                XOR     R3,R3,R4   ;Do pseudo-código em python:  if bit: x = XOR(x, 0xb400)
                
skip2:          
                MVI     R4,29491
                CMP     R3,R4      ;Do pseudo-código em python:  if x < 29491:    
                MOV     R4,R3      
                
                BR.N    confirma1
                BR.NN   confirma2
confirma1:      BR.O    skip3     ;Para um número ser inferior a outro quando ambos tem sinal as suas flags N e O têm de ser diferentes
                BR      continua
confirma2:      BR.NO   skip3
continua:       MVI     R3,0       ;Return 0
                BR      Final
                
skip3:          DEC     R1         ; altura-1
                
                AND     R3,R3,R1   ;(x & (altura - 1)) 
                INC     R3         ;return (x & (altura - 1)) +1
                
                BR      Final

Final:          MVI     R1,X    
                STOR    M[R1],R4  ;Atualiza o X 
                
                LOAD    R5, M[R6]
                INC     R6
                                   ;POP
                LOAD    R4, M[R6]
                INC     R6
                
                
                JMP     R7
;--------------------------------------------------------------------                
passaterminal:  
                DEC     R6
                STOR    M[R6], R4  ;PUSH
                DEC     R6
                STOR    M[R6], R5

                MVI     R4, tabela
                MVI     R5, elementos
                ADD     R5, R4, R5     
                DEC     R5       ;Obter posicao da tabela

loop11:
                CMP     R4, R5    ;Comparar posicao da tabela(R5) com a primeira posicao da tabela (R4)
                BR.Z    out      ;Se as posicoes forem iguais... out 
                LOAD    R3, M[R4] ;altura do cacto
                
                CMP     R3, R0    ;Se a altura for 0-nao ha cacto...continue00
                BR.Z    continue00

;Caso haja cacto:
                DEC     R6
                STOR    M[R6], R4   ;PUSH
                DEC     R6
                STOR    M[R6], R5

                MVI     R2, tabela
                SUB     R2, R4, R2 ; posicao onde ha cacto
                MVI     R1, AA00h
                ADD     R1, R1, R2 ;obter posicao do cacto no terminal
                MVI     R4, 100h

.loop2:         
                MVI     R5, TERM_CURSOR
                SUB     R1, R1, R4     ;linha acima
                STOR    M[R5], R1
                MVI     R5, TERM_WRITE
                MVI     R2, 'I'
                STOR    M[R5], R2      ;Desenhar o cacto no terminal
                DEC     R3             ;Decrementar o valor da altura do cacto 
                BR.NZ   .loop2
                ;Para desenhar o cacto com a altura desejada
                
                
;---------------------------------                
                MVI     R2, a909h
                CMP     R1, R2     ; verifica se o cacto tem altura 1 e se este se encontra na mesma coluna que o dinossauro (onde poderá haver o choque)
                BR.z    Cuidado1
                MVI     R2, a809h
                CMP     R1, R2     ; verifica se o cacto tem altura 2 e se este se encontra na mesma coluna que o dinossauro (onde poderá haver o choque)
                BR.Z    Cuidado2
                MVI     R2, a709h
                CMP     R1, R2     ; verifica se o cacto tem altura 3 e se este se encontra na mesma coluna que o dinossauro (onde poderá haver o choque)
                BR.Z    Cuidado3
                MVI     R2, a609h
                CMP     R1, R2     ; verifica se o cacto tem altura 4 e se este se encontra na mesma coluna que o dinossauro (onde poderá haver o choque)
                BR.Z    Cuidado4
                
                Br      Exit
                
Cuidado1:       MVI     R5, dinoHeight
                LOAD    R4, M[R5]
                MVI     R2, 1         ; se o dinossauro estiver com uma altura inferior ou igual a 1 em relação ao chão, vai bater no cato de altura 1 (perde)
                CMP     R4, R2
                BR.NP   GameOver 
                BR      Exit
                
Cuidado2:       MVI     R5, dinoHeight
                LOAD    R4, M[R5]
                MVI     R2, 2         ; se o dinossauro estiver com uma altura inferior ou igual a 2 em relação ao chão, vai bater no cato de altura 2 (perde)
                CMP     R4, R2
                BR.NP   GameOver
                BR      Exit
                
Cuidado3:       MVI     R5, dinoHeight
                LOAD    R4, M[R5]
                MVI     R2, 3         ; se o dinossauro estiver com uma altura inferior ou igual a 3 em relação ao chão, vai bater no cato de altura 3 (perde)
                CMP     R4, R2
                BR.NP   GameOver
                BR      Exit
                
Cuidado4:       MVI     R5, dinoHeight
                LOAD    R4, M[R5]
                MVI     R2, 4         ; se o dinossauro estiver com uma altura inferior ou igual a 4 em relação ao chão, vai bater no cato de altura 4 (perde)
                CMP     R4, R2
                BR.NP   GameOver
                BR      Exit
                

Exit:           
                
                LOAD    R5, M[R6]
                INC     R6
                LOAD    R4, M[R6]  ;POP
                INC     R6
continue00:
                INC     R4     ;Passa para a proxima posicao da tabela 
                BR      loop11

out:
                JMP     R7    ;Reiniciar ciclo


GameOver:       MVI 	R1, TERM_WRITE
                MVI 	R2, TERM_CURSOR
                MVI     R4,1500h    
                STOR    M[R2],R4
                
                MVI     R4, FFFFh ;limpa terminal
                STOR    M[R2], R4
                
                ;escrever G A M E  O V E R
                
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,'G'
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,'A'
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,'M'
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,'E'
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,'O'
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,'V'
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,'E'
                STOR    M[R1],R4
                MVI     R4,' '
                STOR    M[R1],R4
                MVI     R4,'R'
                STOR    M[R1],R4
                
                MVI     R1, 4000h
                MVI     R2, 404fh
loopclean:      STOR    M[R1], R0 ;limpar memória
                INC     R1
                CMP     R1, R2
                BR.NZ   loopclean
                
                
                
                
                MVI     R1, TIME
                STOR    M[R1], R0       
                MVI     R1, VERIFICA_ZERO
                STOR    M[R1], R0      
                MVI     R1, VERIFICA_UP     ;atribuir às variáveis os seus valores iniciais de modo a reiniciar o jogo
                STOR    M[R1], R0
                MVI     R1, dinoHeight
                STOR    M[R1], R0
                MVI     R1, dinoupdown
                STOR    M[R1], R0
                MVI     R1, X
                MVI     R2, 5
                STOR    M[R1], R2
                
                
                
                JMP     MAIN   ;para conseguirmos reiniciar o jogo quando pressionarmos o botão 0
                
;-----------------------------------------------
               
ProcessaSalto:  MVI     R1,VERIFICA_UP
                LOAD    R2,M[R1]
                CMP     R2,R0     ;LOOP ate o utilizador carregar no botao UP
                BR.NZ   salto     ;O Botao UP fará o dinossauro saltar
                BR      fim
                
                
salto:          
                MVI     R1,maxjump
                MVI     R2,dinoHeight
                LOAD    R4,M[R2] ;carregar para R4 o valor a que o dinossauro se encontra acima do chão (dinoheight)
                CMP     R1,R4    ; comparar com a altura maxima permitida permitida pelo salto
                BR.Z    down     ; se o dinossauro após ter iniciado o salto atingir a altura máxima permitida vai para down
                MVI     R5, dinoupdown
                LOAD    R3, M[R5]
                CMP     R3, R0 ;verificar se ainda se encontra na fase da subida
                BR.NZ   down
                
                
up:             INC     R4        ;como não atingiu a altura máxima após o botão para saltar ter sido pressionado, percebe-se que o dinossauro ainda se encontra na fase da subida      
                STOR    M[R2],R4    
                BR      fim       ;fazemos o mesmo processo até à altura do dinossauro em relação ao chão for igual à altura maxima permitida pelo salto
                     
                
                ;dinoupdown
down:           MVI     R5, dinoupdown 
                MVI     R3, 1          ;ligamos interruptor que permite diferenciar as fases de subida (está a 0) e descida (está a 1) pelo dinossauro
                STOR    M[R5], R3
                
                DEC     R4
                STOR    M[R2],R4       ; decrementamos a altura a que o dinossauro se encontra (sendo no início máxima) até este atingir o chão (altura 0), terminando assim o salto
                CMP     R4, R0
                BR.NZ   fim
                
                
                STOR    M[R5], R0 ;após concluir o salto o interruptor fica a 0 para que quando a tecla de salto for pressa outra vez o dinossauro iniciar primeiro a fase de subida e não de descida
                
                MVI     R1,VERIFICA_UP      ;Parar o salto  
                STOR    M[R1],R0
                         
fim:            JMP     R7 


AUXTIMER:       DEC     R6 ; GUARDAR CONTEXTO NA STACK
                STOR    M[R6], R1
                DEC     R6
                STOR    M[R6], R2
                
                MVI     R1, TIMER_TICK
                LOAD    R2, M[R1]
                INC     R2
                STOR    M[R1], R2
                
                MVI     R1, TIMER_COUNTER
                MVI     R2, TIMERCOUNT_INIT
                STOR    M[R1], R2 
                
                MVI     R1, TIMER_CONTROL
                MVI     R2, TIMER_SETSTART 
                STOR    M[R1], R2 
                
                LOAD    R2, M[R6] ; RESTAURAR CONTEXTO
                INC     R6
                LOAD    R1, M[R6]
                INC     R6
                
                JMP     R7

                
                
                ORIG    7F00h
BOTAO0:         DEC     R6
                STOR    M[R6],R1    ;Guardar R1 e R2 na pilha (guardar contexto)
                DEC     R6
                STOR    M[R6],R2
                
                MVI     R1,VERIFICA_ZERO
                MVI     R2,2
                STOR    M[R1],R2   ;mudar o valor de VERIFICA_ZERO
                
                LOAD    R2, M[R6]
                INC     R6
                LOAD    R1, M[R6]     ;Recuperar contexto 
                INC     R6
                RTI

                ORIG    7F30h
BOTAOUP:        DEC     R6
                STOR    M[R6],R1     ;Guardar R1 e R2 na pilha (guardar contexto)
                DEC     R6
                STOR    M[R6],R2
                
                MVI     R1,VERIFICA_UP
                MVI     R2,1
                STOR    M[R1], R2 ;mudar o valor de VERIFICA_UP
               
                LOAD    R2,M[R6]
                INC     R6           ;Recuperar contexto
                LOAD    R1,M[R6]
                INC     R6
                RTI
                
                ORIG    7FF0h
TIMER:          DEC     R6 ; GUARDAR R7 NA PILHA 
                STOR    M[R6], R7

                JAL     AUXTIMER
                
                LOAD    R7, M[R6] ; RESTAURAR O VALOR DE R7
                INC     R6
                
                RTI