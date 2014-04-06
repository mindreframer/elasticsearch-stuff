require 'spec_helper'
require 'fakeredis'

describe Sweatpants::RedisQueue do

  let(:request_1) { {foo: "bar", baz: "buzz"}.to_json }
  let(:request_2) { {some: "stuff"}.to_json }
  let(:request_3) { {other: "things"}.to_json }
  let(:request_4) { {fizz: 'bang'}.to_json }

  describe '#initialize' do
    it "initializes with default params" do
      queue = Sweatpants::RedisQueue.new
    end
  end
  
  describe '#enqueue' do
    
    before :each do
      Redis.new.flushall
      @queue = Sweatpants::RedisQueue.new(server: Redis.new)
    end

    it "can enqueue requests (json strings)" do
      @queue.enqueue(request_1)
      @queue.enqueue(request_2)
      expect(@queue.peek(2)).to eq([request_1, request_2])
    end
  end

  describe '#dequeue' do

    before :each do
      Redis.new.flushall
      @queue = Sweatpants::RedisQueue.new(server: Redis.new)
    end
    
    it "dequeues all requests by default" do
      @queue.enqueue(request_1)
      @queue.enqueue(request_2)
      expect(@queue.dequeue).to eq([request_1, request_2])
    end

    it "dequeues the specified number of requests" do
      @queue.enqueue(request_1)
      @queue.enqueue(request_2)
      @queue.enqueue(request_3)
      @queue.enqueue(request_4)
      expect(@queue.dequeue(1)).to eq([request_1])
      expect(@queue.dequeue(2)).to eq([request_2, request_3])
    end
  end

end