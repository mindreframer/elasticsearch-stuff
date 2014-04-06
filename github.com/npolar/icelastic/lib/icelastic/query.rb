module Icelastic

  # This class is used to build elasticsearch queries from url parameters
  #
  # [Usage]
  # query = Icelastic::Query.new( params )
  # query.build
  #
  # [Authors]
  #   - Ruben Dens

  class Query

    # Get request parameters
    def params
      @params ||= {"q" => "*"}
    end

    # Set request parameters
    def params=(parameters = nil)
      @params = {}
      case parameters
      when Hash then @params = parameters
      when String then CGI.parse( parameters ).each{ |k, v| @params[k] = v.join(',') }
      else raise ArgumentError, "params not a Hash or String" # Raise error or set default?
      end
    end

    # Builder combining all the segments
    # into a full query body.
    def build
      query = {}
      query.merge!(start)
      query.merge!(limit)
      query.merge!(sort)
      query.merge!(fields) unless fields.nil?
      query.merge!(highlight)
      query.merge!(query_block)
      query.merge!(facets) unless facets.nil?

      query.to_json
    end

    # Builds the top lvl query block
    def query_block
      filters? ? {:query => filtered_query} : {:query => query_string}
    end

    # Build a filtered query
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-filtered-query.html Elasticsearch: Filtered queries
    def filtered_query
      {:filtered => {:query => query_string, :filter => filter}}
    end

    # Routing method that calls the appropriate query segment builder
    # @see #global_query
    # @see #field_query
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#query-dsl-query-string-query Elasticsearch: Query string query
    def query_string
      params.any?{|k,v| k =~ /^q-(.+)$/} ? field_query : global_query
    end

    # Build a query against all fields
    def global_query
      {
        :query_string => {
          :default_field => :_all,
          :query => query_value
        }
      }
    end

    # Build query against one || more fields
    # @see #default_field
    # @note these kind of queries only work on fields that are tokenized in the search engine
    def field_query
      fq = {:query_string => params.select{|k,v| k =~ /^q-(.+)/}}
      fq[:query_string].each do |k,v|
        fq[:query_string] = query_field( k.to_s.gsub(/^q-/, '') )
        fq[:query_string][:query] = query_value
      end
      fq
    end

    # Builds a filter segment
    # @see #parse_filter_values
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-filter.html Elasticsearch: Query filters
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-and-filter.html Elasticsearch: And filters
    def filter
      f = {:and => []}
      filter_params.each do |k,v|
        key = k.gsub(/^filter-|^not-/, '')
        parse_filter_values(key, v).each do |e|
          not_filter?(k) ? f[:and] << {:not => e} : f[:and] << e
        end
      end
      f
    end

    # Builds a facets segment
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-facets.html Elasticsearch: facets
    def facets
      {:facets => handle_facets} if facets_enabled?
    end

    # Generate a sort segment
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-request-sort.html Elasticsearch: Sort
    def sort
      sp = {}
      sort_params.each{|k,v| sp[:sort] = build_sort_segment(v)}
      sp
    end

    # Define start point for the result cursor
    def start
      start_param? ? {:from => start_param["start"].to_i} : {:from => 0}
    end

    # Define the item limit per result page
    def limit
      limit_param? ? {:size => limit_param["limit"].to_i} : {:size => 25}
    end

    # Define the fields that should be included in the response
    def fields
      {:fields => params["fields"].split(",").uniq} if params.has_key?("fields")
    end

    # Build highlighter segment
    def highlight
      highlighter_defaults
    end

    private

    # Clean the query value
    def query_value
      q = params.select{|k,v| k =~ /^q(-(.+)?)?$/}
      q = !q.nil? && q.any? ? q.values[0].strip.squeeze(" ").gsub(/(\&|\||\!|\(|\)|\{|\}|\[|\]|\^|\~|\:|\!)/, "") : ""
      q == "" ? "*" : handle_search_pattern(q)
    end

    # Detect query pattern and return an explicit (quoted search) or a simple fuzzy query
    def handle_search_pattern(q)
      q.match(/^\"(.+)\"$/) ? q.gsub(/\"/, "") : "#{q} #{q}*"
    end

    # Generates a default_field || fields syntax for the query string.
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#_default_field Elasticsearch: Default field
    def query_field(field_arg)
      multi_field?(field_arg) ? {:fields => field_arg.split(',')} : {:default_field => field_arg}
    end

    # Check if doing a multifield query?
    # @example
    #   ?q-title,summary=
    #   ?q-contact.*=
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#_multi_field_2 Elasticsearch: Multi field queries
    def multi_field?(field_arg)
      field_arg.split(',').size > 1 || field_arg.match(/^(.+)\.(\*)/)
    end

    # Returns all filter params
    def filter_params
      params.select{|k,v| k =~ /^filter-(.+)|^not-(.+)/}
    end

    # Returns true if there are filter parameters
    def filters?
      filter_params.any?
    end

    # Return true if this is an exclusion filter? (NOT)
    def not_filter?(key)
      key.match(/^not-(.+)/)
    end

    # Split filter values into segments and handle them appropriatly
    def parse_filter_values(key,  value)
      vals = value.split(',').map{|v| handle_filter_value(key, v)}
    end

    # Build filter syntax based on the value format
    def handle_filter_value(key, value)
      if or_value?( value )
        or_filter( key, value )
      elsif range_value?( value )
        range_filter( key, value )
      else
        filter_term( key, value )
      end
    end

    # Check if the value holds an or construct
    # @example
    #   <val1>|<val2>
    def or_value?(value)
      value.match(/(.+)\|(.+)/)
    end

    # Build or filter syntax
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-or-filter.html Elasticsearch: or filter
    def or_filter(key, value)
      of = {:or => []}
      value.split('|').each {|v| of[:or] << handle_filter_value( key, v )}
      of
    end

    # Check if the value matches a range format
    # @example
    #   <val1>..<val2> (from val1 to val2)
    #   <val1>.. (larger or equal to val1)
    #   ..<val2> (less or equal to val2)
    def range_value?(value)
      value.match(/(.+)\.\.(.+)|^\.\.(.+)|^(.+)\.\./)
    end

    # Build a range filter
    # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-range-filter.html Elasticsearch: range filter
    def range_filter(key, value)
      v = value.split('..')

      return {:range => {key => {:lte => v[1]}}} if v[0].empty?
      return {:range => {key => {:gte => v[0]}}} if v[1].nil?

      # Swap values if val2 is smaller than val1
      swap_values(v) unless correct_order?(v)

      {:range => {key => {:gte => v[0], :lte => v[1]}}}
    end

    # Check if the values are in the right order
    def correct_order?(v)
      if date_time?(v[0]) || date_time?(v[1])
        correct_date_order?(v)
      else
        v[0].to_f < v[1].to_f
      end
    end

    # Check if the dates are in the right order
    def correct_date_order?(v)
      date_time_to_i(v[0]) < date_time_to_i(v[1])
    end

    # Swap two values in an array
    def swap_values(values)
      values[0], values[1] = values[1], values[0]
    end

    # Check if receiving a date time string
    def date_time?(value)
      value.match(/^\d{4}\-(\d{2})?\-?(\d{2})?T?(\d{2}):?(\d{2})?:?(\d{2})?Z?/)
    end

    # Remove string characters from date and cast to integer
    def date_time_to_i(value)
      value.gsub(/-|:|T|Z/, '').to_i
    end

    # Returns a filter term hash
    def filter_term(field, value)
      {:term =>{field => value.strip.squeeze(" ")}}
    end

    # Return a hash with facet parameters
    def facet_params
      params.select{|k,v| k=~ /^facets$|^facet-(.+)$|^stat-(.+)$|^stats$|^date-(year|month|day)$/}
    end

    # Check if the disable directive is given
    def facets_enabled?
      facet_params['facets'] && facet_params['facets'] == "false" ? false : true
    end

    def facet_size
      params['size-facet'] ? params['size-facet'].to_i : 10
    end

    # Return a term facet segment
    def facet_term(field)
      {:terms => {:field => field,:size => facet_size}}
    end

    # Check if the facet is a multi_facet
    # @example
    #   &facets=topic,tags,area
    def multi_facet?(key)
      key.match(/^facets$/)
    end

    # Build facet segments using the field name as the facet name
    def build_multi_facet(value)
      mf = {}
      value.split(',').each{|field| mf[field] = facet_term(field)}
      mf
    end

    # Check if the facet is a named facet
    # @example
    #   &facet-<title>=<field>
    def named_facet?(key)
      key.match(/^facet-(.+)$/)
    end

    # Check if a statistical facet was entered
    # @example
    #   &stat-<title>=<field>
    def statistical_facet?(key)
      key.match(/^stat-(.+)$/)
    end

    # Build the core statistical facet structure
    def stat_facet(field)
      {:statistical => {:field => field}}
    end

    # Check if there is multi stat facet
    # @example
    #   &stats=<field1>,<field2>
    def multi_stat_facet?(key)
      key.match(/^stats$/)
    end

    # Build statistical facets for multiple fields.
    # Uses the field name + _stat as the key.
    def multi_stat_facet(value)
      sf = {}
      value.split(',').each {|field| sf["#{field}-statistics"] = stat_facet(field)}
      sf
    end

    # Check if there is a date facet
    def date_facet?(key)
      key.match(/^date-(year|month|day)$/)
    end

    def date_facet(field, interval)
      {:date_histogram => {:field => field, :interval => interval}}
    end

    # Build a date facet
    def build_date_facet(field, interval)
      df = {}
      field.split(',').each {|f| df["#{interval}-#{f}"] = date_facet(f, interval) }
      df
    end

    # Handle facet types
    def handle_facets
      fc = {}

      facet_params.each do |key, field|
        k = key.gsub(/^facet-|^stat-|^date-/, '')

        fc.merge!(build_multi_facet(field)) if multi_facet?(key)
        fc[k] = facet_term(field) if named_facet?(key)
        fc.merge!(multi_stat_facet(field)) if multi_stat_facet?(key)
        fc[k] = stat_facet(field) if statistical_facet?(key)
        fc.merge!(build_date_facet(field, k)) if date_facet?(key)
      end

      fc
    end

    # Sort params
    def sort_params
      params.select{|k,v| k == "sort"}
    end

    # Determine the sort order from the value
    # @example
    #   sort=title # will sort  ascending
    #   sort=-title # will sort descending because of the "-" character in front of the field
    def sort_order(value)
      value =~ /-(.+)/ ? :desc : :asc
    end

    # Build a sort segment
    def build_sort_segment(value)
      value.split(',').map do |v|
        {v.gsub(/-(.+)/, '\1') => { :order => sort_order(v), :ignore_unmapped => true}}
      end
    end

    # Get the start parameter
    def start_param
      params.select{|k,v| k == "start"}
    end

    # Returns true if there is a start param
    def start_param?
      start_param.any?
    end

    # Get the limit parameter
    def limit_param
      params.select{|k,v| k == "limit"}
    end

    # Returns true if there is a limit param
    def limit_param?
      limit_param.any?
    end

    # Default highlighting configuration
    def highlighter_defaults
      {
        :highlight => {
          :fields => {
            :_all => {
              :pre_tags => ["<em><strong>"],
              :post_tags => ["</strong></em>"],
              :fragment_size => 50,
              :number_of_fragments => 3
            }
          }
        }
      }
    end

  end
end
