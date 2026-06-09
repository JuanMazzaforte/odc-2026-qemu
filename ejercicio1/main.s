.section .maze, "aw"
.align 3
.global laberinto 
.section .data
    estado: .dword 0x4e45204f4745554a, 0x21214f5352554320
    _stack_ptr: .dword _stack_end

// ------------- Modificar para agregar datos constantes --------------
.equ char_x, 0x58
.equ char_vacio, 0x20
.equ char_llegada, 0x23
.equ char_tp, 0x40
.equ char_j, 0x4A
.equ char_bonus, 0x6F
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
// x6 contador de bonus
// x10 valor char de x para cargar en ram
// x11 valor char de lugar usado
// x15 y x16 posicion de los @
mov x10, char_x //'X'
mov x11, char_vacio //'.'
mov x15, 0x0 //
mov x16, 0x0 //
mov x6, 0x0

b start

mover:LDRB    w3, [x5] //mover
CMP	    x3, char_llegada
B.EQ	    ganar 
STRB w10, [x5]
STRB w11, [x2]  
add x2, x5, xzr
BR	    x30

foundArroba: //cargar posicion de @
subs xzr, xzr, x15
b.NE	    llenarx16
ADD	    x15, x5, xzr
add x5, x5, 1
b findArroba
llenarx16: ADD	    x16, x5, xzr
add x5, x5, 1
b findArroba

foundBonus: add x6, x6, 1 //contar los bonus
add x5, x5, 1
b findArroba

start: add x2, x0, 16  //inicio
findx: LDURB    w3, [x2, #0]  //buscar x
CMP x3, x10
B.EQ encontrado
ADD x2, x2, #1
B findx

encontrado:add x5, x0, #1 
findArroba:  //buscar teletrasportes
LDURB    w3, [x5]
cmp x3, char_tp
b.EQ	    foundArroba
cmp x3, char_bonus
b.EQ	    foundBonus
CMP	    x3, char_j
b.EQ	    finalArroba
ADD	    x5, x5, #1
b findArroba

finalArroba:



ganar:mov x2, x0
loopganar: add x2, x2, 0x10
LDURB    w3, [x2]
CMP	    x3, char_j
B.NE	    loopganar
STRH    w11, [x2, #4]
mov x11, 0x4554
STRH    w11, [x2, #6]
mov x11, 0x4D52
STRH    w11, [x2, #8]
mov x11, 0x4E49
STRH    w11, [x2, #10]
mov x11, 0x4441
STRH    w11, [x2, #12]
mov x11, 0x2A4F
STRH    w11, [x2, #14]

// --------------------------------------------------------------------
    
infloop: b infloop
