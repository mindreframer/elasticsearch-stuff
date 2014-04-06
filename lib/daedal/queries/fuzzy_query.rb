module Daedal
  module Queries
    """Class for the fuzzy query"""
    class FuzzyQuery < Query

      # required attributes
      attribute :field,           Daedal::Attributes::Field
      attribute :query,           Daedal::Attributes::QueryValue

      # non required attributes
      attribute :boost,           Daedal::Attributes::Boost,      required: false
      attribute :min_similarity,  Daedal::Attributes::QueryValue, required: false
      attribute :prefix_length,   Integer,                        required: false
      attribute :max_expansions,  Integer,                        required: false
      attribute :fuzziness,       Daedal::Attributes::QueryValue, required: false
  
      def to_hash
        result = {fuzzy: {field => {value: query}}}
        options = {boost: boost, min_similarity: min_similarity, prefix_length: prefix_length, max_expansions: max_expansions, fuzziness: fuzziness}.select {|k,v| !v.nil?}
        result[:fuzzy][field].merge!(options)

        result
      end
    end
  end
end