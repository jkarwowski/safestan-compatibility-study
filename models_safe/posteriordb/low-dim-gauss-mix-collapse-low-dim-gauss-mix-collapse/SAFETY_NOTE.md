# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed interface variable; `N` is context/configuration data.

Generated files: none.

Reason: the likelihood for `y` is a collapsed two-component Gaussian mixture implemented by manual `target += log_mix(...)` scoring inside a loop, with indexed reads of `y`. SafeStan forbids arbitrary `target +=` scoring and requires protected data to be scored exactly once via a plain top-level built-in sampling statement. Replacing this marginalized mixture likelihood with SafeStan sampling statements would be a substantive likelihood/model rewrite rather than a minor mechanical translation.
