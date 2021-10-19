# Taken from:
# https://cs.lmu.edu/~ray/notes/gasexamples/

        .global main
        .text

# This is called by C library's startup code
main:

        # First integer (or pointer) parameter in %rdi
        mov     $message, %rdi

        # puts(message)
        call    puts

        # Return to C library code
        ret

message:
        # asciz puts a 0 byte at the end
        .asciz "Hola, mundo"

