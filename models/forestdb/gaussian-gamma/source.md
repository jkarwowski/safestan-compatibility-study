# 1D Gaussian with Gaussian/Gamma Hyperparameters

- ForestDB source: [1D Gaussian with Gaussian/Gamma Hyperparameters](https://forestdb.org/models/gaussian-gamma.html)
- Original markdown: [gaussian-gamma.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/gaussian-gamma.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Miscellaneous`
- Translation note: Existing curated Stan translation retained; original ForestDB markdown is archived in source.md.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: 1D Gaussian with Gaussian/Gamma Hyperparameters
model-status: code
model-category: Miscellaneous
model-tags: continuous models, gaussian distribution
model-language: church
---

One-dimensional Gaussian distribution with mean and variance
sampled from Gaussian/gamma priors

~~~~
(define xdata '(1 1.2 1.5 0.8 0.9 1 1.3 0.9))

(define samples
  (mh-query
   1000 10
   (define mu (gaussian 0 2))
   (define sigma-squared (gamma 1 1))
   
   mu

   (all
    (map (lambda (x) (equal? (gaussian mu sigma-squared x) x)) xdata)
    )))

(density samples "Posterior over mu" #t)
~~~~
``````
