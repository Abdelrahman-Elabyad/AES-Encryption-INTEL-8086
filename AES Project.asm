
org 100h

; Define data segment
.data
SBOX DB 063h, 07Ch, 077h, 07Bh, 0F2h, 06Bh, 06Fh, 0C5h, 030h, 001h, 067h, 02Bh, 0FEh, 0D7h, 0ABh, 076h
DB 0CAh, 082h, 0C9h, 07Dh, 0FAh, 059h, 047h, 0F0h, 0ADh, 0D4h, 0A2h, 0AFh, 09Ch, 0A4h, 072h, 0C0h
DB 0B7h, 0FDh, 093h, 026h, 036h, 03Fh, 0F7h, 0CCh, 034h, 0A5h, 0E5h, 0F1h, 071h, 0D8h, 031h, 015h
DB 004h, 0C7h, 023h, 0C3h, 018h, 096h, 005h, 09Ah, 007h, 012h, 080h, 0E2h, 0EBh, 027h, 0B2h, 075h
DB 009h, 083h, 02Ch, 01Ah, 01Bh, 06Eh, 05Ah, 0A0h, 052h, 03Bh, 0D6h, 0B3h, 029h, 0E3h, 02Fh, 084h
DB 053h, 0D1h, 000h, 0EDh, 020h, 0FCh, 0B1h, 05Bh, 06Ah, 0CBh, 0BEh, 039h, 04Ah, 04Ch, 058h, 0CFh
DB 0D0h, 0EFh, 0AAh, 0FBh, 043h, 04Dh, 033h, 085h, 045h, 0F9h, 002h, 07Fh, 050h, 03Ch, 09Fh, 0A8h
DB 051h, 0A3h, 040h, 08Fh, 092h, 09Dh, 038h, 0F5h, 0BCh, 0B6h, 0DAh, 021h, 010h, 0FFh, 0F3h, 0D2h
DB 0CDh, 00Ch, 013h, 0ECh, 05Fh, 097h, 044h, 017h, 0C4h, 0A7h, 07Eh, 03Dh, 064h, 05Dh, 019h, 073h
DB 060h, 081h, 04Fh, 0DCh, 022h, 02Ah, 090h, 088h, 046h, 0EEh, 0B8h, 014h, 0DEh, 05Eh, 00Bh, 0DBh
DB 0E0h, 032h, 03Ah, 00Ah, 049h, 006h, 024h, 05Ch, 0C2h, 0D3h, 0ACh, 062h, 091h, 095h, 0E4h, 079h
DB 0E7h, 0C8h, 037h, 06Dh, 08Dh, 0D5h, 04Eh, 0A9h, 06Ch, 056h, 0F4h, 0EAh, 065h, 07Ah, 0Aeh, 008h
DB 0BAh, 078h, 025h, 02Eh, 01Ch, 0A6h, 0B4h, 0C6h, 0E8h, 0DDh, 074h, 01Fh, 04Bh, 0BDh, 08Bh, 08Ah
DB 070h, 03Eh, 0B5h, 066h, 048h, 003h, 0F6h, 00Eh, 061h, 035h, 057h, 0B9h, 086h, 0C1h, 01Dh, 09Eh
DB 0E1h, 0F8h, 098h, 011h, 069h, 0D9h, 08Eh, 094h, 09Bh, 01Eh, 087h, 0E9h, 0CEh, 055h, 028h, 0DFh
DB 08Ch, 0A1h, 089h, 00Dh, 0BFh, 0E6h, 042h, 068h, 041h, 099h, 02Dh, 00Fh, 0B0h, 054h, 0BBh, 016h
mix_matrix  db 0x02, 0x03, 0x01, 0x01
            db 0x01, 0x02, 0x03, 0x01 
            db 0x01, 0x01, 0x02, 0x03
            db 0x03, 0x01, 0x01, 0x02 
cypher_key  db 0xFF, 0xFF, 0xFF, 0xFF
            db 0xFF, 0xFF, 0xFF, 0xFF
            db 0xFF, 0xFF, 0xFF, 0xFF
            db 0xFF, 0xFF, 0xFF, 0xFF                      
rot_word  db 0x00, 0x00, 0x00, 0x00; intailising the rot word using anything as it will be overwritten           

rcon  db 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1B, 0x36
      db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
      db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
      db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
invalid_msg db 'Invalid input. Please enter valid hexadecimal values (0-9, A-F, a-f).$', 0

