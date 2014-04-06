module Daedal
  module Queries
    """Class for the bool query"""
    class BoolQuery < Query
  
      # required attributes

      # should, must, and must_not must be an array of queries
      # these queries must inherit from the BaseQuery class
      attribute :should,                Daedal::Attributes::QueryArray
      attribute :must,                  Daedal::Attributes::QueryArray
      attribute :must_not,              Daedal::Attributes::QueryArray
  
      # non required attributes
      attribute :minimum_should_match,  Integer,  required: false
      attribute :boost,                 Daedal::Attributes::Boost,  required: false
      attribute :name,                  Symbol,   required: false
      attribute :disable_coord,         Boolean,  required: false
  
      def to_hash
        result = {bool: {should: should.map {|q| q.to_hash}, must: must.map {|q| q.to_hash}, must_not: must_not.map {|q| q.to_hash}}}
        options = {minimum_should_match: minimum_should_match, boost: boost, _name: name, disable_coord: disable_coord}
        result[:bool].merge!(options.select { |k,v| !v.nil? })
  
        result
      end
    end
  end
end