module DaedalSL
  class NestedBoolFilter
    attr_accessor :data, :base
    def initialize data, options, &block
      @data = data
      @bool = DaedalSL::BoolFilter.build(data, {}, &block)
      @base = Daedal::Filters::NestedFilter.new(options.merge(filter: @bool))
    end

    def self.build data, options, &block
      instance = new(data, options, &block)
      instance.base
    end
  end
end