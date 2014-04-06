module Daedal
  module Filters
    """Class for the basic term filter"""
    class TermsFilter < Filter
  
      # required attributes
      attribute :field,     Daedal::Attributes::Field
      attribute :terms,     Array[Daedal::Attributes::QueryValue]
  
      def to_hash
        {terms: {field => terms}}
      end
    end
  end
end