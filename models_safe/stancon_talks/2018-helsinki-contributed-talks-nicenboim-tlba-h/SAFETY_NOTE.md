# SafeStan Safety Note

Compatibility: major.

Protected data choice: `response` and `RT` are the observed interface variables used in the LBA likelihood.

Generated files: none.

Reason: the likelihood is a custom linear ballistic accumulator density computed through user-defined `_lpdf`, `_lcdf`, and `_lccdf` functions and added manually with `target += sum(log_lik)`. SafeStan forbids manual `target +=` likelihood contributions, `reject()` calls, and user-defined log-density paths for protected observations. Replacing this with SafeStan-compatible built-in sampling statements would require a substantive change to the statistical model, not a minor mechanical rewrite. Additionally, `RT` is used in transformed data and parameter constraints before observation, which would require further interface restructuring even if the likelihood were otherwise expressible.
