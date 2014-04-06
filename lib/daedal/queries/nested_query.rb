module Daedal
  module Queries
    """Class for the bool query"""
    class NestedQuery < Query
  
      # required attributes
      attribute :path,        Daedal::Attributes::Field
      attribute :query,       Daedal::Attributes::Query
  
      # non required attributes
      attribute :score_mode,  Daedal::Attributes::ScoreMode,  required: false
      attribute :name,        Symbol,                         required: false
  
      def to_hash
        result = {nested: {path: path, query: query.to_hash}}
        options = {score_mode: score_mode, _name: name}.select { |k,v| !v.nil? }
        result[:nested].merge! options

        result
      end
    end
  end
end