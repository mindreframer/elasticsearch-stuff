require 'chewy/type/adapter/base'

module Chewy
  module Type
    module Adapter
      class ActiveRecord < Base
        def initialize *args
          @options = args.extract_options!
          subject = args.first
          if subject.is_a?(::ActiveRecord::Relation)
            @model = subject.klass
            @scope = subject
          else
            @model = subject
          end
        end

        def name
          @name ||= options[:name].present? ? options[:name].to_s.camelize : model.model_name.to_s
        end

        def type_name
          @type_name ||= (options[:name].presence || model.model_name).to_s.underscore
        end

        # Import method fo ActiveRecord takes import data and import options
        #
        # Import data types:
        #
        #   * Nothing passed - imports all the model data
        #   * ActiveRecord scope
        #   * Objects collection
        #   * Ids collection
        #
        # Import options:
        #
        #   <tt>:batch_size</tt> - import batch size, 1000 objects by default
        #
        # Method handles destroyed objects as well. In case of objects AcriveRecord::Relation
        # or array passed, objects, responding with true to `destroyed?` method will be deleted
        # from index. In case of ids array passed - documents with missing records ids will be
        # deleted from index:
        #
        #   users = User.all
        #   users.each { |user| user.destroy if user.incative? }
        #   UsersIndex::User.import users # inactive users will be deleted from index
        #   UsersIndex::User.import users.map(&:id) # deleted user ids will be deleted from index
        #
        def import *args, &block
          import_options = args.extract_options!
          import_options[:batch_size] ||= BATCH_SIZE
          collection = args.none? ? model_all :
            (args.one? && args.first.is_a?(::ActiveRecord::Relation) ? args.first : args.flatten)

          if collection.is_a?(::ActiveRecord::Relation)
            result = true
            merged_scope(collection).find_in_batches(import_options.slice(:batch_size)) do |group|
              result &= block.call grouped_objects(group)
            end
            result
          else
            if collection.all? { |object| object.respond_to?(:id) }
              collection.in_groups_of(import_options[:batch_size], false).map do |group|
                block.call grouped_objects(group)
              end.all?
            else
              import_ids(collection, import_options, &block)
            end
          end
        end

        def load *args
          load_options = args.extract_options!
          objects = args.flatten

          additional_scope = load_options[load_options[:_type].type_name.to_sym].try(:[], :scope) || load_options[:scope]

          scope = scoped_model(objects.map(&:id))
          loaded_objects = if additional_scope.is_a?(Proc)
            scope.instance_exec(&additional_scope)
          elsif additional_scope.is_a?(::ActiveRecord::Relation)
            scope.merge(additional_scope)
          else
            scope
          end.index_by { |object| object.id.to_s }

          objects.map { |object| loaded_objects[object.id.to_s] }
        end

      private

        attr_reader :model, :scope, :options

        def import_ids(ids, import_options = {}, &block)
          ids = ids.map(&:to_i).uniq

          indexed = true
          merged_scope(scoped_model(ids)).find_in_batches(import_options.slice(:batch_size)) do |objects|
            ids -= objects.map(&:id)
            indexed &= block.call index: objects
          end

          deleted = ids.in_groups_of(import_options[:batch_size], false).map do |group|
            block.call(delete: group)
          end.all?

          indexed && deleted
        end

        def grouped_objects(objects)
          objects.group_by do |object|
            object.destroyed? ? :delete : :index
          end
        end

        def merged_scope(target)
          scope ? scope.clone.merge(target) : target
        end

        def scoped_model(ids)
          model.where(Hash[model.primary_key.to_sym || :id, ids])
        end

        def model_all
          ::ActiveRecord::VERSION::MAJOR < 4 ? model.scoped : model.all
        end
      end
    end
  end
end
