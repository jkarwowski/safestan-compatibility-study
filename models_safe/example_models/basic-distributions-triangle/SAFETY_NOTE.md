# SafeStan Safety Note

Compatibility: major.

Protected data: none.

Generated files: none.

Reason: the model has no data likelihood; it defines a custom triangular prior for parameter `y` using `target += log1m(abs(y))`. SafeStan forbids arbitrary `target +=` scoring and requires each parameter to have exactly one built-in prior sampling statement. Preserving this exact custom prior would require a substantive rewrite or a non-built-in distribution, so no minor same-density SafeStan translation is available.
