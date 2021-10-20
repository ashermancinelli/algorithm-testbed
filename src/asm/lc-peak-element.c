#include <stdio.h>
#include <inttypes.h>


/*
 * Driver program for lc-peak-element so only the core function must be in asm
 */

int64_t solve(int64_t nums[], int64_t c);

int main(int64_t argc, char** argv) {
  int64_t i0[] = {1, 2, 3, 4, 2};

  printf("%d: %d\n", 0, solve(i0, 5));
  return 0;
}
