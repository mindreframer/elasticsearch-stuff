## ElasticSearch
  - https://www.found.no/foundation/
    - https://www.found.no/foundation/elasticsearch-from-the-bottom-up/
      - In other words, we can efficiently find things given term prefixes. When all we have is an inverted index, we want everything to look like a string prefix problem
    - https://www.found.no/foundation/elasticsearch-in-production/
    - https://www.found.no/foundation/keeping-elasticsearch-in-sync/

## Ruby/Rails integration
  - http://blog.andrewvc.com/elasticsearch-rails-stretcher-at-pose
  - https://github.com/PoseBiz/stretcher

## Books/Tutorials:
  - http://exploringelasticsearch.com/
  - http://elasticsearchserverbook.com/
  - http://www.manning.com/hinman/

## Important concepts

### Ranking
    - http://exploringelasticsearch.com/book/searching-data/ranking-based-on-similarity.html

### REST API
  - [REST API Spec](https://github.com/elasticsearch/elasticsearch-rest-api-spec) (!!!)
  Query DSL, Filter API, Facet API, and Sort API



### Queries:
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-field-query.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-queries.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-query.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html
  http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html (quite powerful...)

### Analysis
  http://exploringelasticsearch.com/book/searching-data/analysis.html
  - GET /_analyze?analyzer=snowball&text=candles%20candle&pretty=true'


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

  - http://gibrown.wordpress.com/2013/05/01/three-principles-for-multilingal-indexing-in-elasticsearch/
  - http://jprante.github.io/lessons/2012/05/16/multilingual-analysis-for-title-search.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-snowball-analyzer.html
  - http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/analysis-snowball-tokenfilter.html

### Tools:
  - https://www.found.no/foundation/Sense-Elasticsearch-interface/
  - https://github.com/bleskes/sense#other-goodies (with Shortcuts! :)))

  - Playground for ES:
    - https://www.found.no/play/

### Rivers
  http://jprante.github.io/guide/2012/05/26/Elasticsearch-Rivers.html

### Plugins:
  {es_home}/bin/plugin -install bleskes/sense



<!-- PROJECTS_LIST_START -->
<!-- PROJECTS_LIST_END -->
