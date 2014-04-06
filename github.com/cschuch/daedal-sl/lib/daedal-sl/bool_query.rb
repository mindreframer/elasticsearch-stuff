module DaedalSL
  class BoolQuery 
    include DaedalSL::QueryMethods
    attr_accessor :data, :base
    def initialize data, options, &block
      @data = data
      @base = Daedal::Queries::BoolQuery.new(options)
      if block
        instance_eval(&block)
      end
    end

    def must &block
      @base.must << block.call
    end

    def should &block
      @base.should << block.call
    end

    def must_not &block
      @base.must_not << block.call
    end

    def self.build data, options, &block
      instance = new(data, options, &block)
      instance.base
    end

  end
end