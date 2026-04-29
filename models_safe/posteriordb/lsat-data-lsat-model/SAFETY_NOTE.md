# SafeStan Safety Note

Compatibility: minor.

Protected data: `pattern_id`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model builds an expanded response matrix `r` in `transformed data` and then observes indexed rows of `r` inside a loop. SafeStan requires protected observations to be top-level data variables and to be observed once with a plain sampling statement. The rewritten model replaces the compressed cumulative-count encoding by a deterministic top-level protected vector `pattern_id`, where `pattern_id[j] = i` iff `culm[i - 1] < j <= culm[i]` with `culm[0] = 0`. The original `response` table is retained as context defining the binary response pattern for each category.

The likelihood is rewritten as one vectorized `categorical_logit` statement. For each student and each response pattern, the categorical logit is the joint Bernoulli-logit log probability of that pattern under the original Rasch item model. Because the LSAT source model uses `response` as the fixed table of all `2^T` response patterns, the categorical normalizer is one, so this is the same likelihood as the original product of Bernoulli-logit item terms. The original parameter priors were already explicit and are unchanged.
