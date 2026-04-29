# SafeStan Safety Note

Compatibility: major.

Protected data: `goal_difference`.

Generated files: none.

Reason: the likelihood scores indexed observations inside a loop using the user-defined distribution `zero_inflated_skellam`. SafeStan sampling statements for protected data must observe a top-level protected variable exactly once with a plain identifier on the left-hand side and must resolve to a built-in Stan distribution. Preserving this zero-inflated Skellam likelihood would require a substantive rewrite using custom log-density calculations or a new distribution path, which is outside the SafeStan-compatible subset.
