# SafeStan Safety Note

Compatibility: major.

Protected data: `response` and `RT` are the observed interface variables scored by the trial likelihood.

Generated files: none.

Reason: the likelihood is implemented manually with `target += sum(log_lik)`, where each term is produced by custom functions (`tLBA`, `tLBA_lpdf`, `tLBA_lcdf`, and `tLBA_lccdf`) rather than a built-in Stan distribution. The functions also contain `reject()` calls, which SafeStan forbids. Replacing this custom marginalized LBA likelihood with SafeStan-compatible built-in sampling statements would require a substantive likelihood/model rewrite, not a minor mechanical translation.
