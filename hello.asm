; Hello world

section .data
     hwo: db   'Hello world.', 0x0a
     len: equ  $-hwo

section .text
     global _start

_start:
     mov  eax,4
     mov  ebx,1
     mov  ecx,hwo
     mov  edx,len
     int  80h

     mov  eax,1
     mov  ebx,0
     int  80h
