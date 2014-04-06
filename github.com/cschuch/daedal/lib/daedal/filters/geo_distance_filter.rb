module Daedal
  module Filters
    """Class for the basic term filter"""
    class GeoDistanceFilter < Filter
  
      # required attributes
      attribute :field,     Daedal::Attributes::Field
      attribute :lat,       Float
      attribute :lon,       Float
      attribute :distance,  Float

      # non required attributes
      attribute :unit,      Daedal::Attributes::DistanceUnit, default: 'km'
  
      def full_distance
        "#{distance}#{unit}"
      end

      def to_hash
        {geo_distance: {distance: full_distance, field => {lat: lat, lon: lon}}}
      end
    end
  end
end