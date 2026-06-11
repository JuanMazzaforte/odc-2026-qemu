.section .maze, "aw"
.align 3
.global laberinto 
.section .data
    _stack_ptr: .dword _stack_end
    estado: .dword 0x4e45204f4745554a, 0x21214f5352554320

// ------------- Modificar para agregar datos constantes --------------
.equ char_x, 0x58
.equ char_vacio, 0x20
.equ char_llegada, 0x23
.equ char_tp, 0x40
.equ char_j, 0x4A
.equ char_bonus, 0x6F
.equ char_sinSalida, 0x2C
.equ char_inicioRastro, 0x80
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
// x1 para contar los pasos
// x6 tiene la posicion en memoria de x
// x3 para guardar la lectura del char en memoria
// x5 para lugar en memoria de lectura 
// x2 contador de bonus
// x10 valor char de x para cargar en ram
// x11 valor actual del conteo de rastro
// x15 y x16 posicion de los @
// x18 resultados temporales
// x20 a x23 guardar los chars de las 4 direcciones para elegir camino
mov x10, char_x //'X'
mov x11, char_inicioRastro
mov x12, char_tp//@
mov x13, char_sinSalida//','
mov x14, char_vacio
mov x15, 0x0 //
mov x16, 0x0 //
mov x2, 0x0
mov x1, 0x0

b start

moverBonus:
STRB w10, [x5]
STRB w11, [x6]  
mov x11, char_inicioRastro
add x6, x5, xzr
sub x2, x2, 1
b limpieza

backx15:
mov x6, x5
sub x11, x11, 1
ADD	    x1, x1, 1
STRB w10, [x16]
STRB w13, [x6] 
mov x6, x16
sub x11, x11, 1
B	    elegirCamino

backTp:
ADD	    x1, x1, 1
STRB w10, [x5]
STRB w13, [x6]  
CMP	    x5, x15
b.EQ	    backx15
mov x6, x5
sub x11, x11, 1
ADD	    x1, x1, 1
STRB w10, [x15]
STRB w13, [x6] 
mov x6, x15
sub x11, x11, 1
B	    elegirCamino

backtraking:
CMP	    x5, x15
b.EQ	    backTp
CMP	    x5, x16
b.EQ	    backTp
add x1, x1, 1
STRB w10, [x5]
STRB w13, [x6]  
mov x6, x5
sub x11, x11, 1
b elegirCamino

mover:LDRB    w3, [x5] //mover
cmp x3, char_tp
b.EQ	    moverTp
cmp x3, char_bonus
b.EQ	    moverBonus
cmp x3, char_llegada
b.EQ	    ganar
cmp x3, char_inicioRastro
b.HS	    backtraking
  
STRB w10, [x5]
STRB w11, [x6] 
add x11, x11, 1 
add x6, x5, xzr
add x1, x1, 1
B       elegirCamino

moverTp:
STRB w11, [x6]
add x11, x11, 1
CMP x5, x15
B.EQ ir_16
STRB w11, [x16]
STRB w10, [x15]
add x11, x11, 1
MOV x6, x15
B elegirCamino

ir_16:
STRB w11, [x15] 
STRB w10, [x16] 
add x11, x11, 1
MOV x6, x16  
B elegirCamino

foundArroba: //cargar posicion de @
subs xzr, xzr, x15
b.NE	    llenarx16
ADD	    x15, x5, xzr
add x5, x5, 1
b findArroba
llenarx16: ADD	    x16, x5, xzr
add x5, x5, 1
b findArroba

foundBonus: add x2, x2, 1 //contar los bonus
add x5, x5, 1
b findArroba

start: add x6, x0, 16  //inicio
findx: LDURB    w3, [x6, #0]  //buscar x
CMP x3, x10
B.EQ encontrado
ADD x6, x6, #1
B findx

encontrado:add x5, x0, #1 
findArroba:  //buscar teletrasportes
LDURB    w3, [x5]
cmp x3, char_tp
b.EQ	    foundArroba
cmp x3, char_bonus
b.EQ	    foundBonus
CMP	    x3, char_j
b.EQ	    elegirCamino
ADD	    x5, x5, #1
b findArroba

borrar:STURB    w14, [x5]
b loopLimpieza

limpieza: add x5, x0, 0
STURB    w12, [x15]
STURB    w12, [x16]

loopLimpieza: add x5, x5, 1
LDURB    w3, [x5]
CMP	    x3, char_sinSalida
b.EQ	    borrar
CMP	    x3, char_inicioRastro
b.HS	    borrar
CMP	    x3, char_j
mov x11, char_inicioRastro
b.EQ	    elegirCamino
b           loopLimpieza

elegirCamino: //elegir camino
LDRB    w20, [x6, #-16] //arriba
LDRB    w21, [x6, #16] //abajo
LDRB    w22, [x6, #-1] //izquierda
LDRB    w23, [x6, #1] //derecha
//Comprobar si se puede mover a cada direccion
//prioridad 1) llegada 
cmp x20, char_llegada
b.NE	    check_abajo
CBZ	    x2, ir_arriba

check_abajo:
cmp x21, char_llegada
b.NE	    check_izq
CBZ	    x2, ir_abajo

check_izq:
cmp x22, char_llegada
b.NE	    check_der
CBZ x2, ir_izquierda

check_der:
cmp x23, char_llegada
b.NE	    fin_check_llegada
CBZ x2, ir_derecha
fin_check_llegada:
//prioridad 2) bonus 
cmp x20, char_bonus
B.EQ ir_arriba
cmp x21, char_bonus
B.EQ ir_abajo
cmp x22, char_bonus
B.EQ ir_izquierda
cmp x23, char_bonus
B.EQ ir_derecha
//prioridad 3) tp 
cmp x20, char_tp
B.EQ ir_arriba
cmp x21, char_tp
B.EQ ir_abajo
cmp x22, char_tp
B.EQ ir_izquierda
cmp x23, char_tp
B.EQ ir_derecha
//prioridad 4) vacio
cmp x20, char_vacio
B.EQ ir_arriba
cmp x21, char_vacio
B.EQ ir_abajo
cmp x22, char_vacio
B.EQ ir_izquierda
cmp x23, char_vacio
B.EQ ir_derecha
//prioridad 5) sin salida, empezar backtraking
SUB	    x18, x11, 1
CMP	    x18, x20
b.EQ	    ir_arriba
CMP	    x18, x21
b.EQ	    ir_abajo
CMP	    x18, x22
b.EQ	    ir_izquierda
CMP	    x18, x23
b.EQ	    ir_derecha
//Si no se puede mover a ninguna direccion, se queda en el lugar y limpiamos el laberinto
B limpieza

ir_arriba:
    SUB x5, x6, #16
    B    mover
ir_abajo:
    ADD x5, x6, #16
    B    mover
ir_izquierda:
    SUB x5, x6, #1
    B    mover
ir_derecha:
    ADD  x5, x6, #1
    B    mover

ganar:mov x18, x0
STRB w10, [x5]//mover a la meta y sumar 1 paso
STRB w11, [x6] 
add x1, x1, 1
loopganar: add x18, x18, 0x10
LDURB    w3, [x18]
CMP	    x3, char_j
B.NE	    loopganar

mov x11, 0x4946
STRH    w11, [x18, #6]
mov x11, 0x414E
STRH    w11, [x18, #8]
mov x11, 0x494C
STRH    w11, [x18, #10]
mov x11, 0x415A
STRH    w11, [x18, #12]
mov x11, 0x4F44
STRH    w11, [x18, #14]
// --------------------------------------------------------------------
    
infloop: b infloop
