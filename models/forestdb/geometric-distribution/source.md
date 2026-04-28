# Geometric Distribution

- ForestDB source: [Geometric Distribution](https://forestdb.org/models/geometric.html)
- Original markdown: [geometric.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/geometric.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Miscellaneous`
- Translation note: Existing curated Stan translation retained; original ForestDB markdown is archived in source.md.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Geometric Distribution
model-status: code
model-category: Miscellaneous
model-tags: recursion
model-language: church
---

A simple recursively defined distribution on the integers.

    (define (geometric p)
      (if (flip p)
          0
          (+ 1 (geometric p))))
    
    (hist (repeat 300 (lambda () (geometric .5))))
    
Alternatively, we can write the geometric distribution in tail-recursive form:
    
    (define (geometric-tail p n)
      (if (flip p)
          n
          (geometric-tail p (+ n 1))))
    
    (hist (repeat 300 (lambda () (geometric-tail .5 0))))
``````
