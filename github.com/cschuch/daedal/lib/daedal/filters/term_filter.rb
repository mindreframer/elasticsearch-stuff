module Daedal
  module Filters
    """Class for the basic term filter"""
    class TermFilter < Filter
  
      # required attributes
      attribute :field,     Daedal::Attributes::Field
      attribute :term,      Daedal::Attributes::QueryValue
  
      def to_hash
        {term: {field => term}}
      end
    end
  end
end