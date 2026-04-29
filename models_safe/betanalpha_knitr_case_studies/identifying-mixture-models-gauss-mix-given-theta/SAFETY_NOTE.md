# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the observed vector scored by the mixture likelihood). `N` is a size and `theta` is a known mixture-weight context input.

Generated files: none.

Reason: the likelihood is a marginalized two-component Gaussian mixture implemented with manual `target += log_mix(...)` scoring inside a loop. SafeStan forbids `target +=`, and there is no equivalent built-in Stan sampling statement for this mixture likelihood. Replacing it would require a substantive model rewrite, such as introducing latent allocation variables or a custom distribution, which is not a minor same-density SafeStan translation.