counter db 0x00h;number of elements in a 128 bit matrix input
shift_counter db 0x00 ; Determines how many times we need to rotate
row_counter   db 0x00 ; Tracks the current row
loop_counter  db 0x08
v1   db 0x00
v2   db 0x00
v3   db 0x00
v4   db 0x00 
m1   db 0x00     
m2   db 0x00 
m3   db 0x00
m4   db 0x00
prompt_matrix db 'Enter 16 hexadecimal values for the matrix (e.g., 19A09AE9): $'
matrix db 32 dup(0)    ; Reserve space for 16 bytes, renamed to avoid duplication
hex_string db 48 dup('$') ; Space for formatted hex output string (16 bytes * 3 = 48 chars)        
Sub_bytes Macro matrix 
    local loop_start 
loop_start:
    mov ch,0
    mov si,0 
    mov ah,0
    mov si,0
    mov cl, [counter]       ; Load the current counter value into CL          ; Load the base address of the matrix into SI
    add si, cx              ; Add counter (CL) to SI to calculate the effective address
    mov al, matrix[si]            ; Load the value from the matrix into AL
    mov si,0
    add si, ax              ; Add BL (low byte of BX) to SI for the sbox index
    mov al, sbox[si]  
    mov si,0
    add si, cx                  ; Recalculate the matrix address for storing
    mov matrix[si], al            ; Store the updated value back into the matrix

    inc byte ptr [counter]  ; Increment the counter
    cmp byte ptr [counter], 16 ; Compare counter with 16 (for 4x4 matrix)
    jl loop_start           ; Repeat if counter < 16 jl (jump less than)
    
    
    ; Reset registers after the loop
    mov counter,0
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si,si
    xor di,di
ENDM

shifting Macro matrix
     local start
     local row_loop
     local shift_loop
     local storing
start:
    ; Initialize pointer and counter
    lea si, matrix ; SI points to the start of the matrix(address)
    mov cx, 4             ; Matrix has 4 rows

row_loop:
    ; Load the current row into registers
    mov dh, [si]          ; First element
    mov bl, [si + 1]      ; Second element
    mov ah, [si + 2]      ; Third element
    mov bh, [si + 3]      ; Fourth element

    ; Determine the number of shifts for the current row
    mov al, [row_counter]  ; Row number decides shift count (not using offset here)
    mov [shift_counter], al

shift_loop:
    cmp [shift_counter], 0
    je storing            ; If no shifts are left, store the row

    ; Perform rotation of the row
    mov dl, dh            ; Temporarily save the first element
    mov dh, bl
    mov bl, ah
    mov ah, bh
    mov bh, dl
    dec [shift_counter]
       ; Decrement the shift counter
    jmp shift_loop        ; Repeat the rotation

storing:
    ; Store the rotated row back into the matrix
    mov [si], dh
    mov [si + 1], bl
    mov [si + 2], ah
    mov [si + 3], bh

    ; Update pointer and counters
    add si, 4             ; Move SI to the next row
    inc [row_counter]     ; Increment the row counter    
    cmp [row_counter],4
    jne row_loop         ; Process the next row 
    
    ; Reset registers after the loop
    mov [row_counter],0
    mov [shift_counter],0
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si,si
    xor di,di 
    
ENDM  
mix_columns Macro matrix
    local start
    local label3
    local label4
    local continue
    local di_mix_matrix
    local second
    local third
    local fourth
    local checks
    local case1
    local case2
    local LEFTMOST_IS_ONE
    local leftmostzero
    local case3
    local label2
    local cases
    local first_element
    local second_element
    local third_element
    local fourth_element
    local last
    local end_mix_columns

    Mov cL,0
    mov DI, 0          ; Starting index for mix_matrix
    mov SI, 0          ; Starting index for matrix rows
    mov ch,3           ;
    mov cl,16
    mov sp,3           ; counter for a column in the matrix to finish
;start:
    ;cmp ch,0
    ;jne label3
    ;inc si
    ;inc di
    
label3:        
    cmp cl,0
    je end_mix_columns
    cmp sp,0
    je label4 
label4:
    ;xor bh,bh
    mov sp,3    
    MOV CH,3
    XOR DI,DI
    MOV AL,matrix[si]
    MOV V1,AL
    MOV AL,matrix[si+4]
    mov v2,AL
    MOV AL,matrix[si+8]
    mov v3,AL  
    MOV AL,matrix[si+12]
    mov v4,AL
    
