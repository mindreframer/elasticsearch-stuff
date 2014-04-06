module Daedal
  module Attributes
    """Custom coercer for the operator attribute"""
    class Operator < Virtus::Attribute
      ALLOWED_MATCH_OPERATORS = [:or, :and]
      def coerce(value)
        unless value.nil?
          value = value.to_sym
          unless ALLOWED_MATCH_OPERATORS.include? value
            raise Virtus::CoercionError.new(value, 'Daedal::Attributes::Operator')
          end
        end
        value
      end
    end
  end
end