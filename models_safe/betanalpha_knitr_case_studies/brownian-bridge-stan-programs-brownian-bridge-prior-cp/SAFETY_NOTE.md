# SafeStan Safety Note

Compatibility: major.

Protected data: none. The data variables `N`, `ts`, `x_left`, `x_right`, `left_idxs`, `center_idxs`, and `right_idxs` are context inputs; no top-level data variable is observed with a sampling statement.

Generated files: none.

Reason: the model's only stochastic density is a Brownian-bridge prior for `interior_xs` implemented by a looped `target += bridge_lpdf(...)` call through the transformed parameter `xs`. SafeStan forbids `target +=` and user-defined `_lpdf` functions/calls, and parameter priors must be single built-in sampling statements on top-level parameters before use. Translating this conditional bridge-factor algorithm to SafeStan would require deriving or replacing it with an equivalent joint prior or reparameterization, which is a substantive rewrite rather than a minor mechanical change.
