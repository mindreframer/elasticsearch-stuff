module DaedalSL
  class BaseQuery
    include DaedalSL::QueryMethods

    attr_reader :data

    def initialize data=nil, &block
      @data = data
      @base = initialize_base
      @options = {}
      instance_eval(&block)
    end

    def to_hash
      result = {query: @base.to_hash}
      prepare_options
      result.merge(@options)
    end

    # adding queries

    def must &block
      @base.query.must << block.call
    end

    def should &block
      @base.query.should << block.call
    end

    def must_not &block
      @base.query.must_not << block.call
    end

    # adding filters

    def must_filter &block
      @base.filter.must << block.call
    end

    def should_filter &block
      @base.filter.should << block.call
    end

    def must_not_filter &block
      @base.filter.must_not << block.call
    end

    # sorting

    def sort field, order=:asc
      @options[:sort] ||= []
      @options[:sort] << {field => {order: order}}
    end

    # pagination

    def page num
      @options[:page] = num
    end

    def per num
      @options[:per] = num
    end

    protected

    def prepare_options
      page = @options.delete(:page)
      per = @options.delete(:per)
      if per
        @options[:size] = per
      end
      if page
        @options[:from] = (page - 1) * (per || 10)
      end
    end

    def initialize_base
      filtered_query(
        query: bool_query,
        filter: bool_filter
      )
    end

  end
end