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
// x15 y x16 posicion de los @
mov x10, 0x58 //'X'
mov x11, 0x20 //'.'
mov x15, 0x0 //
mov x16, 0x0 //

b start

mover:LDRB    w3, [x5] //mover
CMP	    x3, 0x23
B.EQ	    ganar 
STRB w10, [x5]
STRB w11, [x2]  
add x2, x5, xzr
BR	    x30

foundArroba: //cargar posicion de @
subs xzr, xzr, x15
b.NE	    llenax16
ADD	    x15, x5, xzr
b findArroba
llenarx16: ADD	    x16, x5, xzr
b finalArroba

start: add x2, x0, 16  //inicio
findx: LDURB    w3, [x2, #0]  //buscar x
CMP x3, x10
B.EQ encontrado
ADD x2, x2, #1
B findx

encontrado:
findArroba: add x5, x2, #1  //buscar teletrasportes
LDURB    w3, [x5]
cmp x3, 0x40
b.EQ	    foundArroba
CMP	    x3, 0x4A
b.EQ	    finalArroba
ADD	    x5, x5, #1
b findArroba

finalArroba:
contarBonus:

ganar:mov x2, x0
loopganar: add x2, x2, 0x10
LDURB    w3, [x2]
CMP	    x3, 0x4A
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