continue:
    cmp ch,0
    jne di_mix_matrix
    add di, 4
    MOV CH,3
di_mix_matrix:
    xor bh,bh
    MOV BL, mix_matrix[di]
    MOV m1, BL
    MOV BL, mix_matrix[di+1]
    MOV m2, BL
    MOV BL, mix_matrix[di+2]
    MOV m3, BL
    MOV BL, mix_matrix[di+3]
    MOV m4, BL

    mov AL,v1
    mov bL,m1
    jmp checks
second:
    mov AL,v2
    mov BL,m2
    jmp checks


third:
    mov AL,v3
    mov BL,m3
    jmp checks


fourth:
    mov AL,v4
    mov BL,m4
    
   
checks:
    cmp BL, 1
    je case1
    cmp BL, 2
    je case2
    jmp case3

case1:
    ; Multiply AL by BL (Galois field multiplication for 1 is identity)
    xor BH, AL
    jmp cases
    

case2:
    ; Perform GF(2^8) multiplication by 2
    mov dh,al
    TEST dh, 80H         ; Test the leftmost bit
    JNZ LEFTMOST_IS_ONE  ; If the result is non-zero, the leftmost bit is 1
    JMP leftmostzero ; Otherwise, the leftmost bit is 0 
    
LEFTMOST_IS_ONE:
    shl AL, 1
    xor AL, 1Bh         ; Reduction polynomial for GF(2^8)
    cmp bl,03
    je label2
    xor BH, AL
    jmp cases    

    

leftmostzero:
    shl AL, 1           ; Simple left shift for no carry
    cmp bl,03
    je label2
    xor BH, AL
    jmp cases
    

case3:
    mov ah,al    
    jmp case2
            
label2:
     xor al,ah
     Xor bh,al 
     jmp cases
    
        
cases:  
    DEC CH
    cmp ch,2
    je second                       
    cmp ch,1
    je third
    cmp ch,0
    je fourth
    ; passing this means its the last row
    MOV CH,0
    cmp sp,3
    je first_element
    cmp sp, 2
    je second_element
    cmp sp, 1
    je third_element
    jmp fourth_element
first_element:    
    MOV matrix[si],bh
    jmp last
second_element:    
    MOV matrix[si+4],bh    
    jmp last
third_element:    
    MOV matrix[si+8],bh
    jmp last
fourth_element:    
    MOV matrix[si+12],bh
    inc si
    dec cl
    jmp label3 
last:
    dec sp 
    dec cl
    jmp continue
    
    

end_mix_columns:
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si,si
    xor di,di 
ENDM


ADD_ROUND_KEY MACRO iteration_number ; AS IF WE ARE IN THE FIRST STEP WE USE THE CYPHER_KEY
     local   xoring_columns
     local   continue 
     local   xoring
     CMP CL,0
     JE  xoring    
xoring:   
    MOV CX,16
    mov si,0
continue: 
    MOV AL,matrix[si]
    MOV AH,cypher_key[si]
    XOR AL,AH 
    MOV matrix[si],AL
    INC SI   
    loop continue
    
    ; Reset registers after the loop
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si,si
    xor di,di 
ENDM 

.code       
main proc              
   ; Initialize data segment
   mov ax, @data
   mov ds, ax

   ; Prompt the user for input
   lea dx, prompt_matrix      ; Load the address of the input prompt string
   mov ah, 09h                ; DOS interrupt to display string
   int 21h

   
   
   
   
    mov cx, 32                 ; Total characters to process (16 bytes * 2 nibbles)
    xor si, si                 ; Reset matrix index
    xor bl, bl                 ; Temporary register for high nibble

input_loop:
    mov ah, 01h                ; Read one character from input
    int 21h
    cmp al, ','                ; Skip commas
    je input_loop
    cmp al, ' '                ; Skip spaces
    je input_loop

    ; Validate input character
    cmp al, '0'
    jl invalid_char            ; If less than '0', invalid input
    cmp al, '9'
    jbe store_high             ; If between '0' and '9', store as high nibble
    cmp al, 'A'
    jl invalid_char            ; If less than 'A', invalid input
    cmp al, 'F'
    jbe store_high             ; If between 'A' and 'F', store as high nibble
    cmp al, 'a'
    jl invalid_char            ; If less than 'a', invalid input
    cmp al, 'f'
    jbe store_high             ; If between 'a' and 'f', store as high nibble
    jmp invalid_char           ; Otherwise, invalid input

