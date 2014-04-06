module Daedal
  module Filters
    class Filter
      include Virtus.model strict: true

      def to_hash
        nil
      end

      def to_json
        to_hash.to_json
      end
    end
  end
end