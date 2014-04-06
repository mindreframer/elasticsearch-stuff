module Daedal
  module Filters
    """Class for the basic term filter"""
    class OrFilter < Filter
  
      # required attributes
      attribute :filters, Daedal::Attributes::FilterArray
  
      def to_hash
        unless filters.empty?
          {:or => filters.map {|f| f.to_hash}}
        else
          super
        end
      end
    end
  end
end