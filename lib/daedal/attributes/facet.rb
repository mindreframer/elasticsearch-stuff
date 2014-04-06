module Daedal
  module Attributes
    class Facet < Virtus::Attribute
      def coerce(f)
        unless f.is_a? Daedal::Facets::Facet or !required? && f.nil?
          raise Virtus::CoercionError.new(f, 'Daedal::Facets::Facet')
        end

        f
      end
    end
  end
end