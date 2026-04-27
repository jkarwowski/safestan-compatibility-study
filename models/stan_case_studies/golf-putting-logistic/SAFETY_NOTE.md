# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the protected observations are already used in a plain vectorized sampling statement, `y ~ binomial(n, p)`, and are not read before observation. However, the only parameter, `sigma`, has no explicit proper prior; the original model relies on an implicit improper uniform prior on `<lower=0>`. Adding a proper prior would change the posterior/log density, so this cannot be translated to SafeStan by an as-is or minor same-density rewrite.
