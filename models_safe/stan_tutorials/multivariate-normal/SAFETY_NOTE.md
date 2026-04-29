# SafeStan Safety Note

Compatibility: major.

Protected data: `y` is the observed data variable. The model also scores `ry`, which is a transformed-data row-vector copy of `y`; `z`, `sigma`, `N`, and `J` are context/configuration inputs.

Generated files: none.

Reason: the original program is not representable in SafeStan by a minor mechanical rewrite. The protected observation is scored many times, including through indexed left-hand sides such as `y[1]` and through transformed-data quantities such as `ry` and `ry[1]`, whereas SafeStan requires each protected top-level data variable to be observed exactly once with a plain identifier. In addition, `y` is read in `transformed data` before observation, and the unbounded parameters `beta` and `rbeta` have no built-in prior sampling statement before they are used. Adding proper priors or replacing the many repeated/indexed/transformed likelihood factors with a collection of protected copies would be a substantive density/interface rewrite rather than a minor SafeStan translation.
