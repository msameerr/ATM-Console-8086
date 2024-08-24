

; MACRO FOR PRINTING AMOUNT

IMPORTANT MACRO ANSWER
    
MOV AX,9700H  
MOV DX,ANSWER

SUB AX,DX

MOV BX,AX 
MOV CX,AX   

MOV AX,DX  

; AX DX

AND AX,1111111100000000B    
ROR AX,4        
shr AL,4 

AND DX,0000000011111111B
ROL DX,4
SHR DL,4 
      
OR AX,3030H
OR DX,3030H  

MOV DI,0000H
MOV DI,OFFSET STORE_REM

MOV [DI],AH
INC DI
MOV [DI],AL
INC DI
MOV [DI],DH
INC DI
MOV [DI],DL

; BX CX

AND BX,1111111100000000B    
ROR BX,4        
shr BL,4 

AND CX,0000000011111111B
ROL CX,4
SHR CL,4 
      
OR CX,3030H
OR BX,3030H 

MOV SI,0000H 
MOV SI,OFFSET STORE_ANSWER

MOV [SI],BH 
INC SI
MOV [SI],BL
INC SI
MOV [SI],CH
INC SI
MOV [SI],CL

ENDM 


; MACRO FOR NEXT LINE


NEW_LINE MACRO LINE_FEED,CARRIGE_RETURN
   
    MOV AH,2
    MOV DL,LINE_FEED  
    INT 21H
    MOV DL,CARRIGE_RETURN
    INT 21H   
    
ENDM   

CLEAR_SCREEN MACRO TOP_LEFT,BOTTOM_RIGHT,COLOR
    
    MOV AH,6
    MOV AL,0
    MOV BH,COLOR
    MOV CX,TOP_LEFT
    MOV DX,BOTTOM_RIGHT 
    INT 10H
    
    MOV AH,2 
    MOV BH,00
    MOV DL,00  
    MOV DH,00
    INT 10H     
    
    
    ENDM

 
 
; PROGRAM START 


.MODEL SMALL
.STACK 100H

.DATA   

DIS DB '          ----------------------------------------------------$'

DISPLAY DB '                    -------- WELCOME -----------$'
DISPLAY2 DB '                    ============================$'
DISPLAY3 DB '                        ATM MANAGEMENT SYSTEM   $'  


CHOICE DB '                      -------- MAIN MENU ---------$'
CHOICE1 DB '             1 : BALANCE INQUIRY      |       2 : FAST CASH  $'
CHOICE3 DB '                     ENTER CHOICE : $'


MSG11 DB '                    ENTER THE PASSWORD : $'
R_PASSWORD DB 0AH,0DH,'                    YOU HAVE ENTERED THE RIGHT PASSWORD $'
W_PASSWORD DB 0AH,0DH,'                    YOU FAILED TO ENTER THE CORRECT PASSWORD.$'
PASSWORD DB 50 DUP('$')
PASSWORD_LEN DB 00H
CMP_PASSWORD DB 31H,32H,33H
CMP_PASS_LEN DB 03H
                                   

MSG_1 DB '                    ENTER THE ID : $'
R_ID DB 0AH,0DH,'                    YOU HAVE ENTERED THE RIGHT ID $'
W_ID DB 0AH,0DH,'                    YOU FAILED TO ENTER THE CORRECT ID.$'
INPUT DB 50 DUP('$')
INPUT_LEN DB 00H
CMP_INPUT DB 53H,61H,6DH,65H,65H,72H
CMP_INPUT_LEN DB 06H
                              
MSG1 DB '                   YOUR CURRENT ACCOUNT BALANCE : 9700 $'
MSG2 DB '                   1 :  500 RUPEES  |    2 : 1000 RUPEES  $'
MSG4 DB '                   3 : 5000 RUPEES  |    4 : 10000 RUPEES $'
INPUT_CHOICE DB '                     ENTER YOUR CHOICE : $'

OUTPUT1 DB '                    SUCCESSFULY WITHDRAW : 500 RUPEES $'  
OUTPUT2 DB '                    SUCCESSFULY WITHDRAW : 1000 RUPEES $'
OUTPUT3 DB '                    SUCCESSFULY WITHDRAW : 5000 RUPEES $'
OUTPUT4 DB '                    INSUFFICIENT BALANCE $'                                      
                                           
OUTPUT DB '                    THANKS FOR USING MY ATM $'     

AGAIN DB '                    GO TO MAIN MENU ?   $'
AGAIN2 DB '                    PRESS : 1  FOR YES & : 2  FOR NO :  $ '                      
 
STORE_ANSWER DB 00H,00H,00H,00H
STORE_REM DB 00H,00H,00H,00H       
NEW DB '            ---------- WITHDRAWAL AMOUNT ---------- $'    

ACCESS DB '                             ACCESS ALLOWED >>>>>$'  
BALANCE DB '                    YOUR NEW CURRENT ACCOUNT BALANCE :  $' 
BALANCE2 DB '                    YOUR LAST TRANSACTION : $' 
n DB '                               *****                    $'
                                   

