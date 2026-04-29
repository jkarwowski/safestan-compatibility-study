# SafeStan Safety Note

Compatibility: major.

Protected data: the counting-process event increments derived from `obs_t`, `fail`, and `t` in transformed data.

Generated files: none.

Reason: the likelihood is implemented with manual `target += poisson_lpmf(...)` statements inside nested loops and gated by a data-dependent `if (Y[i, j] != 0)`. Making this SafeStan-compatible would require introducing a new top-level protected representation of the derived counting-process increments and restructuring the risk-set likelihood. That changes the protected data interface from the original top-level survival data (`obs_t`, `fail`) to a derived ragged counting-process object, which is more than a small syntactic rewrite.
