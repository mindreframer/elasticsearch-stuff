module Daedal
  module Queries
    """Class for the bool query"""
    class QueryStringQuery < Query
  
      # required attributes
      attribute :query,                         String

      # non required attributes
      attribute :default_field,                 Daedal::Attributes::Field, required: false
      attribute :fields,                        Array[Daedal::Attributes::Field], required: false
      attribute :default_operator,              String, required: false
      attribute :analyzer,                      Symbol, required: false
      attribute :allow_leading_wildcard,        Boolean, required: false
      attribute :lowercase_expanded_terms,      Boolean, required: false
      attribute :enable_position_increments,    Boolean, required: false
      attribute :fuzzy_max_expansions,          Integer, required: false
      attribute :fuzzy_min_sim,                 Float, required: false
      attribute :fuzzy_prefix_length,           Integer, required: false
      attribute :phrase_slop,                   Integer, required: false
      attribute :boost,                         Daedal::Attributes::Boost, required: false
      attribute :analyze_wildcard,              Boolean, required: false
      attribute :auto_generate_phrase_queries,  Boolean, required: false
      attribute :minimum_should_match,          Integer, required: false
      attribute :lenient,                       Boolean, required: false
  
      def to_hash
        {query_string: attributes.select {|k,v| (k == :fields and !v.empty?) or (k != :fields and !v.nil?)}}
      end
    end
  end
end