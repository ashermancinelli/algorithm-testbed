#include <limits>

/*
 *
 * I didn't actually make this an example, this is the code I used to pass the
 * actual leetcode problem to make sure I had the right answer.
 *
 */
class Solution {
public:
    int findPeakElement(vector<int>& _nums) {
        const auto n = _nums.size();
        std::deque<long int> nums(_nums.begin(), _nums.end());
        nums.push_front(std::numeric_limits<long int>::min());
        nums.push_back(std::numeric_limits<long int>::min());
        for(int i=1; i < n+1; i++) {
            if((nums[i] > nums[i-1]) && (nums[i] > nums[i+1]))
                return i-1;
        }
        return -1;
    }
};
