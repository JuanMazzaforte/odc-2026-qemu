ARMGNU ?= aarch64-linux-gnu

AOPS = -g --warn --fatal-warnings
ASM_SRCS = $(wildcard *.s)
ASM_OBJS = $(ASM_SRCS:%.s=%.o)

.PHONY: clean

all: kernel.img

%.o: %.s
	$(ARMGNU)-as $(AOPS) $< -o $@

clean:
	rm -f *.o memory_map.txt kernel.list kernel.img kernel.elf

kernel.img: memmap $(ASM_OBJS)
	$(ARMGNU)-ld $(ASM_OBJS) -T memmap -o kernel.elf -M > memory_map.txt
	$(ARMGNU)-objdump -D kernel.elf > kernel.list
	$(ARMGNU)-objcopy kernel.elf -O binary kernel.img

runQEMU: kernel.img
	qemu-system-aarch64 -s -S -machine virt -cpu cortex-a53 -machine type=virt -nographic -smp 1 -m 64 -kernel kernel.img


runGDB:
	gdb-multiarch -ex "set confirm off" -ex "set architecture aarch64" -ex "target remote localhost:1234" --ex "dashboard registers -style list 'x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 sp pc cpsr'" -ex "dashboard memory watch 0x0000000040081000 128" -ex "file kernel.elf" 
