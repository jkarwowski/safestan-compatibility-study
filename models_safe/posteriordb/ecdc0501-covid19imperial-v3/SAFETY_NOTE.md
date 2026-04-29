# SafeStan Safety Note

Compatibility: major.

Protected data: the observed death-count likelihood is applied to the country/day slices `deaths[EpidemicStart[m] : N[m], m]`.

Generated files: none.

Reason: the likelihood scores ragged indexed slices of the top-level `deaths` matrix inside a loop. SafeStan requires protected observations to be scored exactly once with a plain top-level identifier and not inside loops. Making this compatible would require replacing the observed interface with a newly flattened protected vector of selected death counts and re-indexing the dynamic `E_deaths` likelihood accordingly; for this epidemic model that is a substantive data-interface and likelihood-organization rewrite rather than an as-is or small syntactic translation.
