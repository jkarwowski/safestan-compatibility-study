# Bayesian Logistic Regression

- ForestDB source: [Bayesian Logistic Regression](https://forestdb.org/models/logistic-regression.html)
- Original markdown: [logistic-regression.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/logistic-regression.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Machine Learning`
- Translation note: Existing curated Stan translation retained; original ForestDB markdown is archived in source.md.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Bayesian Logistic Regression
model-status: code
model-category: Machine Learning
model-tags: machine learning
model-language: church
---

Logistic regression predicts a discrete class probability based on a continuous input. The model below is based on the [Anglican implementation of logistic regression](http://www.robots.ox.ac.uk/~fwood/anglican/examples/logistic_regression/).

    (define xs '(-10 -5 2 6 10))
    (define labels '(#f #f #t #t #t))
    
    (define samples
      (mh-query 
    
       1000 10
    
       (define m (gaussian 0 1))
       (define b (gaussian 0 1))
       (define sigma-squared (gamma 1 1))
    
       (define (y x)
         (gaussian (+ (* m x) b) sigma-squared))
    
       (define (sigmoid x)
         (/ 1 (+ 1 (exp (* -1 (y x))))))
    
       (sigmoid 8)
    
       (all
        (map (lambda (x label) (equal? (flip (sigmoid x) label) label))
             xs
             labels))))
    
    (density samples "P(label=#t) for x=8" #t)
    
References:

- [Logistic Regression in Anglican](http://www.robots.ox.ac.uk/~fwood/anglican/examples/logistic_regression/)
``````
