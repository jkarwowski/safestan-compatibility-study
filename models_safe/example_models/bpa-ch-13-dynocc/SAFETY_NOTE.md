# SafeStan Safety Note

Compatibility: major.

Protected data: `y` (the detection history; the model uses the deterministic counts `sum_y` derived from `y`).

Generated files: none.

Reason: the likelihood is a marginalized hidden Markov dynamic occupancy likelihood implemented with a manual forward algorithm and `target += log(sum(gam[nyear]))`. SafeStan forbids arbitrary `target +=` scoring, and replacing this with permitted built-in sampling statements would require a substantive HMM/latent-state likelihood rewrite rather than a minor same-density translation.
