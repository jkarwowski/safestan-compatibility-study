# Stan vs SafeStan Result Comparison

Run id: `full-200x1-20260428T013552Z`

Compared `21` generated SafeStan models.

| Status | Count |
|---|---:|
| `different` | 1 |
| `run-failed` | 1 |
| `same` | 19 |

| Model | Compatibility | Status | Draws | Columns | Max mean z | Failed columns | Artifacts |
|---|---:|---:|---:|---:|---:|---:|---|
| [binomial-inference](models/forestdb/binomial-inference/) | as-is | same | 200 | 2 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/binomial-inference](comparison_runs/full-200x1-20260428T013552Z/forestdb/binomial-inference/) |
| [burglary-bayesnet](models/forestdb/burglary-bayesnet/) | minor | same | 200 | 3 | 2.474 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/burglary-bayesnet](comparison_runs/full-200x1-20260428T013552Z/forestdb/burglary-bayesnet/) |
| [finite-mixture](models/forestdb/finite-mixture/) | minor | same | 200 | 6 | 3.502 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/finite-mixture](comparison_runs/full-200x1-20260428T013552Z/forestdb/finite-mixture/) |
| [gaussian-gamma](models/forestdb/gaussian-gamma/) | as-is | same | 200 | 3 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/gaussian-gamma](comparison_runs/full-200x1-20260428T013552Z/forestdb/gaussian-gamma/) |
| [gaussian-inference](models/forestdb/gaussian-inference/) | as-is | same | 200 | 2 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/gaussian-inference](comparison_runs/full-200x1-20260428T013552Z/forestdb/gaussian-inference/) |
| [geometric-distribution](models/forestdb/geometric-distribution/) | minor | same | 200 | 1 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/geometric-distribution](comparison_runs/full-200x1-20260428T013552Z/forestdb/geometric-distribution/) |
| [linear-regression](models/forestdb/linear-regression/) | as-is | same | 200 | 15 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/linear-regression](comparison_runs/full-200x1-20260428T013552Z/forestdb/linear-regression/) |
| [logistic-regression](models/forestdb/logistic-regression/) | as-is | same | 200 | 16 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/logistic-regression](comparison_runs/full-200x1-20260428T013552Z/forestdb/logistic-regression/) |
| [markov-model](models/forestdb/markov-model/) | minor | same | 200 | 12 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/markov-model](comparison_runs/full-200x1-20260428T013552Z/forestdb/markov-model/) |
| [rat-growth](models/forestdb/rat-growth/) | minor | same | 200 | 25 | 3.295 | 0 | [comparison_runs/full-200x1-20260428T013552Z/forestdb/rat-growth](comparison_runs/full-200x1-20260428T013552Z/forestdb/rat-growth/) |
| [binary-trials-complete-pool](models/stan_case_studies/binary-trials-complete-pool/) | minor | same | 200 | 79 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-complete-pool](comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-complete-pool/) |
| [binary-trials-hier-logit](models/stan_case_studies/binary-trials-hier-logit/) | minor | same | 200 | 134 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-hier-logit](comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-hier-logit/) |
| [binary-trials-hier-logit-centered](models/stan_case_studies/binary-trials-hier-logit-centered/) | as-is | same | 200 | 38 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-hier-logit-centered](comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-hier-logit-centered/) |
| [binary-trials-hierarchical](models/stan_case_studies/binary-trials-hierarchical/) | minor | same | 200 | 116 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-hierarchical](comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-hierarchical/) |
| [binary-trials-no-pool](models/stan_case_studies/binary-trials-no-pool/) | minor | same | 200 | 114 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-no-pool](comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/binary-trials-no-pool/) |
| [one-compartment-mm-ode](models/stan_case_studies/one-compartment-mm-ode/) | as-is | same | 200 | 44 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/one-compartment-mm-ode](comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/one-compartment-mm-ode/) |
| [sir-ode](models/stan_case_studies/sir-ode/) | minor | same | 200 | 84 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/sir-ode](comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/sir-ode/) |
| [soil-incubation-ode](models/stan_case_studies/soil-incubation-ode/) | minor | different | 200 | 31 | 9.873 | 2 | [comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/soil-incubation-ode](comparison_runs/full-200x1-20260428T013552Z/stan_case_studies/soil-incubation-ode/) |
| [bernoulli](models/stan_tutorials/bernoulli/) | as-is | same | 200 | 1 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_tutorials/bernoulli](comparison_runs/full-200x1-20260428T013552Z/stan_tutorials/bernoulli/) |
| [negative-binomial](models/stan_tutorials/negative-binomial/) | as-is | same | 200 | 2 | 0.000 | 0 | [comparison_runs/full-200x1-20260428T013552Z/stan_tutorials/negative-binomial](comparison_runs/full-200x1-20260428T013552Z/stan_tutorials/negative-binomial/) |
| [two-parameter-logistic-irt](models/stan_tutorials/two-parameter-logistic-irt/) | as-is | run-failed |  |  |  |  | [comparison_runs/full-200x1-20260428T013552Z/stan_tutorials/two-parameter-logistic-irt](comparison_runs/full-200x1-20260428T013552Z/stan_tutorials/two-parameter-logistic-irt/) |
