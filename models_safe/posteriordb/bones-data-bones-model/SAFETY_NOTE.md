# SafeStan Safety Note

Compatibility: major.

Protected data: `grade` (specifically, the non-missing skeletal maturity grades; entries equal to `-1` are treated by the original model as missing and are not scored).

Generated files: none.

Reason: the likelihood is implemented by manually adding `target += log(p[i, j, grade[i, j]])` inside nested loops, with an `if (grade[i, j] != -1)` gate for missing values. SafeStan forbids direct `target +=` scoring and requires protected observations to be scored exactly once as a plain top-level variable on the left side of a built-in sampling statement, outside loops. Translating this model would require a substantive rewrite of the varying-category ordered categorical likelihood and missingness handling into a different protected data interface and distribution structure, rather than a small mechanical same-density edit.
