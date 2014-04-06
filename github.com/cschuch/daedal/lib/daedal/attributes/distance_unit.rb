module Daedal
  module Attributes
    """Custom coercer for the type attribute"""
    class DistanceUnit < Virtus::Attribute
      ALLOWED_DISTANCE_UNITS = ['mi', 'km']
      def coerce(value)
        if value.nil? or !ALLOWED_DISTANCE_UNITS.include? value.to_s
          raise Virtus::CoercionError.new(value, 'Daedal::Attributes::DistanceUnit')
        end

        value.to_s
      end
    end
  end
end