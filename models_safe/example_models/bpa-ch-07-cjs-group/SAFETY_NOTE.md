# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed capture-history variable scored by the original likelihood.

Generated files: none.

Reason: the likelihood scores indexed elements of `y` inside loops and conditionals, after using `y` in `transformed data` to compute `first` and `last`. The model also includes sampling statements with a constant left-hand side, such as `1 ~ bernoulli(...)`, to encode survival and terminal non-capture terms. These are part of a marginalized capture-recapture likelihood rather than ordinary top-level protected observations. Making this SafeStan-compatible would require a substantive likelihood/model rewrite, not a minor same-density syntactic translation. The missing explicit uniform priors for the bounded parameters could be repaired mechanically, but that is not sufficient to address the likelihood structure.
