# SafeStan Safety Note

Compatibility: major.

Protected data: `w` (the observed word-token array). The variables `V`, `M`, and `N` are sizes, and `doc` is treated as a context/index variable selecting the document-specific topic proportions.

Generated files: none.

Reason: the word-token likelihood is a collapsed LDA likelihood with the token topic indicators marginalized out, implemented by manually accumulating `target += log_sum_exp(gamma)` inside a loop. SafeStan forbids arbitrary `target +=` scoring, and replacing this marginalized latent-topic calculation with an admissible built-in observation statement would require a substantive likelihood/algorithm rewrite rather than a minor syntactic translation. The indexed Dirichlet prior loops would also need restructuring, but the manual marginalized likelihood is the blocking issue.
