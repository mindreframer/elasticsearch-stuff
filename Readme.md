## ElasticSearch
  - https://www.found.no/foundation/
    - https://www.found.no/foundation/elasticsearch-from-the-bottom-up/
      - In other words, we can efficiently find things given term prefixes. When all we have is an inverted index, we want everything to look like a string prefix problem
    - https://www.found.no/foundation/elasticsearch-in-production/
    - https://www.found.no/foundation/keeping-elasticsearch-in-sync/

## Introduction
  - [Getting down and dirty with Elasticsearch - 2013.06, ca. 35 min. intro](http://www.youtube.com/watch?v=52G5ZzE0XpY) [http://www.slideshare.net/clintongormley/down-and-dirty-with-elasticsearch](Slides)


## Ruby/Rails integration
  Stretcher
    - http://blog.andrewvc.com/elasticsearch-rails-stretcher-at-pose
    - https://github.com/PoseBiz/stretcher
  Flex
    - https://github.com/ddnexus/flex
    - http://ddnexus.github.io/flex/doc/7-Tutorials/1-Flex-vs-Tire.html

## Tipps/Tricks
  - [AN ELASTICSEARCH DEVELOPMENT WORKFLOW WITH CURL AND BASH, 2013.07](http://asquera.de/development/2013/07/10/an-elasticsearch-workflow/)

## Performance
  - [Blog of Zachary Tong, many good articles on ES](http://euphonious-intuition.com/category/elasticsearch/)
  - [All about Elasticsearch Filter BitSets, 2013.06](http://euphonious-intuition.com/2013/05/all-about-elasticsearch-filter-bitsets/)
  - [Managing Relations in ElasticSearch](http://euphonious-intuition.com/2013/02/managing-relations-in-elasticsearch/)


## Books/Tutorials:
  - http://exploringelasticsearch.com/
  - http://elasticsearchserverbook.com/
  - http://www.manning.com/hinman/


## Happy Users
  - [How Fog Creek Software Made Kiln's Search 1000x Faster with Elasticsearch](http://www.infoq.com/articles/kiln-elasticsearch)
  - [Our Experience of Creating Large Scale Log Search System Using ElasticSearch, 2013.05](http://www.cubrid.org/blog/dev-platform/our-experience-creating-large-scale-log-search-system-using-elasticsearch/)

## Important concepts

### Ranking
  - http://exploringelasticsearch.com/book/searching-data/ranking-based-on-similarity.html

### REST API
  - [REST API Spec](https://github.com/elasticsearch/elasticsearch-rest-api-spec) (!!!)
  Query DSL, Filter API, Facet API, and Sort API

## Slides
  - [Terms of endearment - the ElasticSearch Query DSL explained](http://www.slideshare.net/clintongormley/terms-of-endearment-the-elasticsearch-query-dsl-explained)
  - [SEARCH MADE EASY FOR (WEB) DEVELOPERS, 2012.03](http://spinscale.github.io/elasticsearch/2012-03-jugm.html)
  - https://speakerdeck.com/elasticsearch

### Queries:
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-field-query.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-queries.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-query.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html
  http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html (quite powerful...)

## Query-tutorials
  - https://github.com/erlingwl/elasticsearch-tutorial
  - [Terms of endearment - the ElasticSearch Query DSL explained](http://www.slideshare.net/clintongormley/terms-of-endearment-the-elasticsearch-query-dsl-explained)
  - http://www.spacevatican.org/2012/6/3/fun-with-elasticsearch-s-children-and-nested-documents/
  - http://okfnlabs.org/blog/2013/07/01/elasticsearch-query-tutorial.html

### Analysis
  http://exploringelasticsearch.com/book/searching-data/analysis.html
  - GET /_analyze?analyzer=snowball&text=candles%20candle&pretty=true'

### Similarity/Fuzzy
  - http://elasticsearchserverbook.com/elasticsearch-0-90-similarities/

### Stopwords Workaround -> common terms query
  http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-common-terms-query.html
  >cutoff_frequency


### Aliases
  - https://speakerdeck.com/kimchy/elasticsearch-big-data-search-analytics
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-aliases.html
  - https://github.com/karmi/retire/pull/92#issuecomment-6929988
  - https://groups.google.com/forum/?fromgroups#!searchin/elasticsearch/data$20flow/elasticsearch/49q-_AgQCp8/MRol0t9asEcJ

  -> (we can have per user indexes with ... aliases! )
  For this usecase, aliases really shine. You can have a single index, lets call it users, with 50 shards. And define an alias for each user. Lets say the first user is user1, you define an alias called user1. That alias can have a routing value of "user1", which means when you index and search against that alais (as if it was an "index', i.e. /user1/_search), the routing value will be automatically applied. But, you still need to filter to only see that user data. For that, an alias can also be associated with a filter (i.e. a term filter on the user name with the user value). Then, every time you search against /user1/_search, the filter will be automatically applied.

  One nice aspect of it is that you can also search across several aliases. For example, /user1,user2/_search (as you can search over multiple indices), and it will "do the right thing". It will do a search with two routing values, and an "OR'ed" filter.

### Multilingual
  - http://dev-blog.xoom.com/2013/12/01/natural-language-and-targeted-search-using-elastic-search/
  - http://gibrown.wordpress.com/2013/05/01/three-principles-for-multilingal-indexing-in-elasticsearch/
  - http://jprante.github.io/lessons/2012/05/16/multilingual-analysis-for-title-search.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-snowball-analyzer.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-snowball-tokenfilter.html

  - https://github.com/yakaz/elasticsearch-analysis-combo

### Playground for ES
  - https://www.found.no/play/

### Rivers
  - http://jprante.github.io/guide/2012/05/26/Elasticsearch-Rivers.html

## Plugins
  - http://spinscale.github.io/elasticsearch-intro-plugins/#/37

  - Inquisitor (https://github.com/polyfractal/elasticsearch-inquisitor)

        $ {es_home}/bin/plugin -install bleskes/sense
        $ open http://localhost:9200/_plugin/inquisitor

  - Sense (https://github.com/bleskes/sense)

        $ {es_home}/bin/plugin -install bleskes/sense
        $ open http://localhost:9200/_plugin/sense

    - https://www.found.no/foundation/Sense-Elasticsearch-interface/
    - https://github.com/bleskes/sense#other-goodies (with Shortcuts! :)))

## Tuning/Production
  - [ElasticSearch in Production - from Found.com](http://berlinbuzzwords.de/sites/berlinbuzzwords.de/files/slides/elasticsearch-in-production-pdf-version_0.pdf)

<!-- PROJECTS_LIST_START -->
    *** GENERATED BY https://github.com/mindreframer/techwatcher (ruby _sh/pull elasticsearch-stuff) *** 

    bentona/sweatpants:
      Redis-backed elasticsearch-ruby wrapper that aggregates requests  dispatches them as bulk requests.
       35 commits, last change: 2014-04-01 02:49:29, 1 stars, 1 forks

    bleskes/sense:
      a json aware ElasticSearch front end
       254 commits, last change: 2014-04-01 10:16:00, 225 stars, 39 forks

    brewster/elastictastic:
      Object-document mapper and lightweight API adapter for ElasticSearch
       318 commits, last change: 2013-10-31 06:07:33, 77 stars, 10 forks

    cschuch/daedal-sl:
      Ruby query-writing DSL for ElasticSearch built on Daedal
       6 commits, last change: 2014-03-17 02:21:14, 2 stars, 0 forks

    cschuch/daedal:
      Ruby classes for easier ElasticSearch query building
       46 commits, last change: 2014-04-04 12:55:11, 12 stars, 0 forks

    ddnexus/flex:
      The ultimate ruby client for elasticsearch.
       326 commits, last change: 2013-11-14 07:33:53, 51 stars, 9 forks

    elasticsearch/elasticsearch-rest-api-spec:
      JSON specification for the Elasticsearch's REST API. Deprecated - moved into the elasticsearch/elasticsearch repo
       317 commits, last change: 2014-01-28 16:29:39, 8 stars, 10 forks

    elasticsearch/elasticsearch-ruby:
      Ruby integrations for Elasticsearch
       413 commits, last change: 2014-04-04 14:28:35, 454 stars, 45 forks

    elbii/plunk:
      Human-friendly query language for Elasticsearch
       78 commits, last change: 2014-03-31 13:43:42, 8 stars, 0 forks

    npolar/icelastic:
      Icelastic can be used to integrate Elasticsearch in your Rack applications. It offers advanced url query parsing for a wide range of search senarios.
       82 commits, last change: 2014-03-04 05:45:39, 2 stars, 0 forks

    nz/elasticmill:
      Process your highly parallel Elasticsearch updates into efficient batches.
       21 commits, last change: 2013-02-09 03:53:50, 9 stars, 0 forks

    pawelrychlik/duplitector:
      A duplicate data detector engine PoC based on Elasticsearch.
       42 commits, last change: 2013-09-03 10:26:56, 10 stars, 1 forks

    polyfractal/elasticsearch-inquisitor:
      Site plugin for Elasticsearch to help understand and debug queries.
       60 commits, last change: 2014-03-20 21:00:03, 275 stars, 29 forks

    PoseBiz/stretcher:
      Fast, Elegant, ElasticSearch client
       308 commits, last change: 2013-12-02 20:24:29, 321 stars, 43 forks

    toptal/chewy:
      High-level Elasticsearch ruby framework based on official elasticsearch-ruby client
       122 commits, last change: 2014-03-26 03:00:30, 100 stars, 8 forks
<!-- PROJECTS_LIST_END -->
