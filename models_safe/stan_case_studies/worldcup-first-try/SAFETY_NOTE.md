# SafeStan Safety Note

Compatibility: major.

Protected data: the model scores the transformed-data quantity `sqrt_dif`, computed deterministically from `score_1 - score_2`; no SafeStan protected variables are generated for this major case.

Generated files: none.

Reason: the observed quantity on the left side of the likelihood, `sqrt_dif ~ student_t(...)`, is not a top-level data variable. More importantly, parameters `b`, `sigma_a`, and `sigma_y` have no explicit built-in priors before they are used in the likelihood path. Adding priors for these unconstrained or half-constrained parameters would change the posterior density, so this cannot be translated to SafeStan by a minor same-density rewrite.
