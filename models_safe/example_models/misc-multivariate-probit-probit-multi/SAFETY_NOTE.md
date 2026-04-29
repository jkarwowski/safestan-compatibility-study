# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the model conditions on the binary response array `y` indirectly in `transformed data` by constructing positive/negative latent-index sets, then uses those sets to constrain and assemble latent variables `z_pos` and `z_neg`. The observed data are not scored by a built-in `y ~ ...` sampling statement. In addition, the multivariate normal sampling statement targets the transformed parameter `z`, not a top-level parameter, while the top-level latent parameters `z_pos` and `z_neg` do not each have a direct SafeStan prior statement.

A SafeStan-compatible same-density rewrite would require replacing this truncated latent multivariate-probit construction with an explicit marginal likelihood for `y` based on multivariate normal orthant probabilities, or otherwise introducing a non-built-in/custom likelihood or manual `target +=` scoring. That is a substantive likelihood/model rewrite rather than a minor mechanical translation.
