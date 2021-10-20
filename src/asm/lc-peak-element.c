#include "stdint.h"
#include "stdio.h"

int64_t solve(int64_t *nums, int64_t len) {
  int64_t it = 0;
  int64_t max = 0;

  if (0 == len)
    return -1;

  puts("max,nums[it]");

loop:

  printf("%d,%d\n", max, nums[it]);

  if (nums[it] > max) {
    max = nums[it];
  }

  it++;

  if (it < len)
    goto loop;

  return max;
}

int main(void)

{
  int64_t i0[] = {1, 2, 3, 4, 2};
  int64_t i1[] = {1, 2, 3, 2, 5, 6, 4, 2};
  printf("%d:%d\n", 0, solve(i0, 5));
  printf("%d:%d\n", 1, solve(i1, 8));
  return 0;
}
