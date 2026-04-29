# SafeStan Safety Note

Compatibility: major.

Protected data choice: `y` is the observed response scored by the likelihood; `N` is context/size data.

Generated files: none.

Reason: the likelihood for `y` is a marginalized two-component normal mixture implemented with manual `target += log_sum_exp(...)` scoring inside a loop, using `normal_lpdf` terms. SafeStan forbids direct `target +=` manipulation and requires each protected data variable to be observed exactly once with a built-in sampling statement on a plain top-level identifier. Replacing this marginalized mixture with SafeStan-compatible sampling statements would require a substantive model/likelihood rewrite rather than a minor mechanical translation.
