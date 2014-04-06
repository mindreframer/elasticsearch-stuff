# spec/mega_lotto/configuration_spec.rb

require "spec_helper"

# client, queue, flush_frequency, actions_to_trap, timer

module Sweatpants
  describe Configuration do
    describe "#flush_frequency" do
      it "default value is 1 second" do
        Configuration.new.flush_frequency = 1
      end
    end

    describe "#actions_to_trap" do
      it "default value is [:index]" do
        Configuration.new.actions_to_trap = [:index]
      end
    end

    describe "#flush_frequency=" do
      it "can set value" do
        config = Configuration.new
        config.flush_frequency = 7
        expect(config.flush_frequency).to eq(7)
      end
    end

    describe "#actions_to_trap=" do
      it "can set value" do
        config = Configuration.new
        config.actions_to_trap = [:index, :test_action]
        expect(config.actions_to_trap).to eq([:index, :test_action])
      end
    end

    describe ".reset" do
      before :each do
        Sweatpants.configure do |config|
          config.flush_frequency = 5
        end
      end

      it "resets the configuration" do
        Sweatpants.reset
        config = Sweatpants.configuration
        expect(config.flush_frequency).to eq(1)
        expect(config.actions_to_trap).to eq([:index])
      end
    end
  end
end