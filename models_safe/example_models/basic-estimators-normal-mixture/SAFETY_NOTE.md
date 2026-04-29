# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component normal mixture implemented with manual `target += log_mix(...)` scoring and direct `normal_lupdf(...)` calls inside a loop. SafeStan forbids arbitrary `target +=` scoring, and there is no equivalent built-in sampling statement for this marginalized mixture likelihood. Replacing it would require a substantive model rewrite, such as introducing latent component indicators or otherwise changing the likelihood implementation, so no same-density minor translation is produced.
