# Grade Inflation

- ForestDB source: [Grade Inflation](https://forestdb.org/models/gpa-discrete-continuous.html)
- Original markdown: [gpa-discrete-continuous.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/gpa-discrete-continuous.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Miscellaneous`
- Translation note: Normal Stan translation using the `gaussian_mixture` archetype for mixed GPA origin classifier; discrete choices are marginalized or represented with finite continuous relaxations.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Grade Inflation
model-status: code
model-category: Miscellaneous
model-tags: discrete, continuous
model-language: church
---

This is an example of a mixed discrete-continuous model.

    (define (american_gpa) 
      (if (flip .9) 
          (* 4 (beta 5 5)) 
          (* 4 (if (flip .8) 1 0))))
    
    (define (indian_gpa)
      (if (flip .85) 
          (* 10 (beta 5 5)) 
          (* 10 (if (flip .7) 1 0))))
    
    (define observed-gpa 4.0)
    
    (define samples
      (mh-query 
    
       1000 10
    
       (define university_location 
         (if (flip .5) 'USA 'India))
    
       (define student_gpa 
         (if (eq? university_location 'USA) 
             (american_gpa) 
             (indian_gpa)))
    
       university_location
    
       (= (gaussian student_gpa 0.01) 
          observed-gpa)))
    
    (hist samples)
    
References:

- [American/Indian GPA example in Anglican](http://www.robots.ox.ac.uk/~fwood/anglican/examples/american_indian_gpa/)
``````
