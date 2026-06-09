.section .maze, "aw"
.align 3
.global laberinto 
.section .data
    estado: .dword 0x4e45204f4745554a, 0x21214f5352554320
    _stack_ptr: .dword _stack_end

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
// x2 tiene la posicion en memoria de x
// x3 para guardar la lectura del char en memoria
// x5 para lugar en memoria de lectura 
// x10 valor char de x para cargar en ram
// x11 valor char de lugar usado
mov x10, 0x58 //'X'
mov x11, 0x2A //'*'
b start
mover:LDRB    w3, [x5]
CMP	    x3, 0x23
B.EQ	    ganar 
STRB w10, [x5]
STRB w11, [x2]  
add x2, x5, xzr
BR	    x30

start: add x2, x0, 16 
findx: LDURB    w3, [x2, #0]
CMP x3, x10
B.EQ encontrado
ADD x2, x2, #1
B findx

encontrado:add x5, x2, #16
LDURB    w3, [x5]
SUBS    xzr, x3, 0x20
B.NE	    infloop
BL	    mover

ganar:mov x2, x0
loopganar: add x2, x2, 0x10
LDURB    w3, [x2]
CMP	    x3, 0x4A
B.NE	    loopganar
STRH    w29, [x2, #4]
mov x29, 0x4554
STRH    w29, [x2, #6]
mov x29, 0x4D52
STRH    w29, [x2, #8]
mov x29, 0x4E49
STRH    w29, [x2, #10]
mov x29, 0x4441
STRH    w29, [x2, #12]
mov x29, 0x2A4F
STRH    w29, [x2, #14]

// --------------------------------------------------------------------
    
infloop: b infloop
