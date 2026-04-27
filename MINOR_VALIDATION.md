# SafeStan Minor Validation

Generated: 2026-04-27T18:47:02+00:00

This report validates models previously classified as `MINOR` candidates by creating explicit `model_safe.stan` files where a conservative same-density rewrite is available and, when enabled, running original plain mode vs safe mode through `cmdsafestan`.

## Summary

- Candidate MINOR models: `7`
- `model_safe.stan` generated/present: `7`
- `same-lp`: `7`

## Results

| Model | Data | Protect | Safe file | Validation | lp__ diff | Transform notes |
|---|---|---|---|---|---:|---|
| [Binary Trials No Pooling](models/stan_case_studies/binary-trials-no-pool/) | `upstream` | `y` | `yes` | `same-lp` | `0` | duplicated 1 protected data variable(s) for transformed data; added explicit uniform(0, 1) prior(s) for theta |
| [Binary Trials Complete Pooling](models/stan_case_studies/binary-trials-complete-pool/) | `upstream` | `y` | `yes` | `same-lp` | `0` | duplicated 1 protected data variable(s) for transformed data; added explicit uniform(0, 1) prior(s) for phi |
| [Binary Trials Hierarchical](models/stan_case_studies/binary-trials-hierarchical/) | `upstream` | `y` | `yes` | `same-lp` | `0` | duplicated 1 protected data variable(s) for transformed data; added explicit uniform(0, 1) prior(s) for phi |
| [Binary Trials Hierarchical Logit](models/stan_case_studies/binary-trials-hier-logit/) | `upstream` | `y` | `yes` | `same-lp` | `0` | duplicated 1 protected data variable(s) for transformed data; no missing bounded [0,1] parameter priors |
| [Soil Incubation ODE](models/stan_case_studies/soil-incubation-ode/) | `upstream` | `eCO2mean` | `yes` | `same-lp` | `0` | vectorized 1 protected-data likelihood loop(s); no missing bounded [0,1] parameter priors |
| [Rat Growth](models/forestdb/rat-growth/) | `upstream` | `y_flat` | `yes` | `same-lp` | `0` | flattened matrix y into protected vector y_flat |
| [Geometric Distribution](models/forestdb/geometric-distribution/) | `upstream` | `y_failures` | `yes` | `same-lp` | `0` | promoted zero-based failure counts to protected data y_failures |
