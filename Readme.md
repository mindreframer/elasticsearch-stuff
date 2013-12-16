## ElasticSearch
  - https://www.found.no/foundation/
    - https://www.found.no/foundation/elasticsearch-from-the-bottom-up/
      - In other words, we can efficiently find things given term prefixes. When all we have is an inverted index, we want everything to look like a string prefix problem
    - https://www.found.no/foundation/elasticsearch-in-production/
    - https://www.found.no/foundation/keeping-elasticsearch-in-sync/

## Ruby/Rails integration
  Stretcher
    - http://blog.andrewvc.com/elasticsearch-rails-stretcher-at-pose
    - https://github.com/PoseBiz/stretcher
  Flex
    - https://github.com/ddnexus/flex
    - http://ddnexus.github.io/flex/doc/7-Tutorials/1-Flex-vs-Tire.html

## Tipps/Tricks
  - [AN ELASTICSEARCH DEVELOPMENT WORKFLOW WITH CURL AND BASH, 2013.07](http://asquera.de/development/2013/07/10/an-elasticsearch-workflow/)

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

    bleskes/sense:
      a json aware ElasticSearch front end
       252 commits, last change: 2013-11-03 11:11:47, 158 stars, 20 forks

    brewster/elastictastic:
      Object-document mapper and lightweight API adapter for ElasticSearch
       318 commits, last change: 2013-10-31 03:07:33, 73 stars, 10 forks

    ddnexus/flex:
      The ultimate ruby client for elasticsearch.
       326 commits, last change: 2013-11-14 04:33:53, 31 stars, 6 forks

    elasticsearch/elasticsearch-rest-api-spec:
      JSON specification for the Elasticsearch's REST API
       312 commits, last change: 2013-12-05 08:36:16, 6 stars, 3 forks

    elasticsearch/elasticsearch-ruby:
      Ruby integrations for Elasticsearch
       236 commits, last change: 2013-12-09 08:48:59, 246 stars, 23 forks

    elbii/plunk:
      Human-friendly query language for Elasticsearch
       20 commits, last change: 2013-12-11 14:14:39, 0 stars, 0 forks

    polyfractal/elasticsearch-inquisitor:
      Site plugin for Elasticsearch to help understand and debug queries.
       57 commits, last change: 2013-12-02 13:16:18, 207 stars, 14 forks
<!-- PROJECTS_LIST_END -->
