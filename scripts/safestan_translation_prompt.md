You are translating a single Stan model into SafeStan for a regression-test
corpus. Return only the structured JSON requested by the caller.

SafeStan rules to apply:

- Protected observed data should appear as top-level data variables and be
  observed by plain `name ~ distribution(...)` sampling statements.
- Do not use `target +=`, `target()`, direct `_lpdf`/`_lpmf` scoring, or
  user-defined probability distributions for protected observations.
- Do not use protected data in `transformed data` or before its observation.
  If a summary/reshape is needed, add deterministic fields to `data_safe_json`
  and document them.
- Avoid sampling statements inside loops or conditionals when the same density
  can be expressed as one vectorized sampling statement.
- Parameters should have explicit proper priors, and priors should appear
  before parameter use. Do not add priors that change the posterior. Adding
  `uniform(0, 1)` to a parameter already constrained to `<lower=0, upper=1>`
  is acceptable because it is density-neutral on the support.

Compatibility labels:

- `as-is`: the original Stan program is already SafeStan-compatible. Return
  `model_safe_stan` equivalent to the original and `data_safe_json` equivalent
  to the original data.
- `minor`: a same-posterior SafeStan version can be produced using only
  mechanical changes such as moving existing priors earlier, vectorizing simple
  likelihoods, adding deterministic data copies/reshapes, or adding
  density-neutral bounded uniform priors.
- `major`: no SafeStan version can be produced without a substantive model or
  density change. In this case return empty strings for `model_safe_stan` and
  `data_safe_json`.

Requirements:

- Never invent new observations or synthetic data.
- `data_safe_json` must be a valid JSON object string. It may equal the original
  data exactly, or be a deterministic augmentation/reshape of it.
- If you add fields to `data_safe_json`, document the exact deterministic
  relation in `safety_note_md`.
- Preserve the intended posterior/log density for AS-IS and MINOR.
- If the model relies on mixture marginalization, custom manual scoring,
  censored/truncated target adjustments, hidden-state algorithms, or implicit
  improper priors that cannot be represented without changing the density,
  classify it as `major`.
- `safety_note_md` must be Markdown beginning with `# SafeStan Safety Note` and
  include: compatibility, protected data choice, generated files, and a concise
  explanation of any change.

Model directory: ${model_dir}

Metadata:

```json
${metadata_json}
```

Source note:

```text
${source_note}
```

Original `model.stan`:

```stan
${model_stan}
```

Original `data.json`:

```json
${data_json}
```
