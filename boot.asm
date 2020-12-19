bits 16
org 0x7c00

boot:
    mov ax, 0x2401
    int 0x15
    mov ax, 0x3
    int 0x10
    cli
    lgdt [globdesc_ptr]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE:main_code

globdesc_start:
    dq 0x0

globdesc_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

globdesc_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

globdesc_end:

globdesc_ptr:
    dw globdesc_end - globdesc_start
    dd globdesc_start

CODE equ globdesc_code - globdesc_start
DATA equ globdesc_data - globdesc_start

bits 32

main_code:
    mov ax, DATA
    mov gs, ax
    mov es, ax
    mov ss, ax
    mov ds, ax
    mov fs, ax
    mov esi, msg
    mov ebx, 0xb8000

.loop:
    lodsb
    or al, al
    jz stop
    or eax, 0x0F00
    mov word [ebx], ax
    add ebx, 2
    jmp .loop

stop:
    mov eax, cr0
    or eax, 0x0F00
    mov [ebx], eax
    cli
    hlt

msg: db "Hello, World. ", 0

times 510 - ($ - $$) db 0
dw 0xaa55