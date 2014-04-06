module Daedal
  module Attributes
    class Filter < Virtus::Attribute
      def coerce(f)
        unless f.is_a? Daedal::Filters::Filter or !required? && f.nil?
          raise Virtus::CoercionError.new(f, 'Daedal::Filters::Filter')
        end

        f
      end
    end
  end
end