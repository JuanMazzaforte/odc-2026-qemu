[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/72drL_qt)
# Lab 2 - OdC2026

Este proyecto consiste en el desarrollo de un algoritmo resolvedor de laberintos genérico escrito en ensamblador **ARMv8 (AArch64)**. El sistema se ejecuta de forma *bare-metal* sobre un emulador **QEMU** configurado con una arquitectura tipo `virt` y un procesador **Cortex-A53**.

## 1. Estructura del Proyecto

*   **`main.s`**: Archivo principal que contiene la lógica del programa. Los estudiantes deben implementar el algoritmo dentro de la zona delimitada. Incluye la configuración inicial del *Stack Pointer* (SP) y la carga de la dirección base del laberinto.
*   **`mapa.s`**: Archivo de datos que contiene la definición del laberinto en una sección dedicada (`.maze`). Permite modificar el mapa sin alterar el código fuente principal.
*   **`memmap`**: *Linker Script* que define el mapa de memoria del sistema. Asigna las secciones de código, datos y la pila (stack) en sus direcciones físicas correspondientes.
*   **`Makefile`**: Automatiza los procesos de ensamblado, enlazado y ejecución.
*   **Archivos Generados**:
    *   `kernel.elf`: Binario con símbolos de depuración.
    *   `kernel.img`: Imagen binaria cruda para la carga en QEMU.
    *   `kernel.list`: Desensamblado completo del binario para inspección.
    *   `memory_map.txt`: Mapa de símbolos y secciones generado por el linker.

## 2. Requisitos Previos

Es necesario contar con el toolchain de crosscompiling para AArch64, el emulador QEMU instalados en el sistema y el debugger GDB para arm:

```bash
# En sistemas basados en Debian/Ubuntu
sudo apt update
sudo apt install gcc-aarch64-linux-gnu qemu-system-arm gdb-multiarch
wget -P ~ git.io/.gdbinit
```

## 3. Uso y Compilación

El flujo de trabajo se gestiona íntegramente a través de `make`:

### Compilación
Para ensamblar y enlazar los archivos fuentes:
```bash
make
```

### Ejecución
Para iniciar la emulación en QEMU. El sistema quedará en espera de una conexión de depuración (GDB) en el puerto `1234`:
```bash
make runQEMU
```

### Depuración
En una segunda terminal, inicie la interfaz de depuración. Esta versión utiliza `gdb-multiarch` junto con `gdb-dashboard` para visualizar registros y memoria en tiempo real:
```bash
make runGDB
```

### Limpieza
Para eliminar los binarios y archivos temporales generados:
```bash
make clean
```

## 4. Especificaciones Técnicas

### Mapa de Memoria
El sistema utiliza el siguiente esquema de direccionamiento definido en el *Linker Script*:

| Sección | Dirección de Inicio | Descripción |
| :--- | :--- | :--- |
| **.text** | `0x40080000` | Código ejecutable del programa. |
| **.maze** | `0x40081000` | Datos del laberinto (Cargado en `x0`). |
| **.data** | Inmediato tras `.maze` | Variables inicializadas (como `estado`). |
| **Stack** | `0x40480000` | Tope de la pila (crece hacia direcciones menores). |

### Restricciones de Implementación
*   **Registros Críticos**: 
    *   `x0`: Dirección base del laberinto (No modificar).
    *   `x1`: Contador de pasos realizados (Debe persistir).
*   **Tamaño Máximo**: El binario (excluyendo el laberinto) no debe superar los **4KB**.
*   **Modularidad**: No se permite la subdivisión del código en múltiples archivos más allá de la estructura provista.

## 5. Depuración con GDB Dashboard
Al ejecutar `make runGDB`, se cargarán automáticamente los símbolos del archivo `kernel.elf`. Se recomienda prestar especial atención a los siguientes comandos dentro de GDB:
*   `stepi` o `si`: Ejecutar una instrucción de ensamblador.
*   `continue` o `c`: Ejecutar hasta el próximo breakpoint o hasta el final.
*   El panel **Memory Watch** está configurado para monitorear la dirección `0x40081000`, permitiendo observar el movimiento de la `X` y el cambio en el estado del juego.
---
