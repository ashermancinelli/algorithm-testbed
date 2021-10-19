# -----------------------------------------------------------------------------
# A 64-bit program that displays its commandline arguments, one per line.
#
# On entry, %rdi will contain argc and %rsi will contain argv.
# -----------------------------------------------------------------------------

        .global main
        .text
main:
  push %rdi
  push %rsi
  sub $8, %rsp

  mov (%rsi), %rdi
  call puts

  add $8, %rsp
  pop %rsi
  pop %rdi

  add $8, %rsi
  dec %rdi
  jnz main

  ret

format:
  .asciz "%s\n"

