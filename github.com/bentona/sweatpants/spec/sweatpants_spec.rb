require 'spec_helper'

describe Sweatpants do
  describe '::configuration' do
    it 'has a configuration member' do
      Sweatpants.configuration.should be_a Sweatpants::Configuration
    end
  end
end
