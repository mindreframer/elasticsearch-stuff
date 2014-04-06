module Daedal
  module Queries
    """Base class for queries. All other queries
    should inherit from this class directly in order to
    allow for data-type coercion for compound queries
    like the bool or dis max query"""
    class Query
      # Virtus coercion is set to strict so that errors
      # are returned when supplied fields cannot be properly
      # coerced.
      include Virtus.model strict: true

      # requires the subclasses to define #to_hash
      def to_json
        to_hash.to_json
      end
    end
  end
end