module Daedal
  module Filters
    """Class for the basic term filter"""
    class RangeFilter < Filter
  
      # required attributes
      attribute :field, Daedal::Attributes::Field

      # non required attributes
      attribute :gte,   Daedal::Attributes::QueryValue, required: false
      attribute :lte,   Daedal::Attributes::QueryValue, required: false
      attribute :gt,    Daedal::Attributes::QueryValue, required: false
      attribute :lt,    Daedal::Attributes::QueryValue, required: false

      def initialize(options={})
        super options
        unless !gte.nil? or !gt.nil? or !lt.nil? or !lte.nil?
          raise "Must give at least one of gte, gt, lt, or lte"
        end
      end
  
      def to_hash
        {range: {field => {gte: gte, lte: lte, lt: lt, gt: gt}.select {|k,v| !v.nil?}}}
      end
    end
  end
end