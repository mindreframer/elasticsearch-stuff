module Daedal
  module Queries
    """Class for the prefix query"""
    class PrefixQuery < Query
  
      # required attributes
      attribute :field,     Daedal::Attributes::Field
      attribute :query,     Daedal::Attributes::LowerCaseString

      # non required attributes
      attribute :boost,     Daedal::Attributes::Boost, required: false
  
      def to_hash
        result = {prefix: {field => query}}
        unless boost.nil?
          result[:prefix][:boost] = boost
        end

        result
      end
    end
  end
end