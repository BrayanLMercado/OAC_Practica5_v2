section .data ; Datos inicializados
NL: db 13, 10
NL_L: equ $-NL

section .bss ; Datos no inicializados
N resb 4
M resb 4
cad resb 16
; Crear Variable Array
array resb 256

section .text
global _start:
_start: mov eax,0C2966271h
    mov esi, cad
    ;Guardar La Matricula en M [Indirecto]
    mov ecx,0x1280838
    mov ebx,M
    mov [ebx],ecx
    mov eax,[M]
    call printHex
    call newLine
    
    ; Guardar 0xACF2359A como binario en EBX [Indirecto]
    mov eax,N
    mov dword[eax],10101100111100100011010110011010b
    mov ebx,[eax]
    mov eax,ebx
    mov esi,cad
    call printHex
    call newLine

    ;Pasar lo de BX a CX [De Registro]
    mov cx,bx
    movzx eax,cx
    call printHex
    call newLine

    ; Guardar 524h en M [Indirecto]
    mov edx,M
    mov ecx,0x524
    mov dword[edx],ecx
    mov eax,[M]
    call printHex
    call newLine

    ;Copiar El Contenido De Ebx a la dirección de M [Directo]
    ;lea eax,M
    mov [804A008h],ebx
    mov eax,[804A008h]
    call printHex
    call newLine

    ; Guardar en array los valores 0,1,2,3,4 (32 bits) [Directo]
    ;lea eax,array
    mov ecx,0x0
    mov [0x0804A01C],ecx
    mov ecx,0x1
    mov [0x0804A020],ecx
    mov ecx,0x2
    mov [0x0804A024],ecx
    mov ecx,0x3
    mov [0x0804A028],ecx
    mov ecx,0x4
    mov [0x0804A02C],ecx

    ;Comprobar que se encuentre en el valor correcto [Base+Indice Escalado]
    mov ebx,array
    mov edi,0x0
    mov eax,[ebx+edi*4]
    call printHex
    call newLine
    mov edi,0x1
    mov eax,[ebx+edi*4]
    call printHex
    call newLine
    mov edi,0x2
    mov eax,[ebx+edi*4]
    call printHex
    call newLine
    mov edi,0x3
    mov eax,[ebx+edi*4]
    call printHex
    call newLine
    mov edi,0x4
    mov eax,[ebx+edi*4]
    call printHex
    call newLine

    ;Exit Call
    mov eax, 1
    mov ebx,0
    int 80h

newLine:
    pushad
    mov eax,4
    mov ebx,1
    mov ecx,NL
    mov edx,NL_L
    int 0x80
    popad
    ret

printHex:
    pushad
    mov edx, eax
    mov ebx, 0fh
    mov cl, 28
    .nxt: shr eax,cl
    .msk: and eax,ebx
    cmp al, 9
    jbe .menor
    add al,7
    .menor:add al,'0'
    mov byte [esi],al
    inc esi
    mov eax, edx
    cmp cl, 0
    je .print
    sub cl, 4
    cmp cl, 0
    ja .nxt
    je .msk
    .print: mov eax, 4
    mov ebx, 1
    sub esi, 8
    mov ecx, esi
    mov edx, 8
    int 80h
    popad
    ret