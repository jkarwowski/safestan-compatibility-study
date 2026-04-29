# SafeStan Safety Note

Compatibility: major.

Protected data: `partyid7`.

Generated files: none.

Reason: the model observes `partyid7` with a top-level built-in normal sampling statement, but the parameters `beta` and `sigma` have no explicit prior sampling statements. SafeStan requires every parameter to have exactly one built-in prior before use. Adding proper priors for the unconstrained `beta` vector or the positive `sigma` parameter would change the posterior/log density, while the original Stan program uses implicit improper flat priors. Therefore this cannot be translated to SafeStan with only a minor same-density rewrite.
