require 'elasticsearch'

module Sweatpants
  class Client

    attr_reader :queue, :client, :actions_to_trap, :flush_frequency

    def initialize es_params=nil
      @client = es_params.nil? ? Sweatpants.configuration.client : Elasticsearch::Client.new(es_params)
      @queue = Sweatpants.configuration.queue
      @flush_frequency = Sweatpants.configuration.flush_frequency
      @actions_to_trap = Sweatpants.configuration.actions_to_trap
      @timer = Sweatpants::Timer.new(@flush_frequency)
      @timer.on_tick { flush }
    end

    #def join; @tick_thread.join; end

    def flush
      begin
        puts @queue.dequeue
        #@client.bulk @queue.dequeue
      rescue Exception => e
        $stderr.puts e  # use a Logger, maybe @client's?
      end
    end

    def method_missing(method_name, *args, &block)
      if trap_request?(method_name, *args)
        delay(method_name, *args)
      else
        @client.send(method_name, args[0])
      end
    end

    private

    def delay method_name, *args
      request = Sweatpants::QueuedRequest.new method_name, args.first
      @queue.enqueue request.to_bulk
    end

    def trap_request? action, *args
      es_arguments = args[0]
      sweatpants_arguments = args[1] || {}
      @actions_to_trap.include?(action) unless sweatpants_arguments[:immediate]
    end
  end
end