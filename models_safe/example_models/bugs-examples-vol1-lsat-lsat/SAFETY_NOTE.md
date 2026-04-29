# SafeStan Safety Note

Compatibility: major.

Protected data: the expanded binary response matrix `r` that the original program constructs in `transformed data` from `response` and `culm` and then scores with Bernoulli-logit likelihood statements.

Generated files: none.

Reason: the original likelihood is applied to `r`, which is not a top-level data variable but a transformed-data expansion of compressed response-pattern data. Making this SafeStan-compatible would require moving that expansion to the top-level data interface and rewriting the looped, indexed likelihood into one or more top-level protected sampling statements. That changes the protected interface from the supplied compressed data (`response`, `culm`) to an expanded deterministic observation array, so it is not an as-is SafeStan program. A faithful SafeStan representation would require a substantial data-interface rewrite rather than a small syntactic repair of the existing model.
