# mostly taken from http://brandonhilkert.com/blog/ruby-gem-configuration-patterns
module Sweatpants
  class Configuration
    attr_accessor :flush_frequency, :queue, :actions_to_trap, :client

    def initialize
      @flush_frequency = 1
      @queue = Sweatpants::SimpleQueue.new
      @actions_to_trap = [:index]
      @client = Elasticsearch::Client.new
    end

  end
end