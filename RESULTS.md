# SafeStan Compatibility Results

Run id: `sample3-high-20260427T194608Z`

Model/API: `gpt-5.5` with reasoning effort `high`.

Processed `45` models with `0` failures. Compatibility totals: `8` as-is, `12` minor, `25` major. Estimated total API cost: `$4.056940`.

Cost estimate uses GPT-5.5 standard short-context rates used for this run: `$5.00/M` input tokens, `$0.50/M` cached input tokens, and `$30.00/M` output tokens.

| Category | as-is | minor | major |
|---|---:|---:|---:|
| `forestdb` | 4 | 4 | 7 |
| `stan_case_studies` | 1 | 8 | 6 |
| `stan_tutorials` | 3 | 0 | 12 |
| **Total** | **8** | **12** | **25** |

| Model | Category | Compatibility | Data | Safe files | Input | Output | Reasoning | Cost | Safety note | Same result? |
|---|---|---:|---|---:|---:|---:|---:|---:|---|---|
| [binomial-inference](models/forestdb/binomial-inference/) | `forestdb` | minor | synthetic/local | yes | 2098 | 2843 | 2588 | $0.095780 | [note](models/forestdb/binomial-inference/SAFETY_NOTE.md) |  |
| [burglary-bayesnet](models/forestdb/burglary-bayesnet/) | `forestdb` | major | synthetic/local | no | 2813 | 564 | 425 | $0.030985 | [note](models/forestdb/burglary-bayesnet/SAFETY_NOTE.md) |  |
| [dirichlet-multinomial-mixture](models/forestdb/dirichlet-multinomial-mixture/) | `forestdb` | major | synthetic/local | no | 2467 | 286 | 135 | $0.020915 | [note](models/forestdb/dirichlet-multinomial-mixture/SAFETY_NOTE.md) |  |
| [finite-gaussian-mixture](models/forestdb/finite-gaussian-mixture/) | `forestdb` | major | synthetic/local | no | 2252 | 292 | 143 | $0.020020 | [note](models/forestdb/finite-gaussian-mixture/SAFETY_NOTE.md) |  |
| [finite-mixture](models/forestdb/finite-mixture/) | `forestdb` | major | synthetic/local | no | 2251 | 333 | 189 | $0.021245 | [note](models/forestdb/finite-mixture/SAFETY_NOTE.md) |  |
| [gaussian-gamma](models/forestdb/gaussian-gamma/) | `forestdb` | as-is | synthetic/local | yes | 2261 | 790 | 396 | $0.035005 | [note](models/forestdb/gaussian-gamma/SAFETY_NOTE.md) |  |
| [gaussian-inference](models/forestdb/gaussian-inference/) | `forestdb` | as-is | synthetic/local | yes | 2134 | 510 | 258 | $0.025970 | [note](models/forestdb/gaussian-inference/SAFETY_NOTE.md) |  |
| [geometric-distribution](models/forestdb/geometric-distribution/) | `forestdb` | minor | synthetic/local | yes | 2194 | 1431 | 1034 | $0.053900 | [note](models/forestdb/geometric-distribution/SAFETY_NOTE.md) |  |
| [hidden-markov-model](models/forestdb/hidden-markov-model/) | `forestdb` | major | synthetic/local | no | 2389 | 305 | 166 | $0.021095 | [note](models/forestdb/hidden-markov-model/SAFETY_NOTE.md) |  |
| [linear-regression](models/forestdb/linear-regression/) | `forestdb` | as-is | synthetic/local | yes | 2370 | 877 | 475 | $0.038160 | [note](models/forestdb/linear-regression/SAFETY_NOTE.md) |  |
| [logistic-regression](models/forestdb/logistic-regression/) | `forestdb` | as-is | synthetic/local | yes | 2382 | 910 | 516 | $0.039210 | [note](models/forestdb/logistic-regression/SAFETY_NOTE.md) |  |
| [markov-model](models/forestdb/markov-model/) | `forestdb` | minor | synthetic/local | yes | 2207 | 10993 | 10358 | $0.340825 | [note](models/forestdb/markov-model/SAFETY_NOTE.md) |  |
| [medical-diagnosis](models/forestdb/medical-diagnosis/) | `forestdb` | major | synthetic/local | no | 2341 | 573 | 430 | $0.028895 | [note](models/forestdb/medical-diagnosis/SAFETY_NOTE.md) |  |
| [model-selection](models/forestdb/model-selection/) | `forestdb` | major | synthetic/local | no | 2524 | 424 | 275 | $0.025340 | [note](models/forestdb/model-selection/SAFETY_NOTE.md) |  |
| [rat-growth](models/forestdb/rat-growth/) | `forestdb` | minor | synthetic/local | yes | 2403 | 4288 | 3624 | $0.140655 | [note](models/forestdb/rat-growth/SAFETY_NOTE.md) |  |
| [binary-trials-complete-pool](models/stan_case_studies/binary-trials-complete-pool/) | `stan_case_studies` | minor | source data | yes | 3226 | 5020 | 3624 | $0.166730 | [note](models/stan_case_studies/binary-trials-complete-pool/SAFETY_NOTE.md) |  |
| [binary-trials-hier-logit](models/stan_case_studies/binary-trials-hier-logit/) | `stan_case_studies` | minor | source data | yes | 3449 | 4163 | 2587 | $0.142135 | [note](models/stan_case_studies/binary-trials-hier-logit/SAFETY_NOTE.md) |  |
| [binary-trials-hier-logit-centered](models/stan_case_studies/binary-trials-hier-logit-centered/) | `stan_case_studies` | as-is | source data | yes | 2635 | 1033 | 516 | $0.044165 | [note](models/stan_case_studies/binary-trials-hier-logit-centered/SAFETY_NOTE.md) |  |
| [binary-trials-hierarchical](models/stan_case_studies/binary-trials-hierarchical/) | `stan_case_studies` | minor | source data | yes | 3392 | 5707 | 4142 | $0.188170 | [note](models/stan_case_studies/binary-trials-hierarchical/SAFETY_NOTE.md) |  |
| [binary-trials-no-pool](models/stan_case_studies/binary-trials-no-pool/) | `stan_case_studies` | minor | source data | yes | 3299 | 5563 | 4142 | $0.183385 | [note](models/stan_case_studies/binary-trials-no-pool/SAFETY_NOTE.md) |  |
| [bym2-spatial-poisson](models/stan_case_studies/bym2-spatial-poisson/) | `stan_case_studies` | minor | source data | yes | 4921 | 3696 | 1552 | $0.135485 | [note](models/stan_case_studies/bym2-spatial-poisson/SAFETY_NOTE.md) |  |
| [golf-putting-logistic](models/stan_case_studies/golf-putting-logistic/) | `stan_case_studies` | major | source data | no | 2477 | 608 | 449 | $0.030625 | [note](models/stan_case_studies/golf-putting-logistic/SAFETY_NOTE.md) |  |
| [one-compartment-mm-ode](models/stan_case_studies/one-compartment-mm-ode/) | `stan_case_studies` | minor | source data | yes | 3001 | 5199 | 4142 | $0.170975 | [note](models/stan_case_studies/one-compartment-mm-ode/SAFETY_NOTE.md) |  |
| [sir-ode](models/stan_case_studies/sir-ode/) | `stan_case_studies` | minor | source data | yes | 2958 | 3016 | 2070 | $0.105270 | [note](models/stan_case_studies/sir-ode/SAFETY_NOTE.md) |  |
| [soil-incubation-ode](models/stan_case_studies/soil-incubation-ode/) | `stan_case_studies` | minor | source data | yes | 3998 | 7061 | 5696 | $0.231820 | [note](models/stan_case_studies/soil-incubation-ode/SAFETY_NOTE.md) |  |
| [worldcup-first-try](models/stan_case_studies/worldcup-first-try/) | `stan_case_studies` | major | source data | no | 3757 | 1201 | 1034 | $0.054815 | [note](models/stan_case_studies/worldcup-first-try/SAFETY_NOTE.md) |  |
| [worldcup-fixed](models/stan_case_studies/worldcup-fixed/) | `stan_case_studies` | major | source data | no | 3829 | 1196 | 1034 | $0.055025 | [note](models/stan_case_studies/worldcup-fixed/SAFETY_NOTE.md) |  |
| [worldcup-no-prior](models/stan_case_studies/worldcup-no-prior/) | `stan_case_studies` | major | source data | no | 3791 | 1217 | 1034 | $0.055465 | [note](models/stan_case_studies/worldcup-no-prior/SAFETY_NOTE.md) |  |
| [worldcup-no-sqrt](models/stan_case_studies/worldcup-no-sqrt/) | `stan_case_studies` | major | source data | no | 3770 | 1755 | 1552 | $0.071500 | [note](models/stan_case_studies/worldcup-no-sqrt/SAFETY_NOTE.md) |  |
| [worldcup-replication](models/stan_case_studies/worldcup-replication/) | `stan_case_studies` | major | source data | no | 3844 | 1207 | 1034 | $0.055430 | [note](models/stan_case_studies/worldcup-replication/SAFETY_NOTE.md) |  |
| [bernoulli](models/stan_tutorials/bernoulli/) | `stan_tutorials` | as-is | source data | yes | 2194 | 390 | 163 | $0.022670 | [note](models/stan_tutorials/bernoulli/SAFETY_NOTE.md) |  |
| [censored-normal](models/stan_tutorials/censored-normal/) | `stan_tutorials` | major | source data | no | 7382 | 1725 | 1552 | $0.088660 | [note](models/stan_tutorials/censored-normal/SAFETY_NOTE.md) |  |
| [k-component-normal-mixture](models/stan_tutorials/k-component-normal-mixture/) | `stan_tutorials` | major | source data | no | 12350 | 461 | 322 | $0.075580 | [note](models/stan_tutorials/k-component-normal-mixture/SAFETY_NOTE.md) |  |
| [k-component-normal-mixture-simplex](models/stan_tutorials/k-component-normal-mixture-simplex/) | `stan_tutorials` | major | source data | no | 12437 | 658 | 516 | $0.081925 | [note](models/stan_tutorials/k-component-normal-mixture-simplex/SAFETY_NOTE.md) |  |
| [multivariate-normal](models/stan_tutorials/multivariate-normal/) | `stan_tutorials` | major | source data | no | 4956 | 678 | 516 | $0.045120 | [note](models/stan_tutorials/multivariate-normal/SAFETY_NOTE.md) |  |
| [negative-binomial](models/stan_tutorials/negative-binomial/) | `stan_tutorials` | as-is | source data | yes | 2201 | 562 | 316 | $0.027865 | [note](models/stan_tutorials/negative-binomial/SAFETY_NOTE.md) |  |
| [negative-binomial2](models/stan_tutorials/negative-binomial2/) | `stan_tutorials` | major | source data | no | 2219 | 663 | 516 | $0.030985 | [note](models/stan_tutorials/negative-binomial2/SAFETY_NOTE.md) |  |
| [normal-location](models/stan_tutorials/normal-location/) | `stan_tutorials` | major | synthetic/local | no | 2107 | 582 | 431 | $0.027995 | [note](models/stan_tutorials/normal-location/SAFETY_NOTE.md) |  |
| [normal-mixture](models/stan_tutorials/normal-mixture/) | `stan_tutorials` | major | source data | no | 12234 | 455 | 329 | $0.074820 | [note](models/stan_tutorials/normal-mixture/SAFETY_NOTE.md) |  |
| [simple-regression](models/stan_tutorials/simple-regression/) | `stan_tutorials` | major | source data | no | 4150 | 489 | 347 | $0.035420 | [note](models/stan_tutorials/simple-regression/SAFETY_NOTE.md) |  |
| [truncated-normal](models/stan_tutorials/truncated-normal/) | `stan_tutorials` | major | source data | no | 7195 | 521 | 345 | $0.051605 | [note](models/stan_tutorials/truncated-normal/SAFETY_NOTE.md) |  |
| [two-parameter-logistic-irt](models/stan_tutorials/two-parameter-logistic-irt/) | `stan_tutorials` | as-is | source data | yes | 33950 | 8197 | 7768 | $0.415660 | [note](models/stan_tutorials/two-parameter-logistic-irt/SAFETY_NOTE.md) |  |
| [two-pl-regression-centered](models/stan_tutorials/two-pl-regression-centered/) | `stan_tutorials` | major | source data | no | 36624 | 667 | 516 | $0.203130 | [note](models/stan_tutorials/two-pl-regression-centered/SAFETY_NOTE.md) |  |
| [two-pl-regression-noncentered](models/stan_tutorials/two-pl-regression-noncentered/) | `stan_tutorials` | major | source data | no | 36661 | 671 | 516 | $0.203435 | [note](models/stan_tutorials/two-pl-regression-noncentered/SAFETY_NOTE.md) |  |
| [vector-regression](models/stan_tutorials/vector-regression/) | `stan_tutorials` | major | source data | no | 4955 | 610 | 484 | $0.043075 | [note](models/stan_tutorials/vector-regression/SAFETY_NOTE.md) |  |
