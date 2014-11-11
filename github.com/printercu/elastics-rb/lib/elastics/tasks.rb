require 'active_support'
require 'active_support/core_ext'

module Elastics
  module Tasks
    require 'elastics/tasks/config'
    include Config

    require 'elastics/tasks/indices'
    include Indices

    require 'elastics/tasks/mappings'
    include Mappings

    require 'elastics/tasks/migrations'
    include Migrations

    if defined?(::ActiveRecord) && defined?(::Elastics::ActiveRecord)
      require 'elastics/active_record/tasks_config'
      include ActiveRecord::TasksConfig
    end

    extend self

    def log(*args)
      puts(*args)
    end

    private
      def each_filtered(collection, filter, &block)
        filter = filter && filter.map(&:to_s)
        collection = collection.select { |x| filter.include?(x) } if filter
        collection.each &block
      end
  end
end
