module Daedal
  module Queries
    """Class for the dis max query"""
    class DisMaxQuery < Query
  
      # required attributes
      attribute :queries,       Daedal::Attributes::QueryArray
  
      # non required attributes
      attribute :tie_breaker,   Float,    required: false
      attribute :boost,         Daedal::Attributes::Boost,  required: false
      attribute :name,          Symbol,   required: false
  
      def to_hash
        result = {dis_max: {queries: queries.map {|q| q.to_hash }}}
        options = {tie_breaker: tie_breaker, boost: boost, _name: name}
        result[:dis_max].merge!(options.select { |k,v| !v.nil? })
  
        result
      end
    end
  end
end