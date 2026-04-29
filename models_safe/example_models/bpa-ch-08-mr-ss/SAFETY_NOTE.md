# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the capture-history data used to determine the observed recovery/last-capture outcome).

Generated files: none.

Reason: the likelihood is not expressed as a direct built-in distribution over a top-level observed data variable. The program first inspects `y` in `transformed data` to compute `first` and `last`, uses those summaries to build parameter-dependent probabilities, and then scores a literal constant with `1 ~ bernoulli(pr)` inside a loop and conditional. SafeStan requires the protected observation to be scored exactly once as a plain top-level identifier before any other use, and protected observation statements cannot be inside loops. Replacing this with a SafeStan-compatible likelihood would require introducing derived outcome variables or a categorical representation of the capture-history summaries, which changes the protected data interface and is a substantive likelihood/interface rewrite rather than a minor mechanical translation.
