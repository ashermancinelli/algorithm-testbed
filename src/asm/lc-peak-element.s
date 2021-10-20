  .global solve
  .text

solve:
  mov $0, %r8
  mov $0, %rax
max:
  mov %rdi, %rax
  ret

done:
  ret

  .data
it: .quad 0
