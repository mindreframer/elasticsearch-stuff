module Icelastic

  # The client is a wrapper around the elasticsearch-ruby client library.
  # It acts as an interface between the middlware and the query,result objects.
  #
  # [Functionality]
  #   This library provides CRUD behavior for elasticsearch using the custom
  #   query and response objects defined in this library
  #
  # [Authors]
  #   - Ruben Dens
  #
  # @see https://github.com/elasticsearch/elasticsearch-ruby Elasticsearch-Ruby on github

  class Client

    # Unless overriden this minimal set of query
    # parameters are used as defaults.
    PARAMS = {
      :start => 0,
      :limit => 25
    }

    attr_accessor :client, :params, :url, :search_index, :type, :log, :env, :response

    def initialize(config={})
      self.url = config[:url] if config.has_key?(:url)
      self.search_index = config[:index] if config.has_key?(:index)
      self.type = config[:type] if config.has_key?(:type)
      self.log = config.has_key?(:log) ? config[:log] : false
      self.client = url.nil? ? Elasticsearch::Client.new : Elasticsearch::Client.new(:url => url, :log => log)
      self.params = config.has_key?(:params) && !config[:params].nil? ? PARAMS.merge(config[:params]) : PARAMS
    end

    # Execute a search operation
    def search(request)
      self.env = request.env
      self.response = client.search({:body => query, :index => search_index, :type => type})
      result
    end

    private

    def query
      q = Icelastic::Query.new
      q.params = request_params
      q.build
    end

    def result
      self.env = env.merge({"QUERY_STRING" => request_params.map{|k,v| "#{k}=#{v}"}.join('&')})
      r = Icelastic::Result.new(Rack::Request.new(env), response)
      request_params['format'] == "csv" ? csv(r).build : r.feed.to_json
    end

    def csv(result)
      Icelastic::CsvWriter.new(Rack::Request.new(env), result.feed[:feed][:entries])
    end

    def request_params
      p = CGI.parse(env['QUERY_STRING'])
      p.each {|k,v| p[k] = v.join(",")}
      p["limit"] = count if p["limit"] == "all"
      self.params = hash_key_to_s(params.merge(p))
    end

    def count
      r = client.count :index => search_index, :type => type
      r['count']
    end

    # Casts hash keys to String
    def hash_key_to_s(hash)
      hash.inject({}){|memo,(k,v)| memo[k.to_s] = v; memo}
    end

  end
end
