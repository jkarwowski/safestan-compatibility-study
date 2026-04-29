# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood observes the top-level data variable `y` with `y ~ normal(theta, 1)`, so `y` is the protected interface. Although the transformed-data use `abs(y)` could be handled mechanically, the parameter `theta` has no prior sampling statement. SafeStan requires each parameter to have exactly one built-in prior before use, and adding a proper prior for an unconstrained real parameter would change the original posterior/log density. Therefore no same-density SafeStan translation is produced.
