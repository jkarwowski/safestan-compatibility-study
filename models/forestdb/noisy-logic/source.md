# Noisy Logic

- ForestDB source: [Noisy Logic](https://forestdb.org/models/noisy-logic.html)
- Original markdown: [noisy-logic.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/noisy-logic.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Miscellaneous`
- Translation note: Normal Stan translation using the `bayes_net` archetype for stochastic Boolean gates; discrete choices are marginalized or represented with finite continuous relaxations.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Noisy Logic
model-status: code
model-category: Miscellaneous
model-tags: logic, library
model-language: church
---

The functions `noisy-and` and `noisy-or` are commonly used to model stochastic dependencies between random variables.

    (define (noisy-equal? noise x y)
      (flip (if (equal? x y)
                1.0
                noise)))
          
    (define (noisify v noise)
      (flip (if v (- 1 noise) noise)))
    
    (define (noisify-all l noise)
      (map (lambda (v) (noisify v noise)) l))
    
    (define noisy-and
       (lambda args
         (let ((noise  (first args))
               (values (rest args)))
           (all (noisify-all values noise)))))
    
    (define noisy-or
       (lambda args
         (let ((noise  (first args))
               (values (rest args)))
           (any (noisify-all values noise)))))
    
    (define (show thunk title)
      (barplot (enumeration-query (define _ 1) (thunk) #t) title))
    
    (show (lambda () (noisy-and .1 #t #f))
          "(noisy-and .1 #t #f)")
    
    (show (lambda () (noisy-and .3 #t #f))
          "(noisy-and .3 #t #f)")
    
    (show (lambda () (noisy-or .1 #t #f))
          "(noisy-or .1 #t #f)")
    
    (show (lambda () (noisy-or .3 #t #f))
          "(noisy-or .3 #t #f)")
    
    (show (lambda () (noisy-equal? .3 #t #t))
          "(noisy-equal? .3 #t #t)")
    
    (show (lambda () (noisy-equal? .3 #t #f))
          "(noisy-equal? .3 #t #f)")
``````
