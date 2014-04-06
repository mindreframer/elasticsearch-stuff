module DaedalSL
  module QueryMethods
    def match_all
      Daedal::Queries::MatchAllQuery.new
    end

    def match options={}
      Daedal::Queries::MatchQuery.new(options)
    end

    def term_filter options={}
      Daedal::Filters::TermFilter.new(options)
    end

    def filtered_query options={}
      Daedal::Queries::FilteredQuery.new(options)
    end

    def nested_bool_query options={}, &block
      DaedalSL::NestedBoolQuery.build(data, options, &block)
    end

    def nested_bool_filter options={}, &block
      DaedalSL::NestedBoolFilter.build(data, options, &block)
    end

    def bool_query options={}, &block
      DaedalSL::BoolQuery.build(data, options, &block)
    end

    def bool_filter options={}, &block
      DaedalSL::BoolFilter.build(data, options, &block)
    end
  
    def get_attributes model
      model.attribute_set.collect {|a| a.name}
    end

  end
end