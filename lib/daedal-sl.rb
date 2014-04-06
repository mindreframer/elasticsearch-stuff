require 'daedal'
require 'daedal-sl/version'
require 'daedal-sl/query_methods'
require 'daedal-sl/bool_query'
require 'daedal-sl/bool_filter'
require 'daedal-sl/nested_bool_filter'
require 'daedal-sl/nested_bool_query'
require 'daedal-sl/base_query'

module DaedalSL
  class << self
    def build data=nil, &block
      DaedalSL::BaseQuery.new(data, &block).to_hash
    end
  end
end