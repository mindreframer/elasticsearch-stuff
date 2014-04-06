module Rack

  # Middlware allowing easy integration of Icelastic
  # into the your Ruby and Rails applications
  #
  # [Authors]
  #   - Ruben Dens

  class Icelastic

    attr_accessor :env, :params

    def initialize(app=nil, options={})
      app = lambda{|env| [200, {"Content-Type" => "application/json"}, [{"error" => "404 Not Found"}.to_json]]} if app.nil?

      @app, @config = app, options
    end

    def call(env)
      self.env = env
      self.params = CGI.parse(env['QUERY_STRING'])
      # Execute a search and return the response if a search request
      return [200, {"Content-Type" => "application/json; charset=utf-8"}, [client.search(request)]] if search?

      @app.call(env)
    end

    private

    def request
      Rack::Request.new(env)
    end

    def client
      ::Icelastic::Client.new(@config)
    end

    # Determine if this is a search request
    def search?
      env['REQUEST_METHOD'] == "GET" && (query? || filter?)
    end

    def query?
      params.keys.select{|param| param[/q(-.+)?/]}.any?
    end

    def filter?
      params.keys.select{|param| param[/filter-.+|not-.+/]}.any?
    end

  end
end
