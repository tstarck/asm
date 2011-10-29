; x86_64 function call

; Usage:
;  $ nasm -f elf64 test.asm
;  $ ld -s -o test test.o

section .data
     txt: db   'input> '
     tln: equ  $-txt
     fun: db   ':-)', 0x0a
     fln: equ  $-fun
     err: db   'err', 0x0a
     eln: equ  $-err
     bsz: dw   8192


section .bss
     buf: resb 8192


section .text
     global _start

prnt:
     push rbp            ; save frame pntr
     mov  ebp, esp

     mov  eax,4          ; sys_write
     mov  ebx,1          ; stdout
     mov  ecx,fun
     mov  edx,fln
     int  80h

     pop  rbp
     ret

_start:
     mov  eax,4          ; sys_write
     mov  ebx,1          ; stdout
     mov  ecx,txt
     mov  edx,tln
     int  80h

     mov  eax,3          ; sys_read
     mov  ebx,2          ; stdin
     mov  ecx,buf
     mov  edx,bsz
     int  80h

     test eax,eax
     js   error          ; jump on error (-1)

     push rcx            ; save rcx & rdx
     push rdx
     call prnt           ; print :-) times 3
     call prnt
     call prnt
     pop  rdx
     pop  rcx

     mov  ebx,1          ; ecx & edx should be set
     mov  eax,4
     int  80h

     mov  ebx,0          ; exit(0)

end: mov  eax,1          ; sys_exit
     int  80h

error:
     mov  eax,4          ; print err msg
     mov  ebx,1
     mov  ecx,err
     mov  edx,eln
     int  80h
     mov  ebx,1          ; exit code 1
     jmp  end
