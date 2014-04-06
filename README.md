Daedal
======
[![Build Status](https://travis-ci.org/cschuch/daedal.png?branch=master)](https://travis-ci.org/cschuch/daedal)
[![Coverage Status](https://coveralls.io/repos/cschuch/daedal/badge.png)](https://coveralls.io/r/cschuch/daedal)
[![Gem Version](https://badge.fury.io/rb/daedal.png)](http://badge.fury.io/rb/daedal)

This repository contains a set of Ruby classes designed to make ElasticSearch
query creation simpler and easier to debug. Type checking and attribute
coercion are handled using [Virtus](https://github.com/solnic/virtus) to make
it harder to construct invalid ElasticSearch queries before sending them to the server.

The ElasticSearch [Query DSL](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl.html)
has a tremendous amount of flexibility, allowing users to finely tune their search results.
However, elaborate queries often take the form of a complex, deeply nested hash,
which can become difficult to create or traverse. By wrapping the core components of the
query DSL into Ruby objects, Daedal addresses the following issues:

* Constructing a large nested hash can be a headache, and using some of the popular hash extensions may result in performance issues
* Remembering all the optional parameters each query can take, where they reside within the query structure, and what values they can take can be challenging
* Improperly structured queries, or queries with bad parameters, are hard to catch before sending to the server (and receiving an error)
* Debugging invalid queries can be a grueling task

Daedal also makes it easy to define custom queries tailored to your specific use case - you can see
a simple example at the end of the documentation.

Installation
------------

From the terminal:
``` terminal
$ gem install daedal
```

or in your `Gemfile`:

``` ruby
gem 'daedal'
```

Then, it's as simple as including the line:

``` ruby
require 'daedal'
```

Usage
--------

See the [Daedal Wiki](https://github.com/cschuch/daedal/wiki) for some examples.

### ElasticSearch Query DSL

Other Ruby packages for ElasticSearch allow you to create queries either as
hashes or by constructing raw JSON:

``` ruby
author_query = {'match' => {'author' => {'query' => 'Beckett'}}}
```

For simple queries like the example above, this works just fine. However, as queries become
more complicated, the hash can quickly take on a life of its own. Inspired by ElasticSearch's
[Java API](http://www.elasticsearch.org/guide/en/elasticsearch/client/java-api/current/),
Daedal contains Ruby classes designed to make query construction more manageable.

### Queries

Queries are contained within the `Daedal::Queries` module. You can construct query components like:

``` ruby
author_query = Daedal::Queries::MatchQuery.new(field: 'author', query: 'Beckett')
```

Each query has `#to_json` defined for easy conversion for use with any of the Ruby
ElasticSearch clients out there:

``` ruby
author_query.to_json # => "{\"match\":{\"author\":{\"query\":\"Beckett\"}}}"
```

The benefits of using Daedal become more obvious for aggregate queries such as the `bool query`:

``` ruby
bool_query = Daedal::Queries::BoolQuery.new(must: [author_query])
bool_query.to_json # => "{\"bool\":{\"should\":[],\"must\":[{\"match\":{\"author\":{\"query\":\"Beckett\"}}}],\"must_not\":[]}}"

lines_query = Daedal::Queries::MatchQuery.new(field: 'lines', query: "We're waiting for Godot")
bool_query.should << lines_query

bool_query.to_json # => "{\"bool\":{\"should\":[{\"match\":{\"lines\":{\"query\":\"We're waiting for Godot\"}}}],\"must\":[{\"match\":{\"author\":{\"query\":\"Beckett\"}}}],\"must_not\":[]}}"
```

Currently, the following queries have been implemented:
* [bool query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html)
* [constant score query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-constant-score-query.html)
* [dis max query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-dis-max-query.html)
* [filtered query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-filtered-query.html)
* [fuzzy query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-fuzzy-query.html)
* [match all query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-all-query.html)
* [match query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-match-query.html)
* [multi match query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-multi-match-query.html)
* [nested query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-nested-query.html)
* [prefix query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-prefix-query.html)
* [query string query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html)

On deck:
* [function score query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-function-score-query.html)
* [range query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-range-query.html)
* [regexp query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-regexp-query.html)
* [term query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-term-query.html)
* [terms query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-terms-query.html)
* [wildcard query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-wildcard-query.html)

Queries I'm not planning on implementing at all, since they're deprecated:
* [custom filters score query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-custom-filters-score-query.html)
* [custom score query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-custom-score-query.html)
* [custom boost factor query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-custom-boost-factor-query.html)
* [text query](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-text-query.html)


### Filters

Filters are contained within the `Daedal::Filters` module. You can construct filter components
in the same way as queries:

``` ruby
term_filter = Daedal::Filters::TermFilter.new(field: 'characters', term: 'Pozzo')

term_filter.to_json # => "{\"term\":{\"characters\":\"Pozzo\"}}"
```

Currently, the following filters have been implemented:
* [and filter](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-and-filter.html)
* [bool filter](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-bool-filter.html)
* [geo distance filter](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-geo-distance-filter.html)
* [or filter](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-or-filter.html)
* [range filter](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-range-filter.html)
* [term filter](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-term-filter.html)
* [terms filter](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-terms-filter.html)
* [nested filter](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-nested-filter.html)

### Type checking and attribute coercion

When creating ElasticSearch queries via nested hashes, it is all too easy to
assign an invalid value to a specific field, which would then result in
an error response when sending the query to the server. For instance, the query:

``` ruby
constant_score_query = {'constant_score' => {'boost' => 'foo', 'query' => {'match_all' => {}}}}
```

would yield a server error, since the `boost` parameter must be a number.

Daedal uses [Virtus](https://github.com/solnic/virtus) to perform data-type coercions. 
Invalid query parameters are surfaced at runtime, making debugging much easier.
The previous example in Daedal would raise an error:

``` ruby
match_all_query = Daedal::Queries::MatchAllQuery.new

constant_score_query = Daedal::Queries::ConstantScoreQuery.new(boost: 'foo', query: match_all_query)
# Virtus::CoercionError: Failed to coerce "foo" into Float
```

Similarly, trying to add non-queries to an aggregate query like the `bool` or `dis max` queries
will result in an error:

``` ruby
dis_max_query = Daedal::Queries::DisMaxQuery.new

dis_max_query.queries << :foo
# Virtus::CoercionError: Failed to coerce :foo into "Daedal::Queries::Query"
```

### Creating custom queries

Currently, I've only made it through a fraction of the entire Query DSL, but will be adding more
as time goes by. If there's a component of the query DSL that you need that isn't implemented yet,
it's easy to define it yourself within your project (or, feel free to contribute to Daedal!).

Creating custom filters or queries tailored specifically to your use case is also pretty straightforward.
Here are some guidelines:

* Make your class inherit from `Daedal::Queries::Query` or `Daedal::Filters::Filter`
* Define the parameters for your query using [Virtus](https://github.com/solnic/virtus) attributes (**note**: `strict` coercion is being used)
* Define the `#to_hash` method

Example of a custom query:
``` ruby
class PlayQuery < Daedal::Queries::Query
  
  # define the parameters that you want in your query
  # if the field is optional, make sure to set required to false
  attribute :author, String

  attribute :characters, Array[String], required: false
  attribute :title, String, required: false

  def construct_query
    author_query = Daedal::Queries::MatchQuery.new(field: 'author', query: author)
    title_query = Daedal::Queries::MatchQuery.new(field: 'title', query: title)

    full_query = Daedal::Queries::BoolQuery.new(must: [author_query], should: [title_query])
    characters.each do |character|
      full_query.should << Daedal::Queries::MatchQuery.new(field: 'characters', query: character)
    end

    full_query
  end

  # define the to_hash method to convert for use in ElasticSearch 
  def to_hash
    construct_query.to_hash
  end
end

play_query = PlayQuery.new(author: 'Beckett', title: 'Waiting for Godot', characters: ['Estragon', 'Vladimir'])
puts play_query.to_json # => {"bool":{"should":[{"match":{"title":{"query":"Waiting for Godot"}}},{"match":{"characters":{"query":"Estragon"}}},{"match":{"characters":{"query":"Vladimir"}}}],"must":[{"match":{"author":{"query":"Beckett"}}}],"must_not":[]}}
```

Contributing
-------------

The ElasticSearch Query DSL is pretty big and includes a ton of nuance. I'm starting with the
most basic parts of the DSL (and the parts I use for work), so if you want to help out with the project
to meet your needs please feel free to contribute! I just ask that you:

* Fork the project
* Make your changes or additions
* Add tests! My goal is to keep Daedal a thoroughly tested project
* Send me a pull request

Feedback or suggestions are also always welcome!

License
-------

The MIT License (MIT)

Copyright (c) 2013 Christopher Schuch

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.