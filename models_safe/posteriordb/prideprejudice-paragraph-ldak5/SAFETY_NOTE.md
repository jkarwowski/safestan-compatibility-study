# SafeStan Safety Note

Compatibility: major.

Protected data: `w` (the observed word-token indices). `doc`, `V`, `M`, `N`, `alpha`, and `beta` are context/hyperparameter inputs.

Generated files: none.

Reason: the likelihood is a marginalized LDA token likelihood implemented with `target += log_sum_exp(gamma)` inside a loop over tokens, with the latent topic indicator summed out manually. SafeStan forbids arbitrary `target +=` scoring, and replacing this marginalized latent-state calculation with built-in sampling statements would require a substantive model/likelihood rewrite rather than a minor syntactic translation. The parameter priors could be vectorized, but the likelihood cannot be made SafeStan-compatible mechanically while preserving the original normalized log density.
