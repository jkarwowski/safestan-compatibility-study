# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed data likelihood is `y ~ poisson_log(...)`, so `y` is the protected interface variable. However, the model also contains an arbitrary prior contribution for the spatial effect,

```stan
target += -0.5 * dot_self(phi[node1] - phi[node2]);
```

SafeStan forbids `target +=` and requires each parameter to have exactly one built-in prior sampling statement before use. This CAR/ICAR-style spatial prior on pairwise differences cannot be mechanically expressed as a SafeStan-compatible built-in sampling statement on the top-level parameter `phi_std_raw` without changing the density, normalization, or model structure. Therefore a same-posterior SafeStan translation would require a substantive model rewrite.