.CODE

MAIN PROC
    
    RETRY:
            
    MOV AX,@DATA
    MOV DS,AX 
    MOV ES,AX     
      
               
   ; DISPLAY STARTING 
    
    CLEAR_SCREEN 0000H,184FH,0DH     
   
    NEW_LINE 0AH,0DH          
    NEW_LINE 0AH,0DH    
    MOV AH,9
    LEA DX,DIS
    INT 21H    
    NEW_LINE 0AH,0DH       
    MOV AH,9
    LEA DX,DISPLAY
    INT 21H    
    NEW_LINE 0AH,0DH  
    MOV AH,9
    LEA DX,DISPLAY2
    INT 21H          
    NEW_LINE 0AH,0DH   
    MOV AH,9
    LEA DX,DISPLAY3
    INT 21H  
    NEW_LINE 0AH,0DH 
    MOV AH,9
    LEA DX,DIS
    INT 21H      
    
    
           
    ; TAKING ID INPUT  
    
                    
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH
    MOV AH,9
    MOV DX,OFFSET MSG_1
    INT 21H

    LEA SI,INPUT
    LEA DI,INPUT_LEN
    
    INPUT1:
    MOV AH,1
    INT 21H
    CMP AL,13
    JE NEXT2
    MOV [SI],AL
    INC SI
    ADD [DI],1
    
    JMP INPUT1
    
    NEXT2:
    CALL COMPARE_ID
                    
    
    ; TAKING PASSWORD INPUT                
                             
                             
    NEW_LINE 0AH,0DH        
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH        
    MOV AH,9
    MOV DX,OFFSET MSG11
    INT 21H

    LEA SI,PASSWORD
    LEA DI,PASSWORD_LEN
    
    INPUT2:
    MOV AH,7
    INT 21H
    CMP AL,13
    JE NEXT_2
    MOV [SI],AL
    INC SI
    ADD [DI],1
    
    MOV AH,2
    MOV DL,'*'
    INT 21H
    JMP INPUT2
    
    NEXT_2:
    CALL COMPARE_PASSWORD 
    
    CLEAR_SCREEN 0000H,184FH,0AH  
    
    NEW_LINE 0AH,0DH 
    NEW_LINE 0AH,0DH
     
    MOV AH,9
    LEA DX,ACCESS
    INT 21H  
    
    MOV CX,4
    SET: 
    MOV AH,2
    MOV DL,'>'
    INT 21H
    LOOP SET
       
    
    ; MAIN MENU 
    
    
    MOV BX,1H
    PUSH BX   
    
