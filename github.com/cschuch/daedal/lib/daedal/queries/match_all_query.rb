module Daedal
  module Queries
    """Class for the match all query"""
    class MatchAllQuery < Query
      def to_hash
        {match_all: {}}
      end
    end
  end
end