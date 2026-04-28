# Burglary Bayesnet

- ForestDB source: [Burglary Bayesnet](https://forestdb.org/models/burglary.html)
- Original markdown: [burglary.md](https://raw.githubusercontent.com/forestdb/forestdb.org/gh-pages/models/burglary.md)
- Upstream repository: `forestdb/forestdb.org`, branch `gh-pages`, commit `e5ac903422815b645acbae784c2e5645ba55fe70`
- ForestDB status: `code`
- ForestDB category: `Miscellaneous`
- Translation note: Existing curated Stan translation retained; original ForestDB markdown is archived in source.md.

## Original ForestDB Markdown

``````markdown
---
layout: model
title: Burglary Bayesnet
model-status: code
model-category: Miscellaneous
model-tags: bayesnet, simple
model-language: church
---

The Burglary Bayes net is a simple network that illustrates nodes with multiple incoming and outgoing causal links. Burglary and earthquake both cause the alarm to go off. The alarm can cause either or both of Mary and John to call.

    (define burglary-dist
      (enumeration-query
       (define burglary (flip .1))
       (define earthquake (flip .2))
       (define alarm (flip (if burglary
                               (if earthquake .95 .94)
                               (if earthquake .29 .001))))
       (define john-calls (flip (if alarm .9 .05)))
       (define mary-calls (flip (if alarm .7 .01)))
       (if burglary 'burglary 'no-burglary)
       john-calls))
    
    (barplot burglary-dist)
``````
