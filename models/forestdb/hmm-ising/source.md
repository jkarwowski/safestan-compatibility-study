# HMM-Ising

- ForestDB source: [HMM-Ising](https://forestdb.org/models/hmm-ising.html)
- Original markdown: [hmm-ising.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/hmm-ising.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code-fail`
- ForestDB category: `Undirected Constraints`
- Translation note: Normal Stan translation using the `hmm` archetype for hidden Markov Ising transitions; discrete choices are marginalized or represented with finite continuous relaxations.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: HMM-Ising
model-status: code-fail
model-status-verbose: drop-right is not implemented.
model-category: Undirected Constraints
model-tags: language, nested conditioning
model-language: church
---

A doubly-intractable HMM, meant as a toy model for speech
recognition with articulatory contraints.

    (define (hmm state N)
      (if (= N 0)
          '()
          (pair (observe state)
                (hmm (transition state) (- N 1)))))
    
    (define (observe state)
      (map (lambda (x) (if (flip .9) x (not x)))
           state))
    
    (define (language-transition state)
      (map (lambda (x) (if (flip .8) x (not x)))
           state))
    
    (define (factor a b)
      (flip (if (equal? a b) 1.0 0.5)))
    
    (define (transition state)
      (mh-query
       10 10
       (define new-state (language-transition state))
       new-state
       (all (map factor (drop new-state 1) (drop-right new-state 1)))))
    
    (hmm '(#f #f #f) 4)
``````
