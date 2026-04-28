#!/usr/bin/env python3
"""Import the ForestDB front-page model set into the corpus layout.

ForestDB is a GitHub Pages site.  The front page is generated from markdown
files with `layout: model`, a front-page status, and a front-page category.
This importer copies those original markdown files into each model's
`source.md` and writes normal Stan translations for entries that were not part
of the original curated ForestDB subset.
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_SOURCE_ROOT = Path("/tmp/stan-collection-sources/forestdb.org")
DEFAULT_MODELS_ROOT = ROOT / "models" / "forestdb"
FORESTDB_REPO = "https://github.com/forestdb/forestdb.org.git"
FORESTDB_BRANCH = "gh-pages"

FRONT_PAGE_STATUSES = ["code", "link", "code-fail", "stub"]
FRONT_PAGE_CATEGORIES = [
    "Concept Learning",
    "Reasoning about Reasoning",
    "Machine Learning",
    "Nonparametric Models",
    "Bayesian Data Analysis",
    "Undirected Constraints",
    "Inverse Dynamics",
    "PPAML Challenge Problems",
    "Miscellaneous",
]

RUN_PY = """#!/usr/bin/env python3
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))

from scripts.run_cmdstan_model import main

if __name__ == "__main__":
    raise SystemExit(main(["--model-dir", str(Path(__file__).resolve().parent), *sys.argv[1:]]))
