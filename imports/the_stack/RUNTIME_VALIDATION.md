# The Stack runtime smoke test

All 2,296 imported candidates were checked on 2026-11-24 using their committed `model.stan` and `data.json` from import commit `e136c9b1d9c92277be8a86fc3e022d971ca593d2`. **2,295 compile as C++; 1,601 complete the short sampling check.** The full import is therefore not yet a runnable dataset with its current synthetic inputs.

The [per-model JSON report](../../runs_metadata/the_stack_runtime_smoke.json) records exact source/data SHA-256 hashes, build and run outcomes, timings, failure diagnostics, and output checks. Coverage and hashes were verified after combining both workers: every candidate appears exactly once. No model, data, or per-model metadata was changed by this validation.

## Results

| Outcome | Models |
| --- | ---: |
| C++ build succeeded | 2,295 / 2,296 |
| Build and sampling succeeded, with five retained draws and finite `lp__` | 1,601 |
| Build succeeded; sampling process failed | 693 |
| Build succeeded; sampling timed out | 1 |
| C++ build failed | 1 |

The last four rows partition the import. There were no build timeouts and no zero-exit sampling runs that failed the retained-draw/finite-log-probability check.

Of the 1,601 completed runs, 139 had divergent retained draws and 37 had non-finite values in other output columns; four had both. **1,429 completed without either recorded issue.** These are execution checks, not evidence of convergence, posterior propriety, or scientific correctness. The `passed` status alone does not mean that all output columns are finite or that the chain is free of divergences.

## Protocol

- Official CmdStan 2.38.0; full C++ compilation and linking at `O=0`, with precompiled headers.
- One NUTS chain, five warmup transitions, five retained draws, seed 12345, default random initialization, fixed stepsize 0.01, maximum tree depth 4, adaptation disabled.
- Separate limits of 180 seconds for building and 30 seconds for sampling. Success requires both processes to exit zero and exactly five retained draws with finite `lp__`.
- Six parallel workers on each host. macOS arm64 checked 1,531 candidates; DGX Spark Linux aarch64 checked 765. Models were partitioned by sorted path index modulo three, with indices zero and one assigned to macOS and two to Spark. Each candidate was checked on its assigned host; this is not a full cross-platform test.
- Linux subprocesses had an 8 GiB address-space limit. macOS used process timeouts without a memory cap. Compiler hashes, platforms, and limits are included in the report.

Most failures occur during initialization. Automatic log categories for the 693 runtime failures are 552 `initialization_log_probability`, 29 `initialization`, 98 `data_or_model_exception`, 12 `data_shape_or_missing`, and two `runtime_error`. These categories identify the observed failure stage and message, not a complete diagnosis of the source model.

Many checked-in synthetic inputs violate distribution support, cross-variable shape relationships, or assumptions implemented inside model code. For example, the beta-proportion model's generated observation `y=3` is outside `[0, 1]`. Failure with this synthetic data does not establish failure with suitable observations and initialization. The existing finite-JSON/input-key validation could not detect these problems.

## Cases requiring separate review

- [`isabella232-chronikis-day-in-week-periodicity-3edb7632ff10`](../../models/the_stack/isabella232-chronikis-day-in-week-periodicity-3edb7632ff10/model.stan): C++ type-conversion errors in generated code for `scale_matrices`, involving arrays of double matrices and autodiff matrices. This passes stanc but fails the subsequent C++ build. A supplementary build with the original import-audit compiler reproduced the same errors using a fresh precompiled header.
- [`eehh-stanford-baydem-gaussmix-masked-227b051b2882`](../../models/the_stack/eehh-stanford-baydem-gaussmix-masked-227b051b2882/model.stan): sampling exceeded 30 seconds. Source/data inspection identifies a nonterminating `bin_search` for the generated noninteger `subset_length` values. The function assumes rounded integers; with bounds 2 and 3, its range stays at one until an integer midpoint equals the input, which cannot happen for `subset_length[1] = 2.1477019023642434`. Increasing the timeout would not resolve this input problem.
- [`meyer-lab-fcrn-trafficking-model-f0efb72a3d7d`](../../models/the_stack/meyer-lab-fcrn-trafficking-model-f0efb72a3d7d/model.stan): runtime abort with an Eigen matrix-product assertion.
- [`seabbs-cmmid-stan-seir-model-da145953ec28`](../../models/the_stack/seabbs-cmmid-stan-seir-model-da145953ec28/model.stan): segmentation fault on Spark. A supplementary check on macOS reproduced the segmentation fault with identical source, data, and sampling settings. The two runtime crashes are included in the 693 runtime failures, not counted again.

## Reproduce and select a subset

Use a fresh CmdStan 2.38.0 installation built at `O=0`, so its precompiled header matches the model build flags. The runner and summarizer use only the Python standard library on macOS/Linux.

```sh
make -C /path/to/cmdstan-2.38.0 O=0 -j4 build
python3 scripts/smoke_test_stack_models.py \
  --cmdstan /path/to/cmdstan-2.38.0 \
  --output /tmp/stack-runtime-smoke \
  --jobs 6 --memory-gb 8
python3 scripts/summarize_stack_smoke.py \
  --run /tmp/stack-runtime-smoke \
  --output /tmp/stack-runtime-report.json
python3 -m unittest discover -s scripts -p 'test_*stack*.py'
```

The output directory retains copied inputs, build/run logs, sampling CSVs, a plan, and JSONL results. Executables and build intermediates are removed after each candidate. Repeating the same command resumes an interrupted run and preserves completed failures as well as successes; use a new output directory to retest. `--shards` and repeated `--shard` arguments split work deterministically; combine completed shards with repeated `--run` arguments to the summarizer. The summarizer rejects incomplete coverage, duplicate results, changed input hashes, or inconsistent sampling settings.

To select the 1,601 execution successes from the saved report, filter `results` for `status == "passed"`. To select the 1,429 without the recorded diagnostic issues as well, additionally require `output.divergent_draws == 0` and an empty `output.nonfinite_columns` list. Keep the remaining candidates for later data repair and model review rather than interpreting this bounded check as a definitive assessment of model quality.
