LD=ld -s
ASM=nasm -Wall -f elf64 # -Ox

all: test

hello: clean
	$(ASM) hello.asm
	$(LD) -o $@ hello.o

test: clean
	$(ASM) test.asm
	$(LD) -o $@ test.o

clean:
	rm -f *.o hello test
