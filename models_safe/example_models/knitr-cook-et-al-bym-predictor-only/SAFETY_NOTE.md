# SafeStan Safety Note

Compatibility: major.

Protected data: `y`.

Generated files: none.

Reason: the observed likelihood is `y ~ poisson_log(...)`, but the model also contains a manual spatial prior/penalty, `target += -0.5 * dot_self(phi[node1] - phi[node2]);`. SafeStan forbids arbitrary `target +=` scoring, and the corresponding top-level parameter `phi_std_raw` has no built-in prior sampling statement. Replacing this CAR/ICAR-style penalty with built-in sampling statements would require a substantive prior/density rewrite rather than a minor mechanical translation. The existing parameter-prior ordering could be mechanically changed, but the manual spatial target increment prevents a SafeStan-compatible same-density version.
