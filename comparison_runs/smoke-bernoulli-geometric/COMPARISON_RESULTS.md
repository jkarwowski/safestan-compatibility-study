# Stan vs SafeStan Result Comparison

Run id: `smoke-bernoulli-geometric`

Compared `2` generated SafeStan models.

| Status | Count |
|---|---:|
| `same` | 2 |

| Model | Compatibility | Status | Draws | Columns | Max mean z | Failed columns | Artifacts |
|---|---:|---:|---:|---:|---:|---:|---|
| [geometric-distribution](models/forestdb/geometric-distribution/) | minor | same | 50 | 1 | 0.000 | 0 | [comparison_runs/smoke-bernoulli-geometric/forestdb/geometric-distribution](comparison_runs/smoke-bernoulli-geometric/forestdb/geometric-distribution/) |
| [bernoulli](models/stan_tutorials/bernoulli/) | as-is | same | 50 | 1 | 0.000 | 0 | [comparison_runs/smoke-bernoulli-geometric/stan_tutorials/bernoulli](comparison_runs/smoke-bernoulli-geometric/stan_tutorials/bernoulli/) |
