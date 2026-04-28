# Markov Logic Network

- ForestDB source: [Markov Logic Network](https://forestdb.org/models/mln.html)
- Original markdown: [mln.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/mln.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Miscellaneous`
- Translation note: Normal Stan translation using the `ising` archetype for weighted Boolean logical constraints; discrete choices are marginalized or represented with finite continuous relaxations.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Markov Logic Network
model-status: code
model-category: Miscellaneous
model-tags: mln
model-language: church
---

Example Markov Logic Network from Richardson, M., & Domingos, P. (2006). Markov logic networks. Machine learning, 62(1-2), 107-136.

    (define (implies x y) (or (not x) y))
    
    (define samples
      (mh-query 1000 100
        (define people (list 'anna 'bob))
        (define smokes (mem (lambda (person) (flip))))
        (define cancer (mem (lambda (person) (flip))))
        (define friends (mem (lambda (x y) (flip))))
    
        (define smokes-cancer (sum (map 
          (lambda (x) (if (implies (smokes x) (cancer x)) 0 -1.5)) 
          people
        )))
        (define friends-smoke (sum (map
            (lambda (x) (sum (map
              (lambda (y) (if (implies (friends x y) (eq? (smokes x) (smokes y))) 0 -1.1))
              people
              )))
            people
        )))    
        (define model (+ smokes-cancer friends-smoke))
        (define evidence (and (smokes 'anna) (friends 'anna 'bob)))
    
        (cancer 'bob)
    
        (and evidence (< (uniform 0 1) (exp model)))
      )
    )
    (hist samples)


Another version of the above, slightly more idiomatic for WebChurch in that it uses `factor` statements to add the log-probability contributions locally:

~~~
(define (implies x y) (or (not x) y))

(define samples
  (mh-query 1000 100
    (define people (list 'anna 'bob))
    (define smokes (mem (lambda (person) (flip))))
    (define cancer (mem (lambda (person) (flip))))
    (define friends (mem (lambda (x y) (flip))))

    (define smokes-cancer  
      (map 
       (lambda (x) (factor (if (implies (smokes x) (cancer x)) 0 -1.5)))
       people))
            
    (define friends-smoke 
      (map
       (lambda (x) 
         (map
          (lambda (y) 
            (factor (if (implies (friends x y) (eq? (smokes x) (smokes y))) 0 -1.1)))
          people))
        people))    
            
    (define evidence (and (smokes 'anna) (friends 'anna 'bob)))

    (cancer 'bob)

    (condition evidence)
  )
)
(hist samples)
~~~
``````
