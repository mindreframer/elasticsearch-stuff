module Daedal
  module Attributes
    """Custom attribute for an array of queries"""
    class QueryArray < Array

      # override the << method so that you throw
      # an error if you don't try to append a query

      def <<(q)
        if q.is_a? Daedal::Queries::Query
          super q
        else
          raise Virtus::CoercionError.new(q, 'Daedal::Queries::Query')
        end
      end
    end
  end
end