.section .maze, "aw"
.align 3
.global laberinto 
.section .data
    _stack_ptr: .dword _stack_end
    estado: .dword 0x4e45204f4745554a, 0x21214f5352554320

// ------------- Modificar para agregar datos constantes --------------

// --------------------------------------------------------------------

.section .text
.global _start  

_start:
    ldr     x1, =_stack_ptr 
    ldr     x1, [x1]        
    mov     sp, x1
    mov x0, xzr
    mov x4, xzr
    ldr x0, =laberinto    

main:
// ------------- El código principal debe ir aqui abajo ---------------

// --------------------------------------------------------------------
    
infloop: b infloop
