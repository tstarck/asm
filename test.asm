; x86_64 function call

; Usage:
; $ nasm -f elf64 test.asm
; $ ld -s -o test test.o

section .data
      txt:  db     'input> '
      tln:  equ    $-txt

      fun:  db     ':-)',0x0a
      fln:  equ    $-fun
      err:  db     'err',0x0a
      eln:  equ    $-err
      bsz:  dw     8192


section .bss
      buf: resb 8192


section .text
      global _start

prnt:
      push  rbp   ; save frame pntr
      mov   ebp, esp

      mov   eax, 4   ; sys_write
      mov   ebx, 1   ; stdout
      mov   ecx, fun
      mov   edx, fln
      int   80h

      pop   rbp
      ret

_start:
      mov   eax, 4      ; sys_write
      mov   ebx, 1      ; stdout
      mov   ecx, txt
      mov   edx, tln
      int   80h

      mov   eax, 3      ; sys_read
      mov   ebx, 2      ; stdin
      mov   ecx, buf
      mov   edx, bsz
      int   80h

      test  eax, eax
      js    error       ; jump on error (-1)

      sub   eax, 1
      mov   ecx, 0
      mov   esi, buf
loop: mov   edx, [esi]
      sub   edx, 48
      add   esi, 1
      imul  ecx, 10
      add   ecx, edx
      sub   eax, 1
      test  eax, eax
      jnz   loop

      ; ;
      ; push rcx   ; save rcx
      ; call prnt  ; print :-)
      ; pop  rcx
      ; ;

      mov   ebx, ecx    ; exit with ecx

end:  mov   eax, 1      ; sys_exit
      int   80h

error:
      mov   eax, 4      ; print err msg
      mov   ebx, 1
      mov   ecx, err
      mov   edx, eln
      int   80h
      mov   ebx, 1      ; exit code 1
      jmp   end
