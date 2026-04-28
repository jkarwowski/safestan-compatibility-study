# Schelling Coordination Game with False Belief

- ForestDB source: [Schelling Coordination Game with False Belief](https://forestdb.org/models/schelling-falsebelief.html)
- Original markdown: [schelling-falsebelief.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/schelling-falsebelief.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Reasoning about Reasoning`
- Translation note: Normal Stan translation using the `game_softmax` archetype for false-belief coordination game; discrete choices are marginalized or represented with finite continuous relaxations.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Schelling Coordination Game with False Belief
model-status: code
model-category: Reasoning about Reasoning
model-tags: theory of mind, game theory
model-language: church
---

Bob believes that Alice wants to meet him, and Alice knows this,
but in fact Alice wants to avoid Bob.

    (define (sample-location)
      (if (flip .55)
          'good-bar
          'bad-bar))
    
    (define (alice* depth)
      (rejection-query
       (define alice*-location (sample-location))
       alice*-location
       (not (equal? alice*-location (bob (- depth 1))))))
    
    (define (alice depth)
      (rejection-query
       (define alice-location (sample-location))
       alice-location
       (equal? alice-location (bob (- depth 1)))))
    
    (define (bob depth)
      (rejection-query
       (define bob-location (sample-location))
       bob-location
       (if (= depth 0)
           #t
           (equal? bob-location (alice depth)))))
    
    (hist (repeat 10 (lambda () (alice* 3))))

References:

- Cite:Schelling1960
- Cite:Stuhlmueller2013aa
``````
