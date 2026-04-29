# SafeStan Safety Note

Compatibility: major.

Protected data: the original likelihood scores `w`, the transition observations in `z` (as `z[t]` for `t >= 2`), and the unsupervised word sequence `u`.

Generated files: none.

Reason: the unsupervised HMM likelihood for `u` is implemented by a forward algorithm ending in `target += log_sum_exp(gamma[T_unsup])`. SafeStan forbids manual `target +=` scoring, and replacing this marginalized latent-state algorithm with built-in sampling statements would require a substantive model rewrite rather than a minor same-density translation. The looped/indexed supervised sampling statements and parameter priors could potentially be mechanically rewritten, but the marginalized HMM likelihood is not SafeStan-compatible.
