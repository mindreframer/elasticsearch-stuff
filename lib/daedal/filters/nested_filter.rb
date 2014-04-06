module Daedal
  module Filters
    """Class for the nested filter"""
    class NestedFilter < Filter
  
      # required attributes
      attribute :path,        Daedal::Attributes::Field
      attribute :filter,      Daedal::Attributes::Filter
  
      # non required attributes
      attribute :cache,       Boolean,                        required: false
      attribute :name,        Symbol,                         required: false
  
      def to_hash
        result = {nested: {path: path, filter: filter.to_hash}}
        options = {_name: name, _cache: cache}.select { |k,v| !v.nil? }
        result[:nested].merge! options

        result
      end
    end
  end
end