store_high:
    ; Convert ASCII to high nibble
    cmp al, '9'
    jbe convert_digit
    cmp al, 'F'
    jbe convert_uppercase
    sub al, 'a' - 10           ; Convert 'a'-'f' to 10-15
    jmp shift_high
convert_uppercase:
    sub al, 'A' - 10           ; Convert 'A'-'F' to 10-15
    jmp shift_high
convert_digit:
    sub al, '0'                ; Convert '0'-'9' to 0-9
shift_high:
    shl al, 4                  ; Shift left for high nibble
    mov bl, al                 ; Store high nibble in BL

    ; Read second character for low nibble
    mov ah, 01h
    int 21h
    cmp al, ','                ; Skip commas
    je input_loop_low
    cmp al, ' '
    je input_loop_low

    ; Validate input character
    cmp al, '0'
    jl invalid_char
    cmp al, '9'
    jbe store_low
    cmp al, 'A'
    jl invalid_char
    cmp al, 'F'
    jbe store_low
    cmp al, 'a'
    jl invalid_char
    cmp al, 'f'
    jbe store_low
    jmp invalid_char

store_low:
    ; Convert ASCII to low nibble
    cmp al, '9'
    jbe convert_digit_low
    cmp al, 'F'
    jbe convert_uppercase_low
    sub al, 'a' - 10           ; Convert 'a'-'f' to 10-15
    jmp combine_nibbles
convert_uppercase_low:
    sub al, 'A' - 10           ; Convert 'A'-'F' to 10-15
    jmp combine_nibbles
convert_digit_low:
    sub al, '0'                ; Convert '0'-'9' to 0-9

combine_nibbles:
    or bl, al                  ; Combine high and low nibbles
    mov matrix[si], bl         ; Store the full byte in the matrix
    inc si                     ; Increment matrix index
    dec cx                     ; Two characters processed
    loop input_loop            ; Repeat until all characters are read
    jmp continue_execution     ; Exit input loop

invalid_char:
    lea dx, invalid_msg        ; Display error message
    mov ah, 09h
    int 21h
    jmp input_loop             ; Restart input loop

input_loop_low:
    jmp store_low

   
   
continue_execution:

                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
   ; Start AES encryption steps
   mov cl, 0
   ADD_ROUND_KEY 0
                    
                       
                    
                    
                    
                    
loops:   
   Sub_bytes matrix
   shifting matrix
   mix_columns matrix
   ADD_ROUND_KEY 0 
   mov cl, [loop_counter]
   dec byte ptr [loop_counter]
   cmp cl, 0  
   je final_round
   jmp loops

final_round:    
   Sub_bytes matrix
   shifting matrix 
   ADD_ROUND_KEY 0    

   ; Display the encrypted matrix in hexadecimal format
   lea si, matrix          ; Point SI to the start of the encrypted matrix
   mov cx, 16              ; Number of bytes to display

display_hex:
   lea si, matrix          ; Point to the start of the encrypted matrix
   mov cx, 16              ; 16 bytes to display

output_loop:
   mov al, [si]            ; Load the byte
   mov ah, al
   shr ah, 4               ; Get the high nibble
   add ah, 30h             ; Add ASCII offset to convert to a character
   cmp ah, 39h             ; Check if it’s above '9'
   jbe print_high          ; If yes, it’s a digit
   add ah, 7h              ; Else adjust to 'A'-'F'
print_high:
   mov dl, ah              ; Move high nibble to DL
   mov ah, 02h             ; DOS interrupt to print character
   int 21h

   mov al, [si]            ; Reload the byte
   and al, 0Fh             ; Get the low nibble
   add al, 30h             ; Add ASCII offset to convert to a character
   cmp al, 39h             ; Check if it’s above '9'
   jbe print_low           ; If yes, it’s a digit
   add al, 7h              ; Else adjust to 'A'-'F'
print_low:
   mov dl, al              ; Move low nibble to DL
   mov ah, 02h             ; DOS interrupt to print character
   int 21h

   ; Print a space or end formatting
   inc si                  ; Move to the next byte
   loop output_loop        ; Repeat for all bytes
end_display:
   mov ah, 4Ch             ; DOS interrupt to terminate the program
   int 21h      
   

main endp

