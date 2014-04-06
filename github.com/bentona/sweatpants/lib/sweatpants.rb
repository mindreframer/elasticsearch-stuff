require "sweatpants/client"
require "sweatpants/queue"
require "sweatpants/timer"
require "sweatpants/queued_request"
require "sweatpants/configuration"

module Sweatpants
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration = Configuration.new
  end
end