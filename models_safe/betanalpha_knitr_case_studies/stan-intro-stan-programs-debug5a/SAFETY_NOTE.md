# SafeStan Safety Note

Compatibility: minor.

Protected data: none.

Generated files: `model_safe.stan`, `data_safe.json`.

Changes: the original model placed the parameter prior statement `x ~ normal(0, 1)` inside a loop that repeats 9 times. SafeStan does not allow parameter-prior sampling statements inside loops and requires each parameter to have exactly one built-in prior statement. The repeated identical normal prior kernel is mechanically collapsed to the equivalent single prior kernel `x ~ normal(0, 1.0 / 3.0)`, because nine repetitions of a standard normal kernel give a normal kernel with precision 9. No data changes were required.
