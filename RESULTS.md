# SafeStan Compatibility Results

Generated: 2026-04-27T17:56:10+00:00

This is a compiler-level SafeStan audit of the original `model.stan` files plus a manual same-result transplant assessment for rejected models.
The `MINOR` class is a candidate label unless the Validation column shows a passing original-vs-safe run comparison.

## Legend

- `AS-IS`: compiles with SafeStan as written.
- `MINOR`: candidate same-result SafeStan transplant requiring explicit validation.
- `MAJOR`: needs substantial or density-changing rewrite.

## Compiler

- SafeStan stanc: `/private/tmp/cmdsafestan/safestan/_build/default/src/stanc/stanc.exe`
- cmdsafestan revision: `1484306735d3994ab841bb997c987097e0066605`
- safestan/stanc revision: `12203ecc4294eb63a2c05170ca2bcfa3944bf574`

## Summary

- Total models: `45`
- `AS-IS`: `11`
- `MINOR`: `7`
- `MAJOR`: `27`

| Source | AS-IS | MINOR | MAJOR | Total |
|---|---:|---:|---:|---:|
| Stan tutorials | 3 | 0 | 12 | 15 |
| Stan case studies | 3 | 5 | 7 | 15 |
| ForestDB translations | 5 | 2 | 8 | 15 |

## Minor Validation Summary

- Candidate `MINOR` models: `7`
- `model_safe.stan` generated and SafeStan-compiled: `7`
- `same-lp`: `7`

## Model Results

