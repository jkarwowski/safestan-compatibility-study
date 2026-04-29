# SafeStan Safety Note

Compatibility: minor.

Protected data: `cases`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the protected observation `cases` was already a top-level data variable scored exactly once by the built-in likelihood `poisson_log`. The looped, indexed priors for `beta` were rewritten as one equivalent built-in `multi_normal_cholesky` prior on a vector-valued `beta`. The Cholesky factor is constructed so that it represents exactly the same second-order random-walk prior density as the original sequence of normal conditional priors. No data fields were added or changed.
