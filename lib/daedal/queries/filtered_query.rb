module Daedal
  module Queries
    """Class for the filtered query"""
    class FilteredQuery < Query
  
      # required attributes
      attribute :query,     Daedal::Attributes::Query,  default: Daedal::Queries::MatchAllQuery.new
      attribute :filter,    Daedal::Attributes::Filter, default: Daedal::Filters::Filter.new
  
      def to_hash
        {filtered: {query: query.to_hash, filter: filter.to_hash}}
      end
    end
  end
end