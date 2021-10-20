
  .globl solve

  .text

; eax: unsigned int nums[]
; ebx: unsigned int count
solve:
  mov %ebp, %esp      ; save stack pointer
  mov %ecx, %ebx 
  mov %eax, 0
add:
  incr %eax
  loop add

  ret 4

done:
  ret