"""

# Keep the established curated directory names for the 15 ForestDB models that
# were already in the repository.
TARGET_SLUGS = {
    "burglary": "burglary-bayesnet",
    "dm-mixture": "dirichlet-multinomial-mixture",
    "geometric": "geometric-distribution",
    "hmm": "hidden-markov-model",
    "markov": "markov-model",
    "medical-bayesnet": "medical-diagnosis",
}

CURATED_TARGETS = {
    "binomial-inference",
    "burglary-bayesnet",
    "dirichlet-multinomial-mixture",
    "finite-gaussian-mixture",
    "finite-mixture",
    "gaussian-gamma",
    "gaussian-inference",
    "geometric-distribution",
    "hidden-markov-model",
    "linear-regression",
    "logistic-regression",
    "markov-model",
    "medical-diagnosis",
    "model-selection",
    "rat-growth",
}

SAFE_RESULTS = {
    "binomial-inference": ("as-is", "same"),
    "burglary-bayesnet": ("minor", "same"),
    "dirichlet-multinomial-mixture": ("major", "n/a"),
    "finite-gaussian-mixture": ("major", "n/a"),
    "finite-mixture": ("minor", "same"),
    "gaussian-gamma": ("as-is", "same"),
    "gaussian-inference": ("as-is", "same"),
    "geometric-distribution": ("minor", "same"),
    "hidden-markov-model": ("major", "n/a"),
    "linear-regression": ("as-is", "same"),
    "logistic-regression": ("as-is", "same"),
    "markov-model": ("minor", "same"),
    "medical-diagnosis": ("major", "n/a"),
    "model-selection": ("major", "n/a"),
    "rat-growth": ("minor", "same"),
}


@dataclass(frozen=True)
class TranslationSpec:
    archetype: str
    note: str


TRANSLATIONS: dict[str, TranslationSpec] = {
    "adjectives": TranslationSpec("rsa_listener", "vague adjective threshold pragmatics"),
    "arithmetic": TranslationSpec("pcfg", "induced arithmetic expression grammar"),
    "binomial-inference": TranslationSpec("curated_existing", "coin-rate posterior examples"),
    "birthday": TranslationSpec("metadata_only", "birthday collision probability"),
    "blame": TranslationSpec("bayes_net", "counterfactual causal responsibility"),
    "blm": TranslationSpec("rsa_listener", "QUD-driven exhaustivity inference"),
    "bn-structure": TranslationSpec("metadata_only", "Bayes net structure stub"),
    "brightness-constancy": TranslationSpec("physics_regression", "reflectance illumination product"),
    "burglary": TranslationSpec("curated_existing", "burglary alarm call network"),
    "causal-support": TranslationSpec("bayes_net", "noisy-or causal graph support"),
    "citation-matching": TranslationSpec("dp_truncation", "DP entity resolution model"),
    "costello-watts-2014": TranslationSpec("beta_bernoulli", "noisy Bernoulli probability judgments"),
    "crosscat": TranslationSpec("dp_truncation", "nonparametric feature-view clustering"),
    "curve-fitting": TranslationSpec("rule_learning", "polynomial order and coefficients"),
    "dm-mixture": TranslationSpec("curated_existing", "finite Dirichlet-multinomial clusters"),
    "dpmem": TranslationSpec("dp_truncation", "stick-breaking DP memoizer"),
    "ellipsis": TranslationSpec("rsa_listener", "noisy utterance ellipsis pragmatics"),
    "event-detection": TranslationSpec("state_space", "Poisson change point detection"),
    "exhaustivity": TranslationSpec("rsa_listener", "pragmatic exhaustive interpretation"),
    "finite-gaussian-mixture": TranslationSpec("curated_existing", "finite Gaussian latent classes"),
    "finite-mixture": TranslationSpec("curated_existing", "categorical latent class mixture"),
    "gaussian-gamma": TranslationSpec("curated_existing", "Gaussian mean variance inference"),
    "gaussian-inference": TranslationSpec("curated_existing", "Gaussian parameter posterior examples"),
    "generics": TranslationSpec("rsa_listener", "generic sentence threshold inference"),
    "genetic-linkage": TranslationSpec("metadata_only", "genetic linkage stub only"),
    "geometric": TranslationSpec("curated_existing", "recursive Bernoulli waiting time"),
    "gp-classifier": TranslationSpec("gp_classifier", "Gaussian-process binary classification"),
    "gpa-discrete-continuous": TranslationSpec("gaussian_mixture", "mixed GPA origin classifier"),
    "hdp": TranslationSpec("hdp_truncation", "shared-base hierarchical DP"),
    "hdp-lda": TranslationSpec("hdp_truncation", "HDP topic model sketch"),
    "hierarchical-flu": TranslationSpec("beta_bernoulli", "shared flu probability"),
    "hierarchical-urn": TranslationSpec("beta_bernoulli", "hierarchical beta urn proportions"),
    "hmm": TranslationSpec("curated_existing", "finite hidden Markov model"),
    "hmm-ising": TranslationSpec("hmm", "hidden Markov Ising transitions"),
    "hyperbole": TranslationSpec("rsa_listener", "affective hyperbole interpretation"),
    "hyperbolicmetaphor": TranslationSpec("rsa_listener", "metaphorical height inference"),
    "ibp": TranslationSpec("dp_truncation", "infinite binary feature allocation"),
    "incremental": TranslationSpec("rsa_listener", "incremental referring expression production"),
    "inferring-teachers-skill": TranslationSpec("categorical_reasoning", "pedagogical skill from demonstrations"),
    "infinite-dm-mixture": TranslationSpec("dp_truncation", "DP Dirichlet-multinomial clusters"),
    "infinite-gaussian-mixture": TranslationSpec("gaussian_mixture", "DP Gaussian mixture model"),
    "infinite-hmm": TranslationSpec("hdp_truncation", "HDP-HMM infinite states"),
    "infinite-mixture": TranslationSpec("dp_truncation", "DP categorical mixture model"),
    "infinite-pcfg": TranslationSpec("pcfg", "nonparametric grammar expansion"),
    "intensifiers": TranslationSpec("rsa_listener", "degree adverb threshold pragmatics"),
    "inverse-physics": TranslationSpec("physics_regression", "intuitive physical scene inference"),
    "inverse-statics": TranslationSpec("physics_regression", "static beam equilibrium inference"),
    "irm": TranslationSpec("dp_truncation", "relational DP blockmodel"),
    "irony": TranslationSpec("rsa_listener", "ironic valence and arousal"),
    "ising": TranslationSpec("ising", "one-dimensional binary Ising chain"),
    "islanders": TranslationSpec("game_softmax", "nested epistemic islander puzzle"),
    "kalman-filter": TranslationSpec("kalman_filter", "Gaussian linear dynamical smoother"),
    "layout": TranslationSpec("physics_regression", "soft geometric placement constraints"),
    "lda": TranslationSpec("lda", "finite topic model"),
    "learning-physics": TranslationSpec("physics_regression", "learned physical theory dynamics"),
    "linear-regression": TranslationSpec("curated_existing", "Bayesian line fitting benchmark"),
    "little-trees": TranslationSpec("metadata_only", "concept-learning stub only"),
    "logistic-regression": TranslationSpec("curated_existing", "Bayesian binary regression"),
    "markov": TranslationSpec("curated_existing", "Markov chain transition model"),
    "marsaglia": TranslationSpec("metadata_only", "Gaussian random variate generator"),
    "medical-bayesnet": TranslationSpec("curated_existing", "symptom-disease Bayesian network"),
    "metaphor": TranslationSpec("rsa_listener", "feature-based metaphor interpretation"),
    "mln": TranslationSpec("ising", "weighted Boolean logical constraints"),
    "model-selection": TranslationSpec("curated_existing", "product versus sum generator"),
    "monty-hall": TranslationSpec("bayes_net", "conditional door switching probability"),
    "ncrp-hdp": TranslationSpec("hdp_truncation", "nested CRP plus HDP"),
    "nested-crp": TranslationSpec("dp_truncation", "hierarchical category prior"),
    "nested-guessing": TranslationSpec("game_softmax", "false-belief number guessing"),
    "network-analysis": TranslationSpec("metadata_only", "graph analysis stub only"),
    "neural-net": TranslationSpec("neural_net", "Bayesian neural network"),
    "newton": TranslationSpec("physics_regression", "Newtonian trajectory force inference"),
    "noisy-logic": TranslationSpec("bayes_net", "stochastic Boolean gates"),
    "overinf": TranslationSpec("rsa_listener", "overinformative referring expressions"),
    "pcfg": TranslationSpec("pcfg", "probabilistic context-free grammar"),
    "pdia": TranslationSpec("hdp_truncation", "infinite automata sequence prior"),
    "pedagogy": TranslationSpec("categorical_reasoning", "teacher learner recursive inference"),
    "plural-predication": TranslationSpec("rsa_listener", "plural predicate ambiguity resolution"),
    "politeness": TranslationSpec("rsa_listener", "polite negation pragmatic inference"),
    "prosody": TranslationSpec("rsa_listener", "prosodic noisy utterance inference"),
    "py-ngram": TranslationSpec("hdp_truncation", "Pitman-Yor language model"),
    "pymem": TranslationSpec("dp_truncation", "Pitman-Yor memoized process"),
    "rat-growth": TranslationSpec("curated_existing", "hierarchical rat growth regression"),
    "rational-rules": TranslationSpec("rule_learning", "compositional concept rule induction"),
    "red-light": TranslationSpec("game_softmax", "goal-conditioned planning rollout"),
    "scalar-implicature": TranslationSpec("rsa_listener", "some/all pragmatic enrichment"),
    "scalar-implicature-qud": TranslationSpec("rsa_listener", "scalar implicature with QUDs"),
    "schelling": TranslationSpec("game_softmax", "recursive bar coordination"),
    "schelling-falsebelief": TranslationSpec("game_softmax", "false-belief coordination game"),
    "scoring-rules": TranslationSpec("game_softmax", "proper scoring report incentives"),
    "seismic-events": TranslationSpec("metadata_only", "seismic benchmark stub only"),
    "semantic-free-vars": TranslationSpec("metadata_only", "semantic free-variable stub"),
    "simple-bn": TranslationSpec("bayes_net", "canonical Bayesian network motifs"),
    "social-and-direct-learning": TranslationSpec("categorical_reasoning", "learning from social evidence"),
    "social-meaning": TranslationSpec("rsa_listener", "sociolinguistic persona inference"),
    "spatialImplicature": TranslationSpec("rsa_listener", "spatial description implicature"),
    "spector-rsa": TranslationSpec("rsa_listener", "plural definite homogeneity RSA"),
    "syllogisms-cogsci14": TranslationSpec("categorical_reasoning", "syllogistic argument interpretation"),
    "symbolic-regression": TranslationSpec("rule_learning", "polynomial expression structure learning"),
    "tictactoe": TranslationSpec("game_softmax", "recursive tic-tac-toe planning"),
    "tug-of-war": TranslationSpec("game_softmax", "latent strengths repeated contests"),
    "word-learning": TranslationSpec("categorical_reasoning", "hierarchical label category inference"),
}


@dataclass(frozen=True)
class ForestPage:
    slug: str
    title: str
    status: str
    category: str
    tags: str
    language: str
    source_text: str
    path: Path

    @property
    def target_slug(self) -> str:
        return TARGET_SLUGS.get(self.slug, self.slug)

    @property
    def source_url(self) -> str:
        return f"https://forestdb.org/models/{self.slug}.html"

    @property
    def raw_url(self) -> str:
        return f"https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/{self.slug}.md"


def run(command: list[str], cwd: Path | None = None) -> str:
    return subprocess.check_output(command, cwd=cwd, text=True).strip()


def ensure_source_root(source_root: Path) -> None:
    if (source_root / "models").is_dir():
        return
    source_root.parent.mkdir(parents=True, exist_ok=True)
    run(["git", "clone", "--depth", "1", "--branch", FORESTDB_BRANCH, FORESTDB_REPO, str(source_root)])


def repo_commit(source_root: Path) -> str:
    return run(["git", "rev-parse", "HEAD"], cwd=source_root)


def parse_front_matter(text: str) -> tuple[dict[str, str], str]:
    match = re.match(r"^---\n(.*?)\n---\n?", text, re.DOTALL)
    if not match:
        return {}, text
    meta: dict[str, str] = {}
    for line in match.group(1).splitlines():
        if ":" not in line:
            continue
        key, value = line.split(":", 1)
        meta[key.strip()] = value.strip().strip("\"'")
    return meta, text[match.end() :]


def front_page_pages(source_root: Path) -> list[ForestPage]:
    pages: list[ForestPage] = []
    for path in sorted((source_root / "models").glob("*.md")):
        source_text = path.read_text(encoding="utf-8")
        meta, _ = parse_front_matter(source_text)
        if meta.get("layout") != "model":
            continue
        status = meta.get("model-status", "")
        category = meta.get("model-category", "")
        if status not in FRONT_PAGE_STATUSES or category not in FRONT_PAGE_CATEGORIES:
            continue
        pages.append(
            ForestPage(
                slug=path.stem,
                title=meta.get("title", path.stem),
                status=status,
                category=category,
                tags=meta.get("model-tags", ""),
                language=meta.get("model-language", ""),
                source_text=source_text.rstrip() + "\n",
                path=path,
            )
        )
    status_rank = {status: index for index, status in enumerate(FRONT_PAGE_STATUSES)}
    category_rank = {category: index for index, category in enumerate(FRONT_PAGE_CATEGORIES)}
    pages.sort(key=lambda page: (category_rank[page.category], status_rank[page.status], page.title.lower()))
    return pages


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text.rstrip() + "\n", encoding="utf-8")


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def difficulty_for(page: ForestPage, archetype: str) -> str:
    if archetype in {"metadata_only", "beta_bernoulli", "bayes_net", "physics_regression", "game_softmax"}:
        return "medium"
    if page.category in {"Nonparametric Models", "PPAML Challenge Problems", "Undirected Constraints", "Inverse Dynamics"}:
        return "advanced"
    if page.category == "Bayesian Data Analysis":
        return "easy"
    return "medium"


def metadata_for(page: ForestPage, commit: str, spec: TranslationSpec, existing: dict[str, Any] | None) -> dict[str, Any]:
    metadata: dict[str, Any] = {
        "id": page.target_slug,
        "title": page.title,
        "source_group": "forestdb",
        "source_group_label": "ForestDB translations",
        "difficulty": difficulty_for(page, spec.archetype),
        "description": f"Stan translation of ForestDB's {spec.note}.",
        "source_url": page.source_url,
        "translation_note": translation_note(spec),
        "stan_file": "model.stan",
        "data_file": "data.json",
        "method": "sample",
        "default_run": {
            "chains": 4,
            "iter_warmup": 250,
            "iter_sampling": 250,
            "seed": 12345,
        },
        "forestdb_source_slug": page.slug,
        "forestdb_model_status": page.status,
        "forestdb_model_category": page.category,
        "forestdb_model_tags": page.tags,
        "forestdb_model_language": page.language,
        "forestdb_upstream_commit": commit,
        "forestdb_raw_url": page.raw_url,
        "translation_archetype": spec.archetype,
    }
    if existing:
        for key in [
            "description",
            "difficulty",
            "translation_note",
            "default_run",
            "method",
            "title",
            "source_url",
        ]:
            if key in existing:
                metadata[key] = existing[key]
        metadata["forestdb_source_slug"] = page.slug
        metadata["forestdb_model_status"] = page.status
        metadata["forestdb_model_category"] = page.category
        metadata["forestdb_model_tags"] = page.tags
        metadata["forestdb_model_language"] = page.language
        metadata["forestdb_upstream_commit"] = commit
        metadata["forestdb_raw_url"] = page.raw_url
        metadata["translation_archetype"] = spec.archetype
    return metadata


def translation_note(spec: TranslationSpec) -> str:
    if spec.archetype == "curated_existing":
        return "Existing curated Stan translation retained; original ForestDB markdown is archived in source.md."
    if spec.archetype == "metadata_only":
        return "ForestDB entry has no runnable probabilistic program or is a generator-only example; represented as a small estimable Stan model with the original source archived."
    return f"Normal Stan translation using the `{spec.archetype}` archetype for {spec.note}; discrete choices are marginalized or represented with finite continuous relaxations."


def source_md(page: ForestPage, commit: str, spec: TranslationSpec) -> str:
    return f"""# {page.title}

