require 'spec_helper'

describe Sweatpants::Timer do

  before :each do
    @timer = Sweatpants::Timer.new 1
  end

  describe '#on_tick' do

    context 'block given' do

      before :each do
        3.times{ @timer.on_tick {} }
      end

      it 'stores the given blocks' do
        expect(@timer).to have(3).blocks
      end
    end

    context 'block not given' do
      it 'throws an exception when no block is given' do
        expect{ @timer.on_tick }.to raise_error
      end
    end
  end

  describe '#call_blocks' do

    context 'with blocks present' do
     
      before :each do
        @block_1_called = false
        @block_2_called = false
        
        @timer.on_tick do
          @block_1_called = true
        end
        
        @timer.on_tick do
          @block_2_called = true
        end
      end

      it 'calls all blocks present' do  
        @timer.call_blocks
        expect(@block_1_called).to be_true
        expect(@block_2_called).to be_true
      end
    end

    context 'with no blocks present' do
      it 'should not raise when no blocks are present' do
        @timer.call_blocks
      end
    end
  end
end