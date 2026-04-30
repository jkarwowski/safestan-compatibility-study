# SafeStan Safety Note

Compatibility: minor.

Protected data: `expression`.

Generated files: `model_safe.stan`, `data_safe.json`.

Manual update (2026-04-30): Manual SafeStan rewrite: replaced invalid local constrained vector syntax with an unconstrained local sigma vector, kept protected `expression` in one vectorized truncated-normal likelihood, and updated generated log likelihood to use the matching truncation normalizer.
