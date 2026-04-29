# SafeStan Safety Note

Compatibility: minor.

Protected data: `history_first1` and `history_first2`, deterministic reshapes of the scored parts of the original `history` count vector.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: replaced the hand-written `target +=` CJS count likelihood with two built-in `multinomial` observations. The data were reshaped as `history_first1 = [history[4], history[5], history[6], history[7]]`, `history_first2 = [history[2], history[3]]`, and `history_noinfo = history[1]`; `history_noinfo` is retained only as an unmodelled context value because the original program states that `history[1]` provides no information. The multinomial form is the normalized built-in count likelihood and matches the original parameter-dependent log likelihood up to data-only multinomial coefficients. Added `phi ~ uniform(0, 1)` and `p ~ uniform(0, 1)`, which are density-neutral for the existing finite `[0, 1]` parameter bounds and satisfy SafeStan's unique-prior requirement.
