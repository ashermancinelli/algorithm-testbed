#include <thrust-config.hpp>

auto solve(string problem) -> void {
  const int N = problem.size();
  host_vector<int> mapping;
  mapping.reserve(N);
  std::transform(problem.begin(), problem.end(), std::back_inserter(mapping),
                 [=](const char &c) { return c == '(' ? 1 : -1; });
  device_vector<int> d_mapping = mapping;

  // Copy prefix from the input to the prefix array
  device_vector<int> prefixes(N * N);
  vector<int> starts(N - 1);
  std::iota(starts.begin(), starts.end(), 0);
  int max_len = std::accumulate(
      starts.begin(), starts.end(), 0,
      [&prefixes, &d_mapping, N](int max_so_far, int i) {
        thrust::copy(d_mapping.begin() + i, d_mapping.end(),
                     prefixes.begin() + i * N);
        auto prefix_start = prefixes.begin() + i * N;
        auto prefix_end = prefixes.begin() + (i * N) + (N - i);

        thrust::inclusive_scan(thrust::device, prefix_start, prefix_end,
                               prefix_start);

        device_vector<int> indices(N - i);
        thrust::sequence(indices.begin(), indices.end(), 0);

        auto zip_start = thrust::make_zip_iterator(
            thrust::make_tuple(prefix_start, indices.begin()));
        auto zip_end = thrust::make_zip_iterator(
            thrust::make_tuple(prefix_end, indices.end()));

        int max_for_prefix = thrust::transform_reduce(
            zip_start, zip_end,
            [=] __device__(const auto &tup) -> int {
              return thrust::get<0>(tup) == 0 ? 1 + thrust::get<1>(tup) : 0;
            },
            0, thrust::maximum<int>());

        return std::max(max_so_far, max_for_prefix);
      });

  std::cout << "Max = " << max_len << "\n";
}

int main() {
  vector<string> input{
      ")()())",
      "(()",
  };
  for (const auto &problem : input)
    solve(problem);
  return 0;
}
