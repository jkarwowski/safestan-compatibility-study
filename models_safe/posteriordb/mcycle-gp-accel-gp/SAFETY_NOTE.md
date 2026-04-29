# SafeStan Safety Note

Compatibility: major.

Protected data choice: `Y` is the response variable scored by the likelihood.

Generated files: none.

Reason: the likelihood is conditionally gated by the top-level data flag `prior_only`:

```stan
if (!prior_only) {
  target += normal_lpdf(Y | mu, sigma);
}
```

SafeStan requires each protected observation to be scored exactly once by a built-in sampling statement, and protected-observation sampling cannot be controlled by an `if` whose branches have different sampling effects. Replacing this with an unconditional `Y ~ normal(mu, sigma);` would change the model semantics when `prior_only` is nonzero. The remaining `target +=` prior statements and parameter-use ordering would be mechanically rewritable, but the conditional likelihood gate prevents a same-model SafeStan translation.
