# SafeStan Safety Note

Compatibility: major.

Protected data: none. The program has no observed data variable on the left-hand side of a likelihood sampling statement; `M`, `N`, `x0`, and `X` are context/configuration inputs.

Generated files: none.

Reason: the model block uses `reject("")` inside a loop to impose hard, data-dependent linear inequality constraints on the parameters so that `alpha + deltaX[n,] * beta >= 0` for all observations. SafeStan forbids `reject()`. Preserving this same unnormalized density would require a substantive reparameterization or manual log-density/constraint handling, which is outside a minor SafeStan translation.