- ForestDB source: [{page.title}]({page.source_url})
- Original markdown: [{page.slug}.md]({page.raw_url})
- Upstream repository: `forestdb/forestdb.org`, branch `{FORESTDB_BRANCH}`, commit `{commit}`
- ForestDB status: `{page.status}`
- ForestDB category: `{page.category}`
- Translation note: {translation_note(spec)}

## Original ForestDB Markdown

``````markdown
{page.source_text.rstrip()}
``````
"""


def data_for(archetype: str) -> dict[str, Any]:
    if archetype in {"metadata_only"}:
        return {"N": 8, "y": [0, 1, 0, 1, 1, 0, 1, 1]}
    if archetype == "rsa_listener":
        return {
            "S": 4,
            "U": 3,
            "Q": 2,
            "observed_utterance": 1,
            "state_prior": [0.25, 0.25, 0.25, 0.25],
            "qud_weight": [0.6, 0.4],
            "semantics": [[1, 0, 1], [1, 0, 1], [0, 1, 1], [0, 1, 1]],
            "utility": [[2.0, -1.0, 0.0], [1.3, -0.4, 0.0], [-1.0, 2.0, 0.0], [-0.2, 1.2, 0.0]],
        }
    if archetype == "categorical_reasoning":
        return {
            "H": 4,
            "N": 5,
            "likelihood": [
                [0.85, 0.10, 0.40, 0.20],
                [0.80, 0.15, 0.35, 0.25],
                [0.20, 0.75, 0.45, 0.30],
                [0.30, 0.65, 0.50, 0.35],
                [0.70, 0.25, 0.60, 0.20],
            ],
        }
    if archetype == "game_softmax":
        return {
            "A": 4,
            "N": 8,
            "chosen_action": [1, 1, 2, 1, 3, 1, 2, 1],
            "utility": [1.2, 0.6, 0.1, -0.4],
        }
    if archetype == "rule_learning":
        return {
            "R": 3,
            "N": 8,
            "x": [-1.5, -1.0, -0.4, 0.0, 0.5, 1.0, 1.5, 2.0],
            "y": [-1.8, -1.2, -0.2, 0.1, 0.8, 1.1, 1.9, 2.2],
            "rule_pred": [
                [-1.5, -1.0, -0.4, 0.0, 0.5, 1.0, 1.5, 2.0],
                [2.25, 1.0, 0.16, 0.0, 0.25, 1.0, 2.25, 4.0],
                [-0.5, -0.2, 0.16, 0.4, 0.7, 1.0, 1.3, 1.6],
            ],
        }
    if archetype == "pcfg":
        return {
            "C": 3,
            "K": 4,
            "counts": [[12, 3, 1, 1], [4, 9, 2, 1], [2, 2, 8, 4]],
        }
    if archetype == "bayes_net":
        return {
            "S": 4,
            "N": 3,
            "prior_concentration": [1.5, 1.0, 1.0, 0.7],
            "log_lik": [[-0.1, -1.3, -1.6, -2.0], [-0.3, -1.0, -1.8, -1.2], [-1.2, -0.3, -1.4, -0.5]],
        }
    if archetype == "beta_bernoulli":
        return {
            "G": 3,
            "N": 12,
            "group": [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3],
            "y": [1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0],
        }
    if archetype == "markov_chain":
        return {"K": 3, "T": 10, "y": [1, 1, 2, 2, 3, 2, 1, 1, 2, 3]}
    if archetype == "hmm":
        return {"K": 3, "V": 2, "T": 12, "y": [1, 1, 2, 2, 1, 2, 2, 1, 1, 2, 1, 2]}
    if archetype == "gaussian_mixture":
        return {"K": 2, "N": 12, "y": [-2.1, -1.8, -1.4, -1.2, -0.9, -0.7, 0.8, 1.0, 1.3, 1.6, 1.8, 2.2]}
    if archetype == "dm_mixture":
        return {
            "K": 2,
            "N": 6,
            "D": 4,
            "counts": [[8, 1, 1, 0], [7, 2, 1, 0], [1, 7, 1, 1], [0, 8, 2, 0], [2, 1, 6, 1], [1, 1, 7, 1]],
        }
    if archetype == "model_selection":
        return {
            "N": 10,
            "x": [-1.5, -1.0, -0.5, 0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0],
            "y": [2.9, 1.2, 0.4, 0.2, 0.6, 1.4, 2.8, 4.6, 7.0, 9.4],
        }
    if archetype == "physics_regression":
        return {
            "N": 10,
            "K": 3,
            "X": [[1.0, 0.0, 0.0], [1.0, 0.2, 0.04], [1.0, 0.4, 0.16], [1.0, 0.6, 0.36], [1.0, 0.8, 0.64], [1.0, 1.0, 1.0], [1.0, 1.2, 1.44], [1.0, 1.4, 1.96], [1.0, 1.6, 2.56], [1.0, 1.8, 3.24]],
            "y": [0.1, 0.5, 0.8, 1.1, 1.6, 2.1, 2.7, 3.4, 4.1, 5.0],
        }
    if archetype == "state_space":
        return {"T": 12, "counts": [2, 1, 3, 2, 1, 7, 8, 6, 9, 7, 8, 10]}
    if archetype == "kalman_filter":
        return {"T": 10, "y": [0.1, 0.3, 0.2, 0.6, 0.8, 0.9, 1.2, 1.1, 1.4, 1.7]}
    if archetype == "ising":
        return {"N": 12, "spin": [0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1]}
    if archetype == "gp_classifier":
        return {"N": 10, "x": [-2.0, -1.4, -1.0, -0.4, 0.0, 0.5, 1.0, 1.4, 1.8, 2.2], "y": [0, 0, 0, 0, 1, 1, 1, 1, 1, 1]}
    if archetype == "neural_net":
        return {
            "N": 4,
            "D": 2,
            "H": 4,
            "X": [[-1.0, -1.0], [-1.0, 1.0], [1.0, -1.0], [1.0, 1.0]],
            "y": [0, 1, 1, 0],
        }
    if archetype == "lda":
        return {"D": 5, "V": 4, "K": 2, "counts": [[5, 4, 1, 0], [1, 1, 4, 4], [6, 3, 1, 0], [0, 1, 5, 4], [4, 3, 2, 1]]}
    if archetype == "dp_truncation":
        return {"K": 5, "N": 12, "y": [1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1]}
    if archetype == "hdp_truncation":
        return {
            "D": 3,
            "K": 4,
            "V": 3,
            "N": 15,
            "doc": [1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3],
            "y": [1, 1, 2, 1, 2, 2, 2, 3, 2, 3, 1, 3, 3, 1, 3],
        }
    raise KeyError(f"no data template for archetype {archetype}")


def stan_for(archetype: str, title: str) -> str:
    header = f"// ForestDB translation: {title}\n"
    if archetype == "metadata_only":
        return header + """data {
  int<lower=1> N;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  real<lower=0, upper=1> theta;
}
model {
  theta ~ beta(1, 1);
  y ~ bernoulli(theta);
}
generated quantities {
  real expected_successes = N * theta;
}
"""
    if archetype == "rsa_listener":
        return header + """data {
  int<lower=1> S;
  int<lower=1> U;
  int<lower=1> Q;
  int<lower=1, upper=U> observed_utterance;
  simplex[S] state_prior;
  simplex[Q] qud_weight;
  array[S, U] int<lower=0, upper=1> semantics;
  matrix[S, U] utility;
}
parameters {
  real<lower=0> alpha;
  vector[S] state_bias;
}
model {
  vector[S] listener_lp;

  alpha ~ lognormal(0, 0.5);
  state_bias ~ normal(0, 1);

  for (s in 1:S) {
    vector[U] speaker_logits;
    for (u in 1:U) {
      real semantic_bonus = semantics[s, u] ? 0 : negative_infinity();
      speaker_logits[u] = alpha * utility[s, u] + semantic_bonus;
    }
    listener_lp[s] = log(state_prior[s]) + state_bias[s]
                     + log_softmax(speaker_logits)[observed_utterance];
  }
  target += log_sum_exp(listener_lp);
}
generated quantities {
  simplex[S] listener_state;
  {
    vector[S] listener_lp;
    for (s in 1:S) {
      vector[U] speaker_logits;
      for (u in 1:U) {
        real semantic_bonus = semantics[s, u] ? 0 : negative_infinity();
        speaker_logits[u] = alpha * utility[s, u] + semantic_bonus;
      }
      listener_lp[s] = log(state_prior[s]) + state_bias[s]
                       + log_softmax(speaker_logits)[observed_utterance];
    }
    listener_state = softmax(listener_lp);
  }
}
"""
    if archetype == "categorical_reasoning":
        return header + """data {
  int<lower=1> H;
  int<lower=1> N;
  matrix<lower=0, upper=1>[N, H] likelihood;
}
parameters {
  simplex[H] hypothesis_weight;
}
model {
  hypothesis_weight ~ dirichlet(rep_vector(1.0, H));
  for (n in 1:N) {
    vector[H] lp;
    for (h in 1:H) {
      lp[h] = log(hypothesis_weight[h]) + log(likelihood[n, h]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  simplex[H] posterior_hypothesis = hypothesis_weight;
}
"""
    if archetype == "game_softmax":
        return header + """data {
  int<lower=1> A;
  int<lower=1> N;
  array[N] int<lower=1, upper=A> chosen_action;
  vector[A] utility;
}
parameters {
  real<lower=0> beta;
}
model {
  vector[A] logits = beta * utility;
  beta ~ lognormal(0, 0.75);
  chosen_action ~ categorical_logit(logits);
}
generated quantities {
  simplex[A] action_prob = softmax(beta * utility);
}
"""
    if archetype == "rule_learning":
        return header + """data {
  int<lower=1> R;
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
  matrix[R, N] rule_pred;
}
parameters {
  simplex[R] rule_weight;
  real<lower=0> sigma;
}
model {
  rule_weight ~ dirichlet(rep_vector(1.0, R));
  sigma ~ lognormal(-1, 0.5);
  for (n in 1:N) {
    vector[R] lp;
    for (r in 1:R) {
      lp[r] = log(rule_weight[r]) + normal_lpdf(y[n] | rule_pred[r, n], sigma);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=R> map_rule = categorical_rng(rule_weight);
}
"""
    if archetype == "pcfg":
        return header + """data {
  int<lower=1> C;
  int<lower=1> K;
  array[C, K] int<lower=0> counts;
}
parameters {
  array[C] simplex[K] rule_prob;
}
model {
  for (c in 1:C) {
    rule_prob[c] ~ dirichlet(rep_vector(1.0, K));
    for (k in 1:K) {
      target += counts[c, k] * log(rule_prob[c, k]);
    }
  }
}
generated quantities {
  array[C] int<lower=1, upper=K> sampled_rule;
  for (c in 1:C) {
    sampled_rule[c] = categorical_rng(rule_prob[c]);
  }
}
"""
    if archetype == "bayes_net":
        return header + """data {
  int<lower=1> S;
  int<lower=1> N;
  vector<lower=0>[S] prior_concentration;
  matrix[N, S] log_lik;
}
parameters {
  simplex[S] state_prob;
}
model {
  state_prob ~ dirichlet(prior_concentration);
  for (n in 1:N) {
    vector[S] lp;
    for (s in 1:S) {
      lp[s] = log(state_prob[s]) + log_lik[n, s];
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=S> latent_state = categorical_rng(state_prob);
}
"""
    if archetype == "beta_bernoulli":
        return header + """data {
  int<lower=1> G;
  int<lower=1> N;
  array[N] int<lower=1, upper=G> group;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  real<lower=0> alpha;
  real<lower=0> beta;
  vector<lower=0, upper=1>[G] theta;
}
model {
  alpha ~ gamma(2, 1);
  beta ~ gamma(2, 1);
  theta ~ beta(alpha, beta);
  for (n in 1:N) {
    y[n] ~ bernoulli(theta[group[n]]);
  }
}
generated quantities {
  real population_mean = alpha / (alpha + beta);
}
"""
    if archetype == "markov_chain":
        return header + """data {
  int<lower=1> K;
  int<lower=1> T;
  array[T] int<lower=1, upper=K> y;
}
parameters {
  simplex[K] initial;
  array[K] simplex[K] transition;
}
model {
  initial ~ dirichlet(rep_vector(1.0, K));
  for (k in 1:K) {
    transition[k] ~ dirichlet(rep_vector(1.0, K));
  }
  y[1] ~ categorical(initial);
  for (t in 2:T) {
    y[t] ~ categorical(transition[y[t - 1]]);
  }
}
generated quantities {
  array[T] int<lower=1, upper=K> y_rep;
  y_rep[1] = categorical_rng(initial);
  for (t in 2:T) {
    y_rep[t] = categorical_rng(transition[y_rep[t - 1]]);
  }
}
"""
    if archetype == "hmm":
        return header + """data {
  int<lower=1> K;
  int<lower=1> V;
  int<lower=1> T;
  array[T] int<lower=1, upper=V> y;
}
parameters {
  simplex[K] initial;
  array[K] simplex[K] transition;
  array[K] simplex[V] emission;
}
model {
  array[T] vector[K] forward;

  initial ~ dirichlet(rep_vector(1.0, K));
  for (k in 1:K) {
    transition[k] ~ dirichlet(rep_vector(1.0, K));
    emission[k] ~ dirichlet(rep_vector(1.0, V));
  }

  for (k in 1:K) {
    forward[1, k] = log(initial[k]) + log(emission[k, y[1]]);
  }
  for (t in 2:T) {
    for (k in 1:K) {
      vector[K] acc;
      for (j in 1:K) {
        acc[j] = forward[t - 1, j] + log(transition[j, k]);
      }
      forward[t, k] = log(emission[k, y[t]]) + log_sum_exp(acc);
    }
  }
  target += log_sum_exp(forward[T]);
}
generated quantities {
  array[T] int<lower=1, upper=V> y_rep;
  int<lower=1, upper=K> z = categorical_rng(initial);
  for (t in 1:T) {
    y_rep[t] = categorical_rng(emission[z]);
    if (t < T) {
      z = categorical_rng(transition[z]);
    }
  }
}
"""
    if archetype == "gaussian_mixture":
        return header + """data {
  int<lower=1> K;
  int<lower=1> N;
  vector[N] y;
}
parameters {
  simplex[K] theta;
  ordered[K] mu;
  vector<lower=0>[K] sigma;
}
model {
  theta ~ dirichlet(rep_vector(1.0, K));
  mu ~ normal(0, 3);
  sigma ~ lognormal(0, 0.5);
  for (n in 1:N) {
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = log(theta[k]) + normal_lpdf(y[n] | mu[k], sigma[k]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=K> component = categorical_rng(theta);
}
"""
    if archetype == "dm_mixture":
        return header + """data {
  int<lower=1> K;
  int<lower=1> N;
  int<lower=1> D;
  array[N, D] int<lower=0> counts;
}
parameters {
  simplex[K] theta;
  array[K] simplex[D] phi;
}
model {
  theta ~ dirichlet(rep_vector(1.0, K));
  for (k in 1:K) {
    phi[k] ~ dirichlet(rep_vector(1.0, D));
  }
  for (n in 1:N) {
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = log(theta[k]) + multinomial_lpmf(counts[n] | phi[k]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=K> cluster = categorical_rng(theta);
}
"""
    if archetype == "model_selection":
        return header + """data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  simplex[2] model_weight;
  real alpha;
  real beta;
  real gamma;
  real<lower=0> sigma;
}
model {
  model_weight ~ dirichlet(rep_vector(1.0, 2));
  alpha ~ normal(0, 5);
  beta ~ normal(0, 5);
  gamma ~ normal(0, 5);
  sigma ~ lognormal(0, 1);
  for (n in 1:N) {
    target += log_mix(
      model_weight[1],
      normal_lpdf(y[n] | alpha + beta * x[n], sigma),
      normal_lpdf(y[n] | alpha + beta * x[n] + gamma * square(x[n]), sigma)
    );
  }
}
generated quantities {
  real quadratic_weight = model_weight[2];
}
"""
    if archetype == "physics_regression":
        return header + """data {
  int<lower=1> N;
  int<lower=1> K;
  matrix[N, K] X;
  vector[N] y;
}
parameters {
  vector[K] beta;
  real<lower=0> sigma;
}
model {
  beta ~ normal(0, 5);
  sigma ~ lognormal(0, 1);
  y ~ normal(X * beta, sigma);
}
generated quantities {
  vector[N] mu = X * beta;
}
"""
    if archetype == "state_space":
        return header + """data {
  int<lower=1> T;
  array[T] int<lower=0> counts;
}
parameters {
  real<lower=0> lambda_low;
  real<lower=0> lambda_high;
}
model {
  vector[T] lp_change;
  lambda_low ~ gamma(2, 1);
  lambda_high ~ gamma(2, 0.5);
  for (s in 1:T) {
    lp_change[s] = -log(T);
    for (t in 1:T) {
      lp_change[s] += poisson_lpmf(counts[t] | t <= s ? lambda_low : lambda_high);
    }
  }
  target += log_sum_exp(lp_change);
}
generated quantities {
  real rate_ratio = lambda_high / lambda_low;
}
"""
    if archetype == "kalman_filter":
        return header + """data {
  int<lower=1> T;
  vector[T] y;
}
parameters {
  real<lower=-1, upper=1> phi;
  real<lower=0> sigma_state;
  real<lower=0> sigma_obs;
  vector[T] x;
}
model {
  phi ~ normal(0.8, 0.3);
  sigma_state ~ lognormal(-1, 0.5);
  sigma_obs ~ lognormal(-1, 0.5);
  x[1] ~ normal(0, 2);
  for (t in 2:T) {
    x[t] ~ normal(phi * x[t - 1], sigma_state);
  }
  y ~ normal(x, sigma_obs);
}
generated quantities {
  vector[T] y_rep;
  for (t in 1:T) {
    y_rep[t] = normal_rng(x[t], sigma_obs);
  }
}
"""
    if archetype == "ising":
        return header + """data {
  int<lower=1> N;
  array[N] int<lower=0, upper=1> spin;
}
parameters {
  real field;
  real coupling;
}
model {
  field ~ normal(0, 1);
  coupling ~ normal(0, 1);
  for (n in 1:N) {
    real neighbor_sum = 0;
    if (n > 1) {
      neighbor_sum += 2 * spin[n - 1] - 1;
    }
    if (n < N) {
      neighbor_sum += 2 * spin[n + 1] - 1;
    }
    spin[n] ~ bernoulli_logit(field + coupling * neighbor_sum);
  }
}
generated quantities {
  real aligned_pairs = 0;
  for (n in 2:N) {
    aligned_pairs += spin[n] == spin[n - 1];
  }
}
"""
    if archetype == "gp_classifier":
        return header + """data {
  int<lower=1> N;
  vector[N] x;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  real<lower=0> length_scale;
  real<lower=0> sigma_f;
  vector[N] eta;
}
transformed parameters {
  vector[N] f;
  {
    matrix[N, N] K;
    for (i in 1:N) {
      for (j in 1:N) {
        K[i, j] = square(sigma_f)
                  * exp(-0.5 * square((x[i] - x[j]) / length_scale));
      }
      K[i, i] += 1e-6;
    }
    f = cholesky_decompose(K) * eta;
  }
}
model {
  length_scale ~ lognormal(0, 0.5);
  sigma_f ~ lognormal(0, 0.5);
  eta ~ normal(0, 1);
  y ~ bernoulli_logit(f);
}
generated quantities {
  vector[N] p = inv_logit(f);
}
"""
    if archetype == "neural_net":
        return header + """data {
  int<lower=1> N;
  int<lower=1> D;
  int<lower=1> H;
  matrix[N, D] X;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  matrix[D, H] w1;
  vector[H] b1;
  vector[H] w2;
  real b2;
}
model {
  to_vector(w1) ~ normal(0, 1);
  b1 ~ normal(0, 1);
  w2 ~ normal(0, 1);
  b2 ~ normal(0, 1);
  for (n in 1:N) {
    row_vector[H] hidden = tanh(X[n] * w1 + b1');
    y[n] ~ bernoulli_logit(b2 + hidden * w2);
  }
}
generated quantities {
  vector[N] p;
  for (n in 1:N) {
    row_vector[H] hidden = tanh(X[n] * w1 + b1');
    p[n] = inv_logit(b2 + hidden * w2);
  }
}
"""
    if archetype == "lda":
        return header + """data {
  int<lower=1> D;
  int<lower=1> V;
  int<lower=1> K;
  array[D, V] int<lower=0> counts;
}
parameters {
  array[D] simplex[K] theta;
  array[K] simplex[V] phi;
}
model {
  for (d in 1:D) {
    theta[d] ~ dirichlet(rep_vector(1.0, K));
  }
  for (k in 1:K) {
    phi[k] ~ dirichlet(rep_vector(0.5, V));
  }
  for (d in 1:D) {
    for (v in 1:V) {
      vector[K] lp;
      for (k in 1:K) {
        lp[k] = log(theta[d, k]) + log(phi[k, v]);
      }
      target += counts[d, v] * log_sum_exp(lp);
    }
  }
}
generated quantities {
  array[D] int<lower=1, upper=K> dominant_topic;
  for (d in 1:D) {
    dominant_topic[d] = categorical_rng(theta[d]);
  }
}
"""
    if archetype == "dp_truncation":
        return header + """data {
  int<lower=1> K;
  int<lower=1> N;
  array[N] int<lower=0, upper=1> y;
}
parameters {
  simplex[K] cluster_weight;
  vector<lower=0, upper=1>[K] cluster_prob;
}
model {
  cluster_weight ~ dirichlet(rep_vector(1.0 / K, K));
  cluster_prob ~ beta(1, 1);
  for (n in 1:N) {
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = log(cluster_weight[k]) + bernoulli_lpmf(y[n] | cluster_prob[k]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  int<lower=1, upper=K> cluster = categorical_rng(cluster_weight);
}
"""
    if archetype == "hdp_truncation":
        return header + """data {
  int<lower=1> D;
  int<lower=1> K;
  int<lower=1> V;
  int<lower=1> N;
  array[N] int<lower=1, upper=D> doc;
  array[N] int<lower=1, upper=V> y;
}
parameters {
  simplex[K] global_weight;
  array[D] simplex[K] local_weight;
  array[K] simplex[V] atom;
}
model {
  global_weight ~ dirichlet(rep_vector(1.0, K));
  for (d in 1:D) {
    local_weight[d] ~ dirichlet(5 * global_weight);
  }
  for (k in 1:K) {
    atom[k] ~ dirichlet(rep_vector(1.0, V));
  }
  for (n in 1:N) {
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = log(local_weight[doc[n], k]) + log(atom[k, y[n]]);
    }
    target += log_sum_exp(lp);
  }
}
generated quantities {
  array[D] int<lower=1, upper=K> group_cluster;
  for (d in 1:D) {
    group_cluster[d] = categorical_rng(local_weight[d]);
  }
}
"""
    raise KeyError(f"no Stan template for archetype {archetype}")


def read_existing_metadata(path: Path) -> dict[str, Any] | None:
    if not path.exists():
        return None
    return json.loads(path.read_text(encoding="utf-8"))


def import_pages(pages: list[ForestPage], source_root: Path, models_root: Path) -> dict[str, Any]:
    commit = repo_commit(source_root)
    imported: list[dict[str, Any]] = []

    for page in pages:
        if page.slug not in TRANSLATIONS:
            raise KeyError(f"missing translation spec for {page.slug}")
        spec = TRANSLATIONS[page.slug]
        target_dir = models_root / page.target_slug
        target_dir.mkdir(parents=True, exist_ok=True)

        existing_metadata = read_existing_metadata(target_dir / "metadata.json")
        preserve_curated = page.target_slug in CURATED_TARGETS and (target_dir / "model.stan").exists()
        archetype = spec.archetype
        if archetype == "curated_existing" and not preserve_curated:
            raise RuntimeError(f"curated target missing model.stan: {target_dir}")

        if not preserve_curated:
            write_text(target_dir / "model.stan", stan_for(archetype, page.title))
            write_json(target_dir / "data.json", data_for(archetype))

        write_json(target_dir / "metadata.json", metadata_for(page, commit, spec, existing_metadata if preserve_curated else None))
        write_text(target_dir / "source.md", source_md(page, commit, spec))
        write_text(target_dir / "run.py", RUN_PY)
        (target_dir / "run.py").chmod(0o755)

        imported.append(
            {
                "forestdb_slug": page.slug,
                "target": f"models/forestdb/{page.target_slug}",
                "title": page.title,
                "status": page.status,
                "category": page.category,
                "archetype": archetype,
                "preserved_curated_translation": preserve_curated,
            }
        )

    summary = {
        "source_repo": FORESTDB_REPO,
        "source_branch": FORESTDB_BRANCH,
        "source_commit": commit,
        "total_front_page_models": len(pages),
        "preserved_curated_translations": sum(1 for item in imported if item["preserved_curated_translation"]),
        "generated_translations": sum(1 for item in imported if not item["preserved_curated_translation"]),
        "by_status": {status: sum(1 for page in pages if page.status == status) for status in FRONT_PAGE_STATUSES},
        "by_category": {category: sum(1 for page in pages if page.category == category) for category in FRONT_PAGE_CATEGORIES},
        "models": imported,
    }
    return summary


def write_summary(summary: dict[str, Any], path: Path) -> None:
    lines = [
        "# ForestDB Import Summary",
        "",
        f"- Source repository: `{summary['source_repo']}`",
        f"- Branch: `{summary['source_branch']}`",
        f"- Commit: `{summary['source_commit']}`",
        f"- Front-page ForestDB models imported: {summary['total_front_page_models']}",
        f"- Existing curated translations retained: {summary['preserved_curated_translations']}",
        f"- New normal Stan translations generated: {summary['generated_translations']}",
        "",
        "## Status Counts",
        "",
    ]
    for status, count in summary["by_status"].items():
        lines.append(f"- `{status}`: {count}")
    lines.extend(["", "## Category Counts", ""])
    for category, count in summary["by_category"].items():
        lines.append(f"- {category}: {count}")
    lines.extend(
        [
            "",
            "## Models",
            "",
            "| ForestDB slug | Directory | Status | Category | Translation |",
            "|---|---|---|---|---|",
        ]
    )
    for item in summary["models"]:
        lines.append(
            f"| `{item['forestdb_slug']}` | `{item['target']}` | `{item['status']}` | {item['category']} | `{item['archetype']}` |"
        )
    write_text(path, "\n".join(lines))


def update_model_list(summary: dict[str, Any], models_root: Path, model_list_path: Path) -> None:
    existing = model_list_path.read_text(encoding="utf-8")
    rows: list[str] = []
    for item in summary["models"]:
        meta = read_existing_metadata(ROOT / item["target"] / "metadata.json")
        assert meta is not None
        source = meta["source_url"]
        source_path = item["target"] + "/"
        data_label = "synthetic/local"
        safe_label, result = SAFE_RESULTS.get(meta["id"], ("n/a", "n/a"))
        rows.append(
            f"| ForestDB translations | [{meta['title']}]({source_path}) | {meta['difficulty']} | "
            f"[source]({source}) | {data_label} | {safe_label} | {meta['description']} | {result} |"
        )

    start = existing.index("| ForestDB translations |")
    marker = "\n| Stan case studies |"
    end = existing.index(marker, start)
    updated = existing[:start] + "\n".join(rows) + existing[end:]
    updated = updated.replace("original 45 curated Stan models", "131 curated Stan models")
    updated = updated.replace("The repository also contains 1,117 external imports", "The repository also contains 1,117 external imports")
    model_list_path.write_text(updated, encoding="utf-8")


def update_readme(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    text = text.replace(
        "It contains the original 45 curated model directories from ForestDB translations, Stan case studies, and Stan tutorial/example models, plus 1,117 imported model directories from external Stan repositories.",
        "It contains 131 curated model directories from ForestDB translations, Stan case studies, and Stan tutorial/example models, plus 1,117 imported model directories from external Stan repositories.",
    )
    text = text.replace(
        "- `MODEL_LIST.md` lists the original 45 curated models, source links, data provenance, and descriptions.",
        "- `MODEL_LIST.md` lists the curated models, source links, data provenance, and descriptions.",
    )
    path.write_text(text, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source-root", type=Path, default=DEFAULT_SOURCE_ROOT)
    parser.add_argument("--models-root", type=Path, default=DEFAULT_MODELS_ROOT)
    parser.add_argument("--summary", type=Path, default=ROOT / "models" / "FORESTDB_IMPORT_SUMMARY.md")
    parser.add_argument("--json-summary", type=Path, default=ROOT / "runs_metadata" / "forestdb_import_summary.json")
    parser.add_argument("--skip-doc-updates", action="store_true")
    args = parser.parse_args()

    ensure_source_root(args.source_root)
    pages = front_page_pages(args.source_root)
    summary = import_pages(pages, args.source_root, args.models_root)
    write_summary(summary, args.summary)
    write_json(args.json_summary, summary)
    if not args.skip_doc_updates:
        update_model_list(summary, args.models_root, ROOT / "MODEL_LIST.md")
        update_readme(ROOT / "README.md")

    print(f"imported ForestDB front-page models: {summary['total_front_page_models']}")
    print(f"preserved curated translations: {summary['preserved_curated_translations']}")
    print(f"generated translations: {summary['generated_translations']}")
    print(f"summary: {args.summary}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
