# SafeStan Safety Note

Compatibility: major.

Protected data: the response is `earn`, but the model scores the transformed-data variable `log_earn = log(earn)`.

Generated files: none.

Reason: the model is not representable in SafeStan by a minor same-density rewrite. The likelihood is applied to a transformed-data quantity rather than a top-level protected data identifier; making it SafeStan-compatible would require changing the protected interface to a new top-level `log_earn` value or changing the normalized likelihood for `earn`. In addition, both parameters (`beta` and `sigma`) have only implicit improper flat priors, and SafeStan requires each parameter to have exactly one built-in prior before use. Adding proper priors would change the statistical model.
