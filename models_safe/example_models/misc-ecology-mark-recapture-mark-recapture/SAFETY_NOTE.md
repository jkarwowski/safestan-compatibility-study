# SafeStan Safety Note

Compatibility: major.

Protected data: `R` would be the protected observation, because it is the only top-level data variable scored on the left side of a sampling statement. `M` and `C` are context inputs.

Generated files: none.

Reason: the model leaves parameter `N` with an improper default prior on a lower-bounded real and then uses `N` in the likelihood `R ~ binomial(C, M / N)`. SafeStan requires every parameter to have exactly one built-in prior sampling statement before it is used. Adding any proper built-in prior for `N` would change the posterior/log density, while the original improper flat prior cannot be represented as a SafeStan sampling statement. The protected observation `R` also appears in the parameter lower bound before observation, but the improper-prior issue alone prevents a same-density SafeStan translation.
