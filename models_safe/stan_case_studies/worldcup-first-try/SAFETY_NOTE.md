# SafeStan Safety Note

Compatibility: major.

Protected data: the likelihood is applied to `sqrt_dif`, a transformed-data quantity deterministically computed from `score_1` and `score_2`. No SafeStan protected-data interface is generated.

Generated files: none.

Reason: although the transformed observation issue could be handled by a deterministic top-level data augmentation, the parameters `b`, `sigma_a`, and `sigma_y` have no built-in prior sampling statements. SafeStan requires every parameter to be sampled exactly once from a built-in prior before use. Adding proper priors for these unbounded/half-bounded parameters would change the posterior/log density, so this model cannot be translated with only a minor same-density rewrite.
