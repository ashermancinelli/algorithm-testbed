add_example(NAME "asm-dep-check" SOURCES test.s DEPENDS HAS_ASM)
add_example(NAME "asm-echo" SOURCES echo.s DEPENDS HAS_ASM)
#add_example(
#  NAME
#  "lc-peak-element-asm"
#  TYPE
#  ASM
#  SOURCES
#  lc-peak-element-driver.c
#  lc-peak-element.s
#  DEPENDS
#  HAS_ASM
#)
add_example(
  NAME
  "factorial-asm"
  TYPE
  ASM
  SOURCES
  fac.c
  fac.s
  DEPENDS
  HAS_ASM
)
add_example(NAME "lc-peak-element-c" SOURCES lc-peak-element.c)
