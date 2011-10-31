; asm: print zeros and ones

%ifidn __OUTPUT_FORMAT__, elf32
  %define .bp ebp
  %define .cx ecx

%elifidn __OUTPUT_FORMAT__, elf64
  %define .bp rbp
  %define .cx rcx

%else
  %fatal -f elf32 or elf64 required!

%endif


section .data
      buffersz:   db    255

      inputmsg:   db    'input> '
      inputlen:   equ   $-inputmsg

      errormsg:   db    'error.',0x0a
      errorlen:   equ   $-errormsg

      dot:        db    '.'
      dotsz:      equ   $-dot

section .bss
      buffer:     resb  255


section .text
      global _start

error:
      mov   eax, 4            ; print err msg
      mov   ebx, 1
      mov   ecx, errormsg
      mov   edx, errorlen
      int   80h
      mov   eax, 1            ; sys_exit
      mov   ebx, 1            ; exit code 1
      int   80h

prntrow:
      push  rbp               ; save frame pntr
      mov   ebp, esp

      mov   eax, 4            ; sys_write
      mov   ebx, 1            ; stdout
      mov   ecx, dot
      mov   edx, dotsz
      int   80h

      pop   rbp
      ret

_start:
      mov   eax, 4            ; sys_write
      mov   ebx, 1            ; stdout
      mov   ecx, inputmsg
      mov   edx, inputlen
      int   80h

      mov   eax, 3            ; sys_read
      mov   ebx, 2            ; stdin
      mov   ecx, buffer
      mov   edx, buffersz
      int   80h

      test  eax, eax
      js    error             ; jump on error (-1)

      mov   ecx, 0            ; ecx is next used as
                              ; exit code or counter

      sub   eax, 1
      test  eax, eax
      jz    quit              ; no input given :-(

      mov   esi, buffer
nextint:
      mov   dl,  byte [esi]   ; take a byte
      add   esi, 1            ; (*buffer)++

      sub   dl,  48
      imul  ecx, 10
      add   cl,  dl

      sub   eax, 1            ; if there's
      test  eax, eax          ; more to read,
      jnz   nextint           ; read more

nextrow:
      jecxz quit
      push  .cx
      call  prntrow
      pop   .cx
      sub   ecx, 1
      ; jmp   nextrow

quit: mov   ebx, ecx          ; exit(ecx)
      mov   eax, 1
      int   80h
