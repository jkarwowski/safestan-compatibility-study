# SafeStan Safety Note

Compatibility: minor.

Protected data: `t_uncensored`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: `t_uncensored` is the only top-level data variable directly observed with a sampling statement; the sizes, group indices, and `censor_time` are context inputs. The per-element sampling loops were replaced by local scale arrays followed by vectorized built-in sampling statements. This makes the protected observation `t_uncensored` appear exactly once on the left side of a top-level sampling statement and makes the latent parameter `t2_censored` appear exactly once in a top-level prior sampling statement. The additive log-density terms are unchanged. No data fields were added; `data_safe.json` is identical to the supplied data.
