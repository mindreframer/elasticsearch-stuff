module Daedal
  module Facets
    class Facet
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