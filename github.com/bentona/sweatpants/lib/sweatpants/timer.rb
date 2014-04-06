module Sweatpants
  class Timer
    attr_reader :blocks
    def initialize frequency
      @blocks = []
      @frequency = frequency
      spawn_tick_thread
    end

    def spawn_tick_thread
      Thread.new do 
        while true do
          sleep @frequency
          call_blocks
        end
      end
    end

    def call_blocks
      @blocks.each &:call
    end

    def on_tick &block
      raise 'Timer#register requires a block' unless block
      @blocks << block 
    end
  end
end