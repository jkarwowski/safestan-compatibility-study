# SafeStan Compatibility Results

Run id: `models-safe-high-20260428T004612Z`

Model/API: `gpt-5.5` with reasoning effort `high`.

Processed `45` models with `0` API/script failures. Compatibility totals: `10` as-is, `11` minor, `24` major.

SafeStan outputs and API reproducibility artifacts are mirrored under `models_safe/<category>/<model>/`. Major cases intentionally contain only `SAFETY_NOTE.md` plus API artifacts.

Compiler check: all `21` generated as-is/minor `model_safe.stan` files passed current `stanc --sstanc` validation with their recorded protected variables.

Result comparison run: `full-200x1-logprob-20260428T014242Z` compared all `21` generated models with `1` chain, `200` warmup draws, `200` sampling draws, and `3` log-prob/gradient spot checks per model. Results: `20` same, `1` same-density with MCMC-summary mismatch.

Data available: `yes` means the original source supplied concrete data in metadata; `no (synthetic/local)` means `data.json` was synthetic or locally supplied.

Token usage recorded by the API: `288173` input, `75264` cached input, `128277` output, including `100611` reasoning output tokens.

| Category | as-is | minor | major |
|---|---:|---:|---:|
| `forestdb` | 5 | 5 | 5 |
| `stan_case_studies` | 2 | 6 | 7 |
| `stan_tutorials` | 3 | 0 | 12 |
| **Total** | **10** | **11** | **24** |

