# Hierarchical Flu/Cough Model

- ForestDB source: [Hierarchical Flu/Cough Model](https://forestdb.org/models/hierarchical-flu.html)
- Original markdown: [hierarchical-flu.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/hierarchical-flu.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Miscellaneous`
- Translation note: Normal Stan translation using the `beta_bernoulli` archetype for shared flu probability; discrete choices are marginalized or represented with finite continuous relaxations.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Hierarchical Flu/Cough Model
model-status: code
model-category: Miscellaneous
model-tags: hierarchical, medicine, mem
model-language: church
---

    (define flu-dist
      (repeat 
       1000
       (lambda ()
         (rejection-query
          
          ;; model
          (define flu-probability (uniform 0 1))
          (define flu (mem (lambda (person) (flip flu-probability))))
          (define cough
            (mem 
             (lambda (person)
               (if (flu person)
                   (flip .85)
                   (flip .1)))))
          
          ;; query
          (flu 'jim)
          
          ;; condition
          (and (cough 'bob) 
               (flu 'mary)
               (flu 'jane))))))
    
    (hist flu-dist)
``````
