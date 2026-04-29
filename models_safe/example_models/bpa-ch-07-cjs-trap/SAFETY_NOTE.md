# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the capture-history data variable scored by the likelihood. The model also scores literal `1` pseudo-observations for known survival and eventual non-recapture events.

Generated files: none.

Reason: the likelihood is a Cormack-Jolly-Seber capture-recapture likelihood implemented with data-dependent first/last-capture logic, indexed observations (`y[i, t] ~ ...`) inside loops, and literal-constant sampling statements (`1 ~ bernoulli(...)`). SafeStan requires protected observations to be top-level variables scored exactly once with a plain sampling statement outside loops, and sampling statements may not target literals. Although the implicit uniform priors on bounded parameters could be made explicit mechanically, making the CJS likelihood SafeStan-compatible would require introducing new derived observations or substantially re-expressing the marginalized capture-history likelihood, which is not a minor same-density translation.
