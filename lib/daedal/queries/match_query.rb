module Daedal
  module Queries
    """Class for the match query"""
    class MatchQuery < Query
  
      # required attributes
      attribute :field,                 Daedal::Attributes::Field
      attribute :query,                 Daedal::Attributes::QueryValue
  
      # non required attributes
      attribute :operator,              Daedal::Attributes::Operator,   required: false
      attribute :minimum_should_match,  Integer,                        required: false
      attribute :cutoff_frequency,      Float,                          required: false
      attribute :type,                  Daedal::Attributes::MatchType,  required: false
      attribute :analyzer,              Symbol,                         required: false
      attribute :boost,                 Daedal::Attributes::Boost,      required: false
      attribute :fuzziness,             Daedal::Attributes::QueryValue, required: false
      attribute :slop,                  Integer,                        required: false
      attribute :max_expansions,        Integer,                        required: false
      attribute :prefix_length,         Integer,                        required: false
      attribute :lenient,               Boolean,                        required: false
  
      def to_hash
  
        result = {match: {field => {query: query}}}
        options = {minimum_should_match: minimum_should_match, cutoff_frequency: cutoff_frequency, type: type, analyzer: analyzer, boost: boost, fuzziness: fuzziness, operator: operator, slop: slop, max_expansions: max_expansions, prefix_length: prefix_length, lenient: lenient}
        result[:match][field].merge! options.select {|k,v| !v.nil?}
  
        result
      end
    end
  end
end