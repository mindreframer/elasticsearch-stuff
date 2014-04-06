module DaedalSL
  class NestedBoolQuery 
    attr_accessor :data, :base
    def initialize data, options, &block
      @data = data
      @bool = DaedalSL::BoolQuery.build(data, {}, &block)
      @base = Daedal::Queries::NestedQuery.new(options.merge(query: @bool))
    end

    def self.build data, options, &block
      instance = new(data, options, &block)
      instance.base
    end
  end
end