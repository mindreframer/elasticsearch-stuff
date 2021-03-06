module Elastics
  class Error < StandardError; end
  class NotFound < Error; end

  require 'elastics/client'

  autoload :AutoRefresh,    'elastics/auto_refresh'
  autoload :Tasks,          'elastics/tasks'
  autoload :QueryHelper,    'elastics/query_helper'
  autoload :Result,         'elastics/result'
  autoload :VersionManager, 'elastics/version_manager'

  class << self
    attr_reader :models

    def reset_models
      @models = []
    end
  end

  reset_models
end

require 'elastics/railtie' if defined?(Rails)
