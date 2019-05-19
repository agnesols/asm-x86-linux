;---------------------
; WriteString macro 
;  %1 - string address, %2 string length, writes to sys_out
;-------------------

%macro WriteString 2 
      push eax        ; save perinent registers
      push ebx
      mov ecx, %1     ; Put string address in ecx
      mov edx, %2     ; put string lenth into edx
      mov eax, 4      ;specify sys_write call
      mov ebx, 1      ; Specify File Descriptor 1 :Stdout
      int 80H         ; make kernel call
       pop ebx
      pop eax    
%endmacro

;MACRO
; takes memory address, length in bytes, chraracter to fill the string 
;----
%macro ClearMemory 3
       push eax
       push ecx
       push edi

       mov edi, %1
       mov ecx, %2
       mov al, %3
       rep stosb

       pop edi
       pop ecx
       pop eax

%endmacro 
