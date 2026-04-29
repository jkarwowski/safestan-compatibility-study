# SafeStan Safety Note

Compatibility: minor.

Protected data: `obs`.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the count likelihood was vectorized so that the protected observation `obs` is scored exactly once with a plain left-hand-side sampling statement. The parameter priors were reordered so hyperparameters are sampled before use, and an explicit `sd_alpha ~ uniform(0, 5)` prior was added for the already finite-bounded scale parameter. The SafeStan data file omits the original context arrays `obsyear` and `obssite`; for this BPA data they are deterministically reconstructed in `transformed data` by enumerating all `(year, site)` pairs in increasing year/site order and excluding the pairs listed by `misyear`/`missite`. No protected value is read before its likelihood statement.
