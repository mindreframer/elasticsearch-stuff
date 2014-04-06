module Icelastic

  # This class provides custom result wrappers for elasticsearch
  # response objects.
  #
  # [Authors]
  #   - Ruben Dens

  class Result

    attr_accessor :env, :response, :feed

    def initialize(request, response = {})
      self.feed = {}
      self.env = request.env
      self.response = response
    end

    # Object containing a feed response
    def feed
      {:feed => {
          :opensearch => opensearch,
          :list => list,
          :search => search,
          :facets => facets,
          :entries => entries
        }
      }
    end

    # Generate opensearch fields for the search response
    # @see http://www.opensearch.org/Specifications/OpenSearch/1.1#The_.22totalResults.22_element OpenSearch: totalResults element
    # @see http://www.opensearch.org/Specifications/OpenSearch/1.1#The_.22itemsPerPage.22_element OpenSearch: itemsPerPage element
    # @see http://www.opensearch.org/Specifications/OpenSearch/1.1#The_.22startIndex.22_element OpenSearch: startIndex element
    def opensearch
      {
        :totalResults => total_results,
        :itemsPerPage => limit,
        :startIndex => start
      }
    end

    # Object containing paging information
    def list
      {
        :self => self_uri,
        :first => start,
        :last => last,
        :next => next_uri,
        :previous => previous_uri
      }
    end

    # Object containing search stats
    def search
      {:qtime => query_time}.merge(query_param)
    end

    # Generates a uniform facet format for both elasticsearch
    # term and date_histogram facets.
    def facets
      if response.has_key?("facets")
        wrapper, fb = [], response["facets"]
        fb.each do |k,v|
          ["terms", "entries"].each do |type|
            wrapper << { k => map_facet_terms(k, v[type]) } if v.has_key?(type)
          end
        end
        wrapper
      end
    end

    # Object holding response documents
    def entries
      response['hits']['hits'].map do |e|
        b = request_params.has_key?('fields') ? e['fields'] : e['_source']
        b['highlight'] = e['highlight']['_all'].join('... ') if e['highlight']
        b
      end
    end

    private

    # Return a parameter hash for the query string
    def request_params
      Rack::Request.new(env).params
    end

    # Returns the total number hits for the query
    def total_results
      response["hits"]["total"]
    end

    # Returns the start index of the result page. The default in this
    # method should never be called. Defaults should be passed down
    # from the client. @see Icelastic::Client::PARAMS
    def start
      request_params.has_key?('start') ? request_params['start'].to_i : 0
    end

    # Return the item limit. The default in this
    # method should never be called. Defaults should be passed down
    # from the client. @see Icelastic::Client::PARAMS
    def limit
      request_params.has_key?('limit') ? request_params['limit'].to_i : 25
    end

    # Returns the index of the last item on the result page
    def last
      limit > total_results ? total_results : (start + limit - 1)
    end

    # Handles time intervals for various date facets and
    # returns the interval appropriate response format
    def handle_facet_time(facet, time)
      interval = $1 if facet =~ /^(year|month|day)-(.+)/
      date = case interval
      when "day" then day_from(time)
      when "month" then month_from(time)
      when "year" then year_from(time)
      else milliseconds_to_iso8601(time)
      end
    end

    # Converts milliseconds since the unix epoch to iso8601
    def milliseconds_to_iso8601(time)
      Time.at(time/1000).utc.iso8601
    end

    def yyyy_mm_dd_to_iso8601(year, month, day)
      Time.utc(year, month, day).iso8601
    end

    # Converts iso8601 to yyyy-mm-dd format
    def day_from(time)
      milliseconds_to_iso8601(time)[0..9]
    end

    # Converts iso8601 to yyyy-mm format
    def month_from(time)
      milliseconds_to_iso8601(time)[0..6]
    end

    # Converts iso8601 to yyyy format
    def year_from(time)
      milliseconds_to_iso8601(time)[0..3]
    end

    # Returns a range syntax for the provided interval and time
    def time_range(interval, time)
      year, month, day = time.split("-").map{|e| e.to_i}

      date = case interval
      when "day" then Date.new(year, month, day).next_day
      when "month" then Date.new(year, month).next_month
      when "year" then Date.new(year).next_year
      end

      "#{yyyy_mm_dd_to_iso8601(year, month, day)}..#{yyyy_mm_dd_to_iso8601(date.year, date.month, date.day)}"
    end

    def map_facet_terms(key, terms)
      terms.map do |e|
        term = e["term"] ? e["term"] : handle_facet_time(key, e["time"])
        {
          :term => term,
          :count => e["count"],
          :uri => build_facet_uri(key, term)
          #:query => build_facet_query(k, term)
        }
      end
    end

    # Builds a facet uri using the query builder
    # @see #build_facet_query
    def build_facet_uri(field,term)
      "#{base}?#{build_facet_query(field, term)}"
    end

    # Builds a facet query.
    # @see #facet_query
    def build_facet_query(field, term)
      if field =~ /^(year|month|day)-(.+)/
        "#{facet_query($2, time_range($1, term))}"
      else
        f = request_params.has_key?("facet-#{field}") ? request_params["facet-#{field}"] : field
        "#{facet_query(f, term)}"
      end
    end

    # Returns the base uri for the request
    def base
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['REQUEST_PATH']}"
    end

    # Returns the uri for the current request
    def self_uri
      "#{base}?#{env['QUERY_STRING']}"
    end

    # Generate the uri for next page or return
    # false when on the last page
    def next_uri
      return false if total_results <= ((start + limit) || limit)
      "#{base}?#{query_from_params(request_params.merge({"start" => start + limit}))}"
    end

    # Generates the uri for the previous page.
    # Returns false when on the first page.
    def previous_uri
      return false if start == 0
      val = start - limit >= 0 ? start - limit : 0
      "#{base}?#{query_from_params(request_params.merge({"start" => val}))}"
    end

    # Returns a query string based on the facet contents and request environment
    def facet_query(field, term)
      k = "filter-#{field}"
      request_params.has_key?(k) ? process_params(k, term) : "#{env['QUERY_STRING']}&filter-#{field}=#{term}"
    end

    # Use the current parameter hash to construct a new query string.
    # This is done to prevent duplications in the query output
    def process_params(key, term)
      params = request_params

      if params[key].match(/#{term}/)
        vals = params[key].split(",").delete_if{|e| e == term}
        vals.any? ? params[key] = vals.join(",") : params.delete(key)
      else
        params[key] += ",#{term}"
      end

      params.map{|k,v| "#{k}=#{v}"}.join("&")
    end

    # Returns a query string build from a parameter hash.
    def query_from_params(params = request_params)
      params.map{|k,v| "#{k}=#{v}"}.join('&')
    end

    # Returns the time it took to execute the query
    def query_time
      response["took"]
    end

    # Return the query parameter
    def query_param
      request_params.select{|k,v| k =~ /^q(-.+)?/}
    end

  end
end