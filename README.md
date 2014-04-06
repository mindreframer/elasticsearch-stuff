Plunk
=====

Human-friendly query language for Elasticsearch

## About

Plunk is a ruby gem to take a human-friendly, one-line search command and
translate it to full-fledged JSON to send to Elasticsearch. Currently it only
supports a few commands, but the goal is to support a large subset of what
Elasticsearch offers.

## Installation
```
gem install plunk
```

Plunk uses [Parslet](https://github.com/kschiess/parslet) to first parse your
query, and then [Elasticsearch's official ruby library](https://github.com/elasticsearch/elasticsearch-ruby)
to send it to Elasticsearch.

## Usage
```ruby
require 'plunk'

# 
# Configuration is required before using Plunk
# 
# Elasticsearch_options accepts the same params as Elasticsearch::Client
# from the elasticsearch-ruby library
Plunk.configure do |config|
  config.elasticsearch_options = { host: 'localhost' }
end

# Restrict timeframe to last 1 week and match documents with _type=syslog
# s = seconds
# m = minutes
# h = hours
# d = days
# w = weeks
# All times in Plunk are converted to UTC
Plunk.search 'last 1w AND _type = syslog'

# The ```window``` command can also be used to filter by time
Plunk.search 'window -2d to -1d'

# Plunk tries to parse the date with Chronic, so this works too. Note the
# double quotes around the time string. This is needed if it contains a space.
Plunk.search 'window "last monday" to "last thursday"'

# Of course, absolute dates are supported as well. Date format is American style
# e.g. MM/DD/YY
Plunk.search 'window 3/14/12 to 3/15/12'

# Use double quotes to wrap space-containing strings
Plunk.search 'http.header = "UserAgent: Mozilla/5.0"'

# Commands are joined using parenthesized booleans
Plunk.search '(last 1h AND severity = 5) OR (last 1w AND severity = 3)'

# "AND" is aliased to "and" and "&". Similarly, "OR" is aliased to "or" and "|".
# The following queries are identical to one above
Plunk.search '(last 1h and severity = 5) or (last 1w and severity = 3)'
Plunk.search '(last 1h & severity = 5) | (last 1w & severity = 3)'

# Use the NOT keyword to negate the following command or boolean chain
Plunk.search 'NOT message = Error'

# Like AND and OR, "NOT" is aliased to "not" and "~"
Plunk.search 'not message = Error'
Plunk.search '~ message = Error'

# Regexp is supported as well
Plunk.search 'http.headers = /.*User-Agent: Mozilla.*/ OR http.headers = /.*application\/json.*/'
```


## Translation

Under the hood, Plunk takes your query and translates it to
Elasticsearch-compatible JSON. For example,

```last 24h & _type=syslog```

gets translated to:

```json
{
  "query": {
    "filtered": {
      "filter": {
        "and": [
          {
            "range": {
              "timestamp": {
                "gte": "2013-08-23T05:43:13.770Z",
                "lte": "2013-08-24T05:43:13.770Z"
              }
            }
          },
          {
            "query": {
              "query_string": {
                "query": "_type:syslog"
              }
            }
          }
        ]
      }
    }
  }
}
```

In general, commands are combined into a single filter using Elasticsearch's,
```and```, ```or```, and ```not``` filters.