| Model | Category | Compatibility | Data available | Protected variables | Safe files | stanc check | Input | Output | Reasoning | Safety note | Same result? |
|---|---|---:|---|---|---:|---:|---:|---:|---:|---|---|
| [Inferences with Binomials](models/forestdb/binomial-inference/) | `forestdb` | as-is | no (synthetic/local) | `y` | yes | pass | 2523 | 795 | 516 | [note](models_safe/forestdb/binomial-inference/SAFETY_NOTE.md) | same |
| [Burglary Bayesnet](models/forestdb/burglary-bayesnet/) | `forestdb` | minor | no (synthetic/local) | `calls_state` | yes | pass | 3238 | 10233 | 8804 | [note](models_safe/forestdb/burglary-bayesnet/SAFETY_NOTE.md) | same |
| [Finite Dirichlet-Multinomial Mixture](models/forestdb/dirichlet-multinomial-mixture/) | `forestdb` | major | no (synthetic/local) | - | no | n/a | 2892 | 684 | 516 | [note](models_safe/forestdb/dirichlet-multinomial-mixture/SAFETY_NOTE.md) | n/a |
| [Finite Gaussian Mixture](models/forestdb/finite-gaussian-mixture/) | `forestdb` | major | no (synthetic/local) | - | no | n/a | 2677 | 495 | 350 | [note](models_safe/forestdb/finite-gaussian-mixture/SAFETY_NOTE.md) | n/a |
| [Finite Mixture Model](models/forestdb/finite-mixture/) | `forestdb` | minor | no (synthetic/local) | `y` | yes | pass | 2676 | 3019 | 2588 | [note](models_safe/forestdb/finite-mixture/SAFETY_NOTE.md) | same |
| [1D Gaussian with Gaussian/Gamma Hyperparameters](models/forestdb/gaussian-gamma/) | `forestdb` | as-is | no (synthetic/local) | `y` | yes | pass | 2686 | 913 | 516 | [note](models_safe/forestdb/gaussian-gamma/SAFETY_NOTE.md) | same |
| [Inferences with Gaussians](models/forestdb/gaussian-inference/) | `forestdb` | as-is | no (synthetic/local) | `y` | yes | pass | 2559 | 533 | 263 | [note](models_safe/forestdb/gaussian-inference/SAFETY_NOTE.md) | same |
| [Geometric Distribution](models/forestdb/geometric-distribution/) | `forestdb` | minor | no (synthetic/local) | `y_failures` | yes | pass | 2619 | 6575 | 6214 | [note](models_safe/forestdb/geometric-distribution/SAFETY_NOTE.md) | same |
| [Discrete-Time Hidden Markov Model](models/forestdb/hidden-markov-model/) | `forestdb` | major | no (synthetic/local) | - | no | n/a | 2814 | 689 | 516 | [note](models_safe/forestdb/hidden-markov-model/SAFETY_NOTE.md) | n/a |
| [Bayesian Linear Regression](models/forestdb/linear-regression/) | `forestdb` | as-is | no (synthetic/local) | `y` | yes | pass | 2795 | 937 | 516 | [note](models_safe/forestdb/linear-regression/SAFETY_NOTE.md) | same |
| [Bayesian Logistic Regression](models/forestdb/logistic-regression/) | `forestdb` | as-is | no (synthetic/local) | `y` | yes | pass | 2807 | 911 | 516 | [note](models_safe/forestdb/logistic-regression/SAFETY_NOTE.md) | same |
| [Markov Model](models/forestdb/markov-model/) | `forestdb` | minor | no (synthetic/local) | `y_1`, `y_2`, `y_3`, `y_4`, `y_5`, `y_6`, `y_7`, `y_8`, `y_9`, `y_10`, `y_11`, `y_12`, `y_13`, `y_14` | yes | pass | 2632 | 16463 | 15538 | [note](models_safe/forestdb/markov-model/SAFETY_NOTE.md) | same |
| [Medical Diagnosis](models/forestdb/medical-diagnosis/) | `forestdb` | major | no (synthetic/local) | - | no | n/a | 2766 | 2759 | 2588 | [note](models_safe/forestdb/medical-diagnosis/SAFETY_NOTE.md) | n/a |
| [Model Selection](models/forestdb/model-selection/) | `forestdb` | major | no (synthetic/local) | - | no | n/a | 2949 | 703 | 516 | [note](models_safe/forestdb/model-selection/SAFETY_NOTE.md) | n/a |
| [Rat Growth](models/forestdb/rat-growth/) | `forestdb` | minor | no (synthetic/local) | `y_vec` | yes | pass | 2828 | 3571 | 2980 | [note](models_safe/forestdb/rat-growth/SAFETY_NOTE.md) | same |
| [Binary Trials Complete Pooling](models/stan_case_studies/binary-trials-complete-pool/) | `stan_case_studies` | minor | yes | `y` | yes | pass | 3651 | 5540 | 4142 | [note](models_safe/stan_case_studies/binary-trials-complete-pool/SAFETY_NOTE.md) | same |
| [Binary Trials Hierarchical Logit](models/stan_case_studies/binary-trials-hier-logit/) | `stan_case_studies` | minor | yes | `y` | yes | pass | 3874 | 5743 | 4142 | [note](models_safe/stan_case_studies/binary-trials-hier-logit/SAFETY_NOTE.md) | same |
| [Binary Trials Hierarchical Logit Centered](models/stan_case_studies/binary-trials-hier-logit-centered/) | `stan_case_studies` | as-is | yes | `y` | yes | pass | 3060 | 1077 | 516 | [note](models_safe/stan_case_studies/binary-trials-hier-logit-centered/SAFETY_NOTE.md) | same |
| [Binary Trials Hierarchical](models/stan_case_studies/binary-trials-hierarchical/) | `stan_case_studies` | minor | yes | `y` | yes | pass | 3817 | 4160 | 2588 | [note](models_safe/stan_case_studies/binary-trials-hierarchical/SAFETY_NOTE.md) | same |
| [Binary Trials No Pooling](models/stan_case_studies/binary-trials-no-pool/) | `stan_case_studies` | minor | yes | `y` | yes | pass | 3724 | 4053 | 2588 | [note](models_safe/stan_case_studies/binary-trials-no-pool/SAFETY_NOTE.md) | same |
| [BYM2 Spatial Poisson](models/stan_case_studies/bym2-spatial-poisson/) | `stan_case_studies` | major | yes | - | no | n/a | 5346 | 2779 | 2588 | [note](models_safe/stan_case_studies/bym2-spatial-poisson/SAFETY_NOTE.md) | n/a |
| [Golf Putting Logistic](models/stan_case_studies/golf-putting-logistic/) | `stan_case_studies` | major | yes | - | no | n/a | 2902 | 1742 | 1552 | [note](models_safe/stan_case_studies/golf-putting-logistic/SAFETY_NOTE.md) | n/a |
| [One-Compartment Michaelis-Menten ODE](models/stan_case_studies/one-compartment-mm-ode/) | `stan_case_studies` | as-is | yes | `C` | yes | pass | 3426 | 2015 | 1034 | [note](models_safe/stan_case_studies/one-compartment-mm-ode/SAFETY_NOTE.md) | same |
| [SIR ODE](models/stan_case_studies/sir-ode/) | `stan_case_studies` | minor | yes | `stoi`, `B` | yes | pass | 3383 | 2525 | 1552 | [note](models_safe/stan_case_studies/sir-ode/SAFETY_NOTE.md) | same |
| [Soil Incubation ODE](models/stan_case_studies/soil-incubation-ode/) | `stan_case_studies` | minor | yes | `eCO2mean` | yes | pass | 4423 | 4492 | 3106 | [note](models_safe/stan_case_studies/soil-incubation-ode/SAFETY_NOTE.md) | same density; MCMC mismatch; log_prob max abs(delta) 3.55e-15, failed posterior-summary columns 2 |
| [World Cup First Try](models/stan_case_studies/worldcup-first-try/) | `stan_case_studies` | major | yes | - | no | n/a | 4182 | 2263 | 2070 | [note](models_safe/stan_case_studies/worldcup-first-try/SAFETY_NOTE.md) | n/a |
| [World Cup Fixed](models/stan_case_studies/worldcup-fixed/) | `stan_case_studies` | major | yes | - | no | n/a | 4254 | 3429 | 3202 | [note](models_safe/stan_case_studies/worldcup-fixed/SAFETY_NOTE.md) | n/a |
| [World Cup No Prior](models/stan_case_studies/worldcup-no-prior/) | `stan_case_studies` | major | yes | - | no | n/a | 4216 | 2265 | 2070 | [note](models_safe/stan_case_studies/worldcup-no-prior/SAFETY_NOTE.md) | n/a |
| [World Cup No Square Root](models/stan_case_studies/worldcup-no-sqrt/) | `stan_case_studies` | major | yes | - | no | n/a | 4195 | 1762 | 1552 | [note](models_safe/stan_case_studies/worldcup-no-sqrt/SAFETY_NOTE.md) | n/a |
| [World Cup with Replication](models/stan_case_studies/worldcup-replication/) | `stan_case_studies` | major | yes | - | no | n/a | 4269 | 4874 | 4660 | [note](models_safe/stan_case_studies/worldcup-replication/SAFETY_NOTE.md) | n/a |
| [Bernoulli Estimator](models/stan_tutorials/bernoulli/) | `stan_tutorials` | as-is | yes | `y` | yes | pass | 2619 | 671 | 383 | [note](models_safe/stan_tutorials/bernoulli/SAFETY_NOTE.md) | same |
| [Censored Normal](models/stan_tutorials/censored-normal/) | `stan_tutorials` | major | yes | - | no | n/a | 7807 | 4344 | 4142 | [note](models_safe/stan_tutorials/censored-normal/SAFETY_NOTE.md) | n/a |
| [K-Component Normal Mixture](models/stan_tutorials/k-component-normal-mixture/) | `stan_tutorials` | major | yes | - | no | n/a | 12775 | 692 | 516 | [note](models_safe/stan_tutorials/k-component-normal-mixture/SAFETY_NOTE.md) | n/a |
| [K-Component Normal Mixture with Simplex Weights](models/stan_tutorials/k-component-normal-mixture-simplex/) | `stan_tutorials` | major | yes | - | no | n/a | 12862 | 1010 | 826 | [note](models_safe/stan_tutorials/k-component-normal-mixture-simplex/SAFETY_NOTE.md) | n/a |
| [Multivariate Normal](models/stan_tutorials/multivariate-normal/) | `stan_tutorials` | major | yes | - | no | n/a | 5381 | 1796 | 1552 | [note](models_safe/stan_tutorials/multivariate-normal/SAFETY_NOTE.md) | n/a |
| [Negative Binomial](models/stan_tutorials/negative-binomial/) | `stan_tutorials` | as-is | yes | `y` | yes | pass | 2626 | 632 | 324 | [note](models_safe/stan_tutorials/negative-binomial/SAFETY_NOTE.md) | same |
| [Negative Binomial 2](models/stan_tutorials/negative-binomial2/) | `stan_tutorials` | major | yes | - | no | n/a | 2644 | 1179 | 1024 | [note](models_safe/stan_tutorials/negative-binomial2/SAFETY_NOTE.md) | n/a |
| [Normal Location](models/stan_tutorials/normal-location/) | `stan_tutorials` | major | no (synthetic/local) | - | no | n/a | 2532 | 1139 | 954 | [note](models_safe/stan_tutorials/normal-location/SAFETY_NOTE.md) | n/a |
| [Normal Mixture](models/stan_tutorials/normal-mixture/) | `stan_tutorials` | major | yes | - | no | n/a | 12659 | 685 | 516 | [note](models_safe/stan_tutorials/normal-mixture/SAFETY_NOTE.md) | n/a |
| [Simple Regression](models/stan_tutorials/simple-regression/) | `stan_tutorials` | major | yes | - | no | n/a | 4575 | 1489 | 1279 | [note](models_safe/stan_tutorials/simple-regression/SAFETY_NOTE.md) | n/a |
| [Truncated Normal](models/stan_tutorials/truncated-normal/) | `stan_tutorials` | major | yes | - | no | n/a | 7620 | 2783 | 2588 | [note](models_safe/stan_tutorials/truncated-normal/SAFETY_NOTE.md) | n/a |
| [Two-Parameter Logistic IRT](models/stan_tutorials/two-parameter-logistic-irt/) | `stan_tutorials` | as-is | yes | `y` | yes | pass | 34375 | 10221 | 3106 | [note](models_safe/stan_tutorials/two-parameter-logistic-irt/SAFETY_NOTE.md) | same |
| [2PL Regression Centered](models/stan_tutorials/two-pl-regression-centered/) | `stan_tutorials` | major | yes | - | no | n/a | 37049 | 1225 | 1034 | [note](models_safe/stan_tutorials/two-pl-regression-centered/SAFETY_NOTE.md) | n/a |
| [2PL Regression Noncentered](models/stan_tutorials/two-pl-regression-noncentered/) | `stan_tutorials` | major | yes | - | no | n/a | 37086 | 1188 | 1034 | [note](models_safe/stan_tutorials/two-pl-regression-noncentered/SAFETY_NOTE.md) | n/a |
| [Vector Regression](models/stan_tutorials/vector-regression/) | `stan_tutorials` | major | yes | - | no | n/a | 5380 | 1224 | 1034 | [note](models_safe/stan_tutorials/vector-regression/SAFETY_NOTE.md) | n/a |

Notes:

- `rat-growth` required a manual postprocess after the API response: the matrix observation was flattened to `y_vec` so the protected observation is a plain top-level identifier accepted by SafeStan.
- `two-parameter-logistic-irt` required a manual postprocess after the API response: malformed as-is `data_safe.json` was replaced with the original `data.json`.
- `soil-incubation-ode` has identical checked log density/gradients, but the short MCMC posterior summaries differed for `alpha12` and `alpha21`; this is recorded as `same density; MCMC mismatch`.
