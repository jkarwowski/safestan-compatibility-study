# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes `y` with `y ~ normal(theta, 1)`, so `y` is the protected interface. Although the transformed-data use `abs(y)` could be handled mechanically with a deterministic data copy, the parameter `theta` is an unconstrained real parameter with no explicit prior. SafeStan requires every parameter to have exactly one built-in prior sampling statement before use. Adding any proper prior for `theta` would change the posterior/log density, and the original improper flat prior cannot be represented as a SafeStan built-in prior sampling statement.
