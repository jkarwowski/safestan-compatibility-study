# SafeStan Safety Note

Compatibility: major.

Protected data choice: `obs_times` is the observed event-time interface scored by the hand-written hazard/survival likelihood. `N` is context.

Generated files: none.

Reason: the model uses `target +=` to add survival and hazard contributions involving the latent precursor time `t1 = t1_tilde * obs_times`. SafeStan forbids manual target increments. Replacing these terms with SafeStan sampling statements would require either sampling transformed expressions such as `t1` and `obs_times - t1`, or deriving a marginalized/custom event-time distribution; neither is a minor same-density rewrite using plain top-level built-in sampling statements.
