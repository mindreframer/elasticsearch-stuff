# http://www.elasticsearch.org/videos/introducing-query-dsl/?registered=1
# http://www.elasticsearch.org/videos/introducing-custom-scoring-functions/

query-types:
  - basic
  - compound

- queries vs. filters

Queries are used for fulltext-search
  - word/phrase
  - how well does the document match the query (score)



Filters:
  - filter out results
  - restrict the number of documents, that the queries will be executed against
  - no scoring!
  - faster
  - cached (internally)



## Tutorials
   - http://www.elasticsearch.cn/tutorials/2011/08/28/query-dsl-explained.html
   - http://pulkitsinghal.blogspot.de/2012/02/how-to-use-elasticsearch-query-dsl.html
   - http://okfnlabs.org/blog/2013/07/01/elasticsearch-query-tutorial.html#query-language
   - http://www.elasticsearch.org/videos/introducing-query-dsl/?registered=1

# Examples
## combine required terms with bool (compound element)
GET /_search
{
   "query": {
      "bool": {
         "must": [
            {
               "term": {
                  "affiliation.id": {
                     "value": "..."
                  }
               }
            },
            {
               "term": {
                  "gender": {
                     "value": "2"
                  }
               }
            }
         ]
      }
   }
}


## restrict number of fields returned
## search with wildchar (*)
GET /_search
{
  "fields": [
    "lastname",
    "firstname",
    "gender"
  ],
  "query": {
    "query_string": {
      "fields": [
        "lastname",
        "firstname"
      ],
      "query": "*las",
      "use_dis_max": true
    }
  }
}
