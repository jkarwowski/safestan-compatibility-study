# SafeStan Safety Note

Compatibility: major.

Protected data: `test_pos`.

Generated files: none.

Reason: the likelihood for `test_pos` is a marginalized latent-disease model implemented by manually accumulating Bernoulli log probabilities and adding `target += log_sum_exp(lp_disease, lp_no_disease)`. SafeStan forbids `target +=` and `_lpmf` calls, and there is no equivalent single built-in sampling statement for the induced correlated mixture distribution over the whole test-result vector. Introducing an explicit disease state would require a substantive model rewrite with a discrete latent variable, which Stan cannot sample directly, or would change the likelihood. Therefore this model cannot be translated with only minor same-density changes.
