module Daedal
  module Attributes
    """Custom coercer for the type attribute"""
    class MatchType < Virtus::Attribute
      ALLOWED_MATCH_TYPES = [:phrase, :phrase_prefix, :best_fields, :most_fields, :cross_fields]
      def coerce(value)
        unless value.nil?
          value = value.to_sym
          unless ALLOWED_MATCH_TYPES.include? value
            raise Virtus::CoercionError.new(value, 'Daedal::Attributes::MatchType')
          end
        end
        value
      end
    end
  end
end