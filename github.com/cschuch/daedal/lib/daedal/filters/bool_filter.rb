module Daedal
  module Filters
    """Class for the basic term filter"""
    class BoolFilter < Filter
  
      attribute :should,        Daedal::Attributes::FilterArray
      attribute :must,          Daedal::Attributes::FilterArray
      attribute :must_not,      Daedal::Attributes::FilterArray
  
      def to_hash
        {bool: {should: should.map {|f| f.to_hash}, must: must.map {|f| f.to_hash}, must_not: must_not.map {|f| f.to_hash}}}
      end
    end
  end
end