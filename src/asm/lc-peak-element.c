#include <stdio.h>

/*
 * Driver program for lc-peak-element so only the core function must be in asm
 */

int solve(int nums[], int c);

int main(int argc, char** argv) {
  int i0[] = {1, 2, 3, 4, 2};
  printf("%d: %d\n", 0, solve(i0, 5));
  return 0;
}