MAIN_MENU: 
    
    CLEAR_SCREEN 0000H,184FH,0DH     
     mov ah,9
    mov bh,00
    mov al,20h
    mov cx,800h
    mov bl,1Eh
    int 10h 
    
    NEW_LINE 0AH,0DH          
    NEW_LINE 0AH,0DH           
    MOV AH,9
    LEA DX,CHOICE
    INT 21H 
    NEW_LINE 0AH,0DH    
    MOV AH,9
    LEA DX,DIS
    INT 21H   
    NEW_LINE 0AH,0DH  
    MOV AH,9
    LEA DX,CHOICE1
    INT 21H          
    NEW_LINE 0AH,0DH    
    MOV AH,9
    LEA DX,DIS
    INT 21H
    NEW_LINE 0AH,0DH   
    MOV AH,9
    LEA DX,CHOICE3
    INT 21H  
                        
    MOV AH,1
    INT 21H   
    
    CMP AL,31H   
    JE BAL_INQUIRY
    
    CMP AL,32H
    JE WITHDRAW 
    
    WITHDRAW:
    
    CLEAR_SCREEN 0000H,184FH,0DH     
     mov ah,9
    mov bh,00
    mov al,20h
    mov cx,800h
    mov bl,1Eh
    int 10h 
    
    CALL OPERATION  
    JMP END
    
    BAL_INQUIRY:   
    
      
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH 
    
    MOV SI,OFFSET STORE_ANSWER 
    MOV CX,4
    
    POP BX
    CMP BX,1H
    JE PRINT
    INC BX 
    
    MOV AH,9
    LEA DX,BALANCE
    INT 21H

    PRINT2: 
    
    MOV BL,[SI]
    
    MOV AH,2
    MOV DL,BL
    INT 21H 
    INC SI
    
    LOOP PRINT2
    
    ;---
    
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH 
    
    MOV DI,OFFSET STORE_REM
    MOV CX,4
    
    MOV AH,9
    LEA DX,BALANCE2
    INT 21H

    PRINT3: 
    
    MOV BL,[DI]
    
    MOV AH,2
    MOV DL,BL
    INT 21H 
    INC DI
    
    LOOP PRINT3   
    
    ;---        
     
    
    JMP END  
    
    PRINT:
    
    MOV AH,9
    LEA DX,MSG1
    INT 21H
    
    JMP END   
    
    
    ; REMAINING PROGRAM    
    
    
    END: 
     NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH    
    MOV AH,9
    LEA DX,n
    INT 21H 
     NEW_LINE 0AH,0DH
     NEW_LINE 0AH,0DH 
    MOV AH,9
    LEA DX,OUTPUT
    INT 21H     
    
     NEW_LINE 0AH,0DH
     NEW_LINE 0AH,0DH 
     
    MOV AH,9
    LEA DX,AGAIN
    INT 21H  
    
    NEW_LINE 0AH,0DH     
    
    MOV AH,9
    LEA DX,AGAIN2
    INT 21H
    
    MOV AH,1
    INT 21H
    
    CMP AL,31H 
    JE MAIN_MENU
    
    CMP AL,32H
    JE END2
    
    
    END2:
         
    CLEAR_SCREEN 0000H,184FH,0DH     
    mov ah,9
    mov bh,00
    mov al,20h
    mov cx,800h
    mov bl,1Eh
    int 10h   
         
    MOV AH,4CH
    INT 21H 
    
    MAIN ENDP   
                  
                  
                  
                  
   ; COMPARE INPUT FUNCTION               

   COMPARE_ID PROC
    
    MOV AL,INPUT_LEN
    CMP AL,CMP_INPUT_LEN
    JNZ FALSE
    
    MOV CL,INPUT_LEN
    
    MOV SI,OFFSET CMP_INPUT
    MOV DI,OFFSET INPUT  
    MOV CX,6
    
    CHECK:
    
    MOV BL,[SI]
    MOV DL,[DI]
    
    CMP BL,DL
    
    JNZ FALSE  
    
    INC SI
    INC DI
    
    LOOP CHECK
    
    JMP TRUE 
    
    FALSE: 
    MOV AH,9
    MOV DX,OFFSET W_ID
    INT 21H  
    JMP END2
    JMP EXIT      
    
    
    TRUE:  
    MOV AH,9
    MOV DX,OFFSET R_ID
    INT 21H        
    
    
    EXIT:
    RET
    COMPARE_ID ENDP    
                 
    
    ; COMPARE PASSWARD FUNCTION             
                 
   
    COMPARE_PASSWORD PROC
    
    MOV AL,PASSWORD_LEN
    CMP AL,CMP_PASS_LEN
    JNZ FALSE
    
    MOV CL,PASSWORD_LEN
    
    MOV SI,OFFSET CMP_PASSWORD
    MOV DI,OFFSET PASSWORD  
    MOV CX,3
    
    CHECK2:
    
    MOV BL,[SI]
    MOV DL,[DI]
    
    CMP BL,DL
    
    JNZ FALSE2  
    
    INC SI
    INC DI
    
    LOOP CHECK2
    
    JMP TRUE2 
    
    FALSE2:
    MOV AH,9
    MOV DX,OFFSET W_PASSWORD
    INT 21H  
    JMP END2
    JMP EXIT2      
    
    
    TRUE2:
    MOV AH,9
    MOV DX,OFFSET R_PASSWORD
    INT 21H        
    
    
    EXIT2:
    RET
    COMPARE_PASSWORD ENDP  
    
    
    ; OPERATION FUNCTION  
    
    
    OPERATION PROC
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH
    MOV AH,9
    LEA DX,NEW
    INT 21H  
    NEW_LINE 0AH,0DH
    MOV AH,9
    LEA DX,DIS
    INT 21H     
     NEW_LINE 0AH,0DH  
     MOV AH,9
    LEA DX,MSG2
    INT 21H      
     NEW_LINE 0AH,0DH 
     MOV AH,9
    LEA DX,DIS
    INT 21H     
     NEW_LINE 0AH,0DH 
     MOV AH,9
    LEA DX,MSG4
    INT 21H  
    NEW_LINE 0AH,0DH  
    MOV AH,9
    LEA DX,DIS
    INT 21H     
    NEW_LINE 0AH,0DH 
    MOV AH,9
    LEA DX,INPUT_CHOICE
    INT 21H
    
    
    MOV AH,1
    INT 21H
    
    CMP AL,31H
    JE FIRST
    
    CMP AL,32H
    JE SECOND
    
    CMP AL,33H
    JE THIRD
    
    CMP AL,34H
    JE FOURTH
    
    
    FIRST:
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH 
    MOV AH,9
    LEA DX,OUTPUT1
    INT 21H      
    
    IMPORTANT 500H
    
    JMP END
    
    SECOND:
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH    
    
    MOV AH,09
    MOV DX,OFFSET OUTPUT2
    INT 21H      
    IMPORTANT 1000H
    
    JMP END
    
    THIRD:
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH 
    MOV AH,9
    LEA DX,OUTPUT3
    INT 21H  
    IMPORTANT 5000H
    
    JMP END
    
    FOURTH:
    NEW_LINE 0AH,0DH
    NEW_LINE 0AH,0DH 
    MOV AH,9
    LEA DX,OUTPUT4
    INT 21H
    JMP END
        
    RET
    OPERATION ENDP    

END MAIN