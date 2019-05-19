;------------------------------------------------------------
;    monthLookup.asm
;    nasm -f elf -g -F stabs monthLookup.asm

;    ld -m elf_i386 -o monthLookup monthLookup.o
;--------------------------------------------------------------
; user enters two digit input 01-12,
; and name of the month is printed on the screen
;
SECTION .bss

         BUFFLEN equ 2       ; length of the buffer
         Buff:  resb 2       ; text buffer itself, month should be entered 01, 03,..., or 10, 11,12
         MonthName: resb 9   ; nine characters month name for printing
       
SECTION .data
      

       LINEFEED:  db 0AH
       COLON: db 58 ; in decimal
       PromptStr: db "Enter two-digit(important!) month number(01,02,...12) : ",0AH , 3DH,3EH
       PromptLen: equ $-PromptStr

       ExtraInfo:  db  " Month "
       ExtraLen: equ $-ExtraInfo
 
       ByeStr : db 0AH, "Bye!", 0AH
       ByeLen: equ $-ByeStr

       MONTHS:  db 'January  ', 'February ', 'March    '
                db 'April    ', 'May      ', 'June     '
                db 'July     ', 'August   ', 'September'
                db 'October  ', 'November ', 'December '
       

SECTION .text

%include "../macros/WriteString.asm"
global _start


_start:
     nop

     WriteString PromptStr, PromptLen
   
     Read:
       mov eax, 3           ; specify sys_read call
       mov ebx, 0           ; specify file descriptor 0 : Standard Input
       mov ecx, Buff        ; pass offset(address) of the buffer to read to
       mov edx, BUFFLEN     ; pass number of bytes to read in one pass
       int 80H              ; call sys_read to fill the buffer
       ;mov esi, eax        ; copy sys_read return value for safekeeping
       cmp eax, 0AH         ; look for new line (Enter) 
       je Continue          ; on Linux 0Ah is read as part of input string, huge problem

Continue:
     WriteString LINEFEED, 1
     WriteString ExtraInfo, ExtraLen
     WriteString Buff, BUFFLEN
     WriteString COLON, 1
     ;WriteString MONTHS, 108
     ;jmp Exit
     
      
     ; Buff contains 2 characters month number
Convert_Month:
     xor eax, eax         
     xor ecx, ecx

     mov ah, byte[Buff]
     mov al, byte [Buff + 1]
     xor ax, 3030H      ; mask ASCII specific representation
     cmp ah, 0          ; single digit
     jz   LESS_THAN_10
     mov ah, 0          ; othherwise add 10 to al
     add al, 10D 

LESS_THAN_10:
      mov esi, MONTHS
      mov edi, MonthName
      dec al            ; al 1...12, elements of array 0...11
      mov bl, 9         ; each element is 9 bytes long
      mul bl            ; al=al*bl
      add esi, eax
      ; display 9 characters
      cld
      mov cl, 9

      rep movsb

     ; print it
    WriteString MonthName, 9
    WriteString LINEFEED, 1
            
          
Exit:
      mov eax,1        ; specify Exit sysccalll
      mov ebx, 0       ; return a code of zero
      int 80H          ; make syscall to terminate the program

  

