module Daedal
  module Queries
    """Class for the multi match query"""
    class MultiMatchQuery < Query
  
      # required attributes
      attribute :query,                 Daedal::Attributes::QueryValue
      attribute :fields,                Array[Daedal::Attributes::Field]
  
      # non required attributes
      attribute :use_dis_max,           Boolean,                        required: false
      attribute :tie_breaker,           Float,                          required: false
      attribute :operator,              Daedal::Attributes::Operator,   required: false
      attribute :minimum_should_match,  Integer,                        required: false
      attribute :cutoff_frequency,      Float,                          required: false
      attribute :type,                  Daedal::Attributes::MatchType,  required: false
      attribute :analyzer,              Symbol,                         required: false
      attribute :boost,                 Daedal::Attributes::Boost,      required: false
      attribute :fuzziness,             Daedal::Attributes::QueryValue, required: false
      attribute :prefix_length,         Integer,                        required: false
      attribute :max_expansions,        Integer,                        required: false
  
      # Fields cannot be an empty array... should eventually refactor this kind of thing out of initialize
      def initialize(options={})
        super options
  
        if fields.empty?
          raise "Must give at least one field to match on"
        end
      end
  
      def to_hash
        result = {multi_match: {query: query, fields: fields}}
        options = {minimum_should_match: minimum_should_match, cutoff_frequency: cutoff_frequency, type: type, analyzer: analyzer, boost: boost, fuzziness: fuzziness, operator: operator, prefix_length: prefix_length, max_expansions: max_expansions}
  
        result[:multi_match].merge!(options.select { |k,v| !v.nil? })
  
        result
      end
    end
  end
end