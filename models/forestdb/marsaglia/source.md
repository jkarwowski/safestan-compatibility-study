# Marsaglia

- ForestDB source: [Marsaglia](https://forestdb.org/models/marsaglia.html)
- Original markdown: [marsaglia.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/marsaglia.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Miscellaneous`
- Translation note: ForestDB entry has no runnable probabilistic program or is a generator-only example; represented as a small estimable Stan model with the original source archived.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Marsaglia
model-status: code
model-category: Miscellaneous
model-tags: random-variate 
model-language: church
---

This model implements the rejection form of the Box-Muller for generating Gaussian random numbers given a source of uniformly distributed random numbers.

    (define (marsaglia-normal mean variance) 
       (define x (uniform -1.0 1.0)) 
       (define y (uniform -1.0 1.0)) 
       (define s (+ (* x x) (* y y)))
       (if (< s 1)
           (+ mean (* (sqrt variance)
                      (* x (sqrt (* -2 (/ (log s) s))))))
           (marsaglia-normal mean variance)))
    
    (density (repeat 1000 (lambda () (marsaglia-normal 5 1))))

References:

- Cite:marsaglia1964convenient
- Cite:wood2014new
``````
