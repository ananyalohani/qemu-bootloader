; Name: Ananya Lohani
; Roll Number: 2019018

; starting in real mode (16-bit)
bits 16
org 0x7c00

boot:
    mov ax, 0x3
    int 0x10                ; set VGA text mode 3
    cli                     ; disable interrupts
    lgdt [globdesc_ptr]     ; load the global descriptor table
    mov eax, cr0            ; set protected mode bit in cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE:main_code      ; jump to CODE segment

; set up the global descriptor table
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

CODE equ globdesc_code - globdesc_start

globdesc_end:
globdesc_ptr:
    dw globdesc_end - globdesc_start
    dd globdesc_start

; shift to protected mode (32-bit)
bits 32

main_code:
    mov esi, msg                ; store the message string in esi
    mov ebx, 0xb8000            ; initialise the VGA buffer

.loop:
    lodsb                       ; load esi to al and increments esi
    or al, al                   ; check if end of string has been reached
    jz stop                     ; jump to stop if al is zero
    or eax, 0x0F00              ; set text color to white
    mov word [ebx], ax          ; move a single character of the message to the buffer
    add ebx, 2                  ; increment buffer pointer
    jmp .loop                   ; loop again

stop:
    mov eax, cr0                ; to print the value of cr0
    or eax, 0x0F00
    mov [ebx], eax
    cli                         ; disable all interrupts
    hlt                         ; halt execution

msg: db "Hello, World. Value of cr0 in ASCII:", 0

; Magic numbers for loading the binary as a bootable image
times 510 - ($ - $$) db 0
dw 0xaa55