| Source | Model | Data | Protected data | Status | Compiler result | Validation | Reason / transplant note |
|---|---|---|---|---|---|---|---|
| Stan tutorials | [Bernoulli Estimator](models/stan_tutorials/bernoulli/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| Stan tutorials | [Normal Location](models/stan_tutorials/normal-location/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Observed values live in transformed data and the unbounded mean has no proper prior. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan tutorials | [Truncated Normal](models/stan_tutorials/truncated-normal/) | `upstream` | `y` | `MAJOR` | `fail` | - | Uses indexed/truncated likelihood and unbounded parameters without proper priors. Compiler: SStan violation: sampling statement left-hand side must be a plain identifier (no indexing, projection, or expression). |
| Stan tutorials | [Censored Normal](models/stan_tutorials/censored-normal/) | `upstream` | `y` | `MAJOR` | `fail` | - | Requires a censored-data target/lccdf contribution and lacks a proper prior for mu. Compiler: SStan violation: direct `target +=` adjustments are forbidden in --sstanc mode. |
| Stan tutorials | [Multivariate Normal](models/stan_tutorials/multivariate-normal/) | `upstream` | `y` | `MAJOR` | `fail` | - | Distribution-signature stress test with repeated/partial observations, not a single protected likelihood. Compiler: SStan violation: protected data referenced in transformed data before observation: y. |
| Stan tutorials | [Negative Binomial](models/stan_tutorials/negative-binomial/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| Stan tutorials | [Negative Binomial 2](models/stan_tutorials/negative-binomial2/) | `upstream` | `y` | `MAJOR` | `fail` | - | Alpha has an implicit improper prior that SafeStan cannot express without changing the density. Compiler: SStan violation: parameter used before its unique prior statement: alpha. |
| Stan tutorials | [Normal Mixture](models/stan_tutorials/normal-mixture/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan tutorials | [K-Component Normal Mixture](models/stan_tutorials/k-component-normal-mixture/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan tutorials | [K-Component Normal Mixture with Simplex Weights](models/stan_tutorials/k-component-normal-mixture-simplex/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan tutorials | [Simple Regression](models/stan_tutorials/simple-regression/) | `upstream` | `y` | `MAJOR` | `fail` | - | Regression coefficients and scale have implicit improper priors. Compiler: SStan violation: parameter used before its unique prior statement: a, b, sigma. |
| Stan tutorials | [Vector Regression](models/stan_tutorials/vector-regression/) | `upstream` | `y` | `MAJOR` | `fail` | - | Regression coefficients and scale have implicit improper priors. Compiler: SStan violation: parameter used before its unique prior statement: b, sigma. |
| Stan tutorials | [Two-Parameter Logistic IRT](models/stan_tutorials/two-parameter-logistic-irt/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| Stan tutorials | [2PL Regression Centered](models/stan_tutorials/two-pl-regression-centered/) | `upstream` | `y` | `MAJOR` | `fail` | - | Gamma has an implicit improper prior and item/person priors need nontrivial restructuring. Compiler: SStan violation: sampling statement left-hand side must be a plain identifier (no indexing, projection, or expression). |
| Stan tutorials | [2PL Regression Noncentered](models/stan_tutorials/two-pl-regression-noncentered/) | `upstream` | `y` | `MAJOR` | `fail` | - | Gamma has an implicit improper prior and is used before any SafeStan prior statement. Compiler: SStan violation: parameter used before its unique prior statement: gamma. |
| Stan case studies | [Golf Putting Logistic](models/stan_case_studies/golf-putting-logistic/) | `upstream` | `y` | `MAJOR` | `fail` | - | Scale parameter has an implicit improper prior. Compiler: SStan violation: parameter used before its unique prior statement: sigma. |
| Stan case studies | [World Cup First Try](models/stan_case_studies/worldcup-first-try/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Likelihood is derived from protected scores in transformed data and several parameters have implicit improper priors. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan case studies | [World Cup No Square Root](models/stan_case_studies/worldcup-no-sqrt/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Likelihood is derived from protected scores in transformed data and several parameters have implicit improper priors. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan case studies | [World Cup Fixed](models/stan_case_studies/worldcup-fixed/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Likelihood is derived from protected scores in transformed data and several parameters have implicit improper priors. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan case studies | [World Cup with Replication](models/stan_case_studies/worldcup-replication/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Likelihood is derived from protected scores in transformed data and several parameters have implicit improper priors. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan case studies | [World Cup No Prior](models/stan_case_studies/worldcup-no-prior/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Intentionally omits priors, which SafeStan strict parameter discipline rejects. Compiler: No top-level protected-data likelihood candidate was inferred. |
| Stan case studies | [Binary Trials No Pooling](models/stan_case_studies/binary-trials-no-pool/) | `upstream` | `y` | `MINOR` | `fail` | `same-lp` | Move protected-data summary statistics out of transformed data or pass them as separate data; add explicit uniform(0, 1) prior for bounded theta. Compiler: SStan violation: protected data referenced in transformed data before observation: y. |
| Stan case studies | [Binary Trials Complete Pooling](models/stan_case_studies/binary-trials-complete-pool/) | `upstream` | `y` | `MINOR` | `fail` | `same-lp` | Move protected-data summary statistics out of transformed data or pass them as separate data; add explicit uniform(0, 1) prior for bounded theta. Compiler: SStan violation: protected data referenced in transformed data before observation: y. |
| Stan case studies | [Binary Trials Hierarchical](models/stan_case_studies/binary-trials-hierarchical/) | `upstream` | `y` | `MINOR` | `fail` | `same-lp` | Move protected-data summary statistics out of transformed data or pass them as separate data; model priors and likelihood are otherwise SafeStan-shaped. Compiler: SStan violation: protected data referenced in transformed data before observation: y. |
| Stan case studies | [Binary Trials Hierarchical Logit](models/stan_case_studies/binary-trials-hier-logit/) | `upstream` | `y` | `MINOR` | `fail` | `same-lp` | Move protected-data summary statistics out of transformed data or pass them as separate data; model priors and likelihood are otherwise SafeStan-shaped. Compiler: SStan violation: protected data referenced in transformed data before observation: y. |
| Stan case studies | [Binary Trials Hierarchical Logit Centered](models/stan_case_studies/binary-trials-hier-logit-centered/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| Stan case studies | [SIR ODE](models/stan_case_studies/sir-ode/) | `upstream` | `stoi, B` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| Stan case studies | [One-Compartment Michaelis-Menten ODE](models/stan_case_studies/one-compartment-mm-ode/) | `upstream` | `C` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| Stan case studies | [Soil Incubation ODE](models/stan_case_studies/soil-incubation-ode/) | `upstream` | `eCO2mean` | `MINOR` | `fail` | `same-lp` | Vectorize the indexed likelihood to a single `eCO2mean ~ normal(...)` statement. Compiler: SStan violation: sampling statement left-hand side must be a plain identifier (no indexing, projection, or expression). |
| Stan case studies | [BYM2 Spatial Poisson](models/stan_case_studies/bym2-spatial-poisson/) | `upstream` | `y` | `MAJOR` | `fail` | - | Uses a user-defined ICAR distribution and an improper spatial prior. Compiler: SStan violation: parameter used before its unique prior statement: alpha, beta. |
| ForestDB translations | [Inferences with Binomials](models/forestdb/binomial-inference/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| ForestDB translations | [Inferences with Gaussians](models/forestdb/gaussian-inference/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| ForestDB translations | [1D Gaussian with Gaussian/Gamma Hyperparameters](models/forestdb/gaussian-gamma/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| ForestDB translations | [Bayesian Linear Regression](models/forestdb/linear-regression/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| ForestDB translations | [Bayesian Logistic Regression](models/forestdb/logistic-regression/) | `upstream` | `y` | `AS-IS` | `pass` | - | Compiled with SafeStan using the inferred protected data variables. |
| ForestDB translations | [Finite Mixture Model](models/forestdb/finite-mixture/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`. Compiler: No top-level protected-data likelihood candidate was inferred. |
| ForestDB translations | [Finite Gaussian Mixture](models/forestdb/finite-gaussian-mixture/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Core likelihood is a marginalized mixture implemented with `target += log_mix(...)`. Compiler: No top-level protected-data likelihood candidate was inferred. |
| ForestDB translations | [Finite Dirichlet-Multinomial Mixture](models/forestdb/dirichlet-multinomial-mixture/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Requires custom Dirichlet-multinomial mixture scoring via `target += log_sum_exp(...)`. Compiler: No top-level protected-data likelihood candidate was inferred. |
| ForestDB translations | [Markov Model](models/forestdb/markov-model/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Sequential likelihood is accumulated manually with protected observations in the recursion. Compiler: No top-level protected-data likelihood candidate was inferred. |
| ForestDB translations | [Discrete-Time Hidden Markov Model](models/forestdb/hidden-markov-model/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Hidden-state forward algorithm requires manual `target += log_sum_exp(...)` scoring. Compiler: No top-level protected-data likelihood candidate was inferred. |
| ForestDB translations | [Rat Growth](models/forestdb/rat-growth/) | `upstream` | `y` | `MINOR` | `fail` | `same-lp` | Flatten the repeated-measures matrix into a protected vector and vectorize the likelihood. Compiler: SStan violation: sampling statement left-hand side must be a plain identifier (no indexing, projection, or expression). |
| ForestDB translations | [Geometric Distribution](models/forestdb/geometric-distribution/) | `upstream` | `y` | `MINOR` | `fail` | `same-lp` | Pass zero-based failure counts as a top-level protected data variable instead of deriving them from protected data in transformed data. Compiler: SStan violation: protected data referenced in transformed data before observation: y. |
| ForestDB translations | [Medical Diagnosis](models/forestdb/medical-diagnosis/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Latent disease marginalization is implemented by manual `target += log_sum_exp(...)` scoring. Compiler: No top-level protected-data likelihood candidate was inferred. |
| ForestDB translations | [Burglary Bayesnet](models/forestdb/burglary-bayesnet/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Latent Bayes-net states are marginalized by manual `target += log_sum_exp(...)` scoring. Compiler: No top-level protected-data likelihood candidate was inferred. |
| ForestDB translations | [Model Selection](models/forestdb/model-selection/) | `upstream` | `-` | `MAJOR` | `skipped` | - | Discrete model indicator is marginalized by manual `target += log_sum_exp(...)` scoring. Compiler: No top-level protected-data likelihood candidate was inferred. |

## Notes

- `AS-IS` was decided by running SafeStan `stanc` with `--sstanc` and inferred `--sstan-protect` variables.
- `MINOR` generally means one of: move parameter priors before use, vectorize indexed likelihoods, flatten protected observations, or pass derived protected data as top-level data.
- `MAJOR` generally means the model uses manual scoring (`target +=`), marginalized discrete latent structure, a user-defined probability distribution in `~`, or implicit improper priors that cannot be represented in SafeStan without changing the density.
