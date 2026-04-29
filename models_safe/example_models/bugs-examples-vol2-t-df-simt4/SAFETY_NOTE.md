# SafeStan Safety Note

Compatibility: as-is.

Protected data: none. The program has no data block and no observed data variables; `y` is a parameter with a built-in prior, not protected data.

Generated files: `model_safe.stan`, `data_safe.json`.

No changes were required. The sole parameter `y` is sampled exactly once with the built-in `student_t` distribution before any other model-block use, and there are no protected observations to score.
