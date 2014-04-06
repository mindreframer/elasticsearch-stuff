# Icelastic

[![Code Climate](https://codeclimate.com/github/npolar/icelastic.png)](https://codeclimate.com/github/npolar/icelastic)

## Installation

Add this line to your application's Gemfile:

    gem 'icelastic', :git => "git://github.com/npolar/icelastic.git"

And then execute:

    $ bundle

## Usage

### Middleware

```ruby

    require 'icelastic'

    use Rack::Icelastic, {
      :url => "http://localhost:9200",
      :index => "example",
      :type => "test",
      :log => false, # Enables logging in elasticsearch-ruby
      :params => {
        "facets" => "topics,tags", # Fields to facet
        "date-month" => "created,updated", # Date facets with a month interval
        "start" => 0, # Start of result page
        "limit" => 20, # Items per page
        "size-facet" => 5 # Number of facet items
      }
    }

```

### App

```ruby

    require 'icelastic'

    run Rack::Icelastic.new nil, {
      :url => "http://localhost:9200",
      :index => "example",
      :type => "test",
      :log => false, # Enables logging in elasticsearch-ruby
      :params => {
        "facets" => "topics,tags", # Fields to facet
        "date-year" => "created,updated", # Date facets with a year interval
        "start" => 0, # Start of result page
        "limit" => 10, # Items per page
        "size-facet" => 25 # Number of facet items
      }
    }

```

## URL query parameter overview

#### Simple Queries

```ruby
  "?q=<value>" # Regular query
  "?q-<field>=<value>" # Field query
  "?q-<field1>,<field2>=<value>" # Multi-field query
```

#### Paging & Fields

```ruby
  "?start=10" # Results are shown from the 10th row
  "?limit=50" # Show 50 rows per result page
  "?limit=all" # Use the all keyword to retrieve all search results (Very heavy and slow on large collections. Use with care!!!)

  "?sort=<field>" # Sort ascending on field
  "?sort=-<field>" # Sort descending on field

  "?fields=<field1>,<field2>,<field3>" # Only show fields 1,2,3 in the response rows
```

#### Filtered Queries

```ruby
  "?filter-<field>=<value>" # Basic filter

  "?filter-<field>=<value1>,<value2>" # AND filter
  "?filter-<field>=<value1>|<value2>" # OR filter
  "?not-<field>=<value>" # NOT filter (starts with not instead of filter)

  "?filter-<field>=<value1>..<value2>" # Ranged filter
  "?filter-<field>=<value>.." # Ranged filter (greater or equal then)
  "?filter-<field>=..<value>" # Ranged filter (less or equal then)
```

#### Facets

```ruby
  "?facets=<field1>,<field2>" # Facet on field1 and field2
  "?facet-<name>=<field>" # Labeled facet (generates a facet with a specific name)

  "?date-<interval>=<field1>,<field2>" # Generate a date facets with the specified interval (year|month|day)

  "?size-facet=<number>" # Specify the number of facets to return
```

#### Output Format

```ruby
  "?format=csv" # Return results as csv (Only basic support)
  "?format=csv&fields=<field1>" # For the best results with csv specify the fields you want in the results
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
