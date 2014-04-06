module Daedal
  module Attributes
    """Custom coercer for the type attribute"""
    class LowerCaseString < Virtus::Attribute
      def coerce(value)
        value = value.to_s
        if value.empty?
          raise Virtus::CoercionError.new(value, 'Daedal::Attributes::LowerCaseString')
        end
        value.downcase
      end
    end
  end
end