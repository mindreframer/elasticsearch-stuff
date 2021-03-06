module Elastics
  module ActiveRecord
    module HelperMethods
      extend ActiveSupport::Concern

      included do
        alias_method :to_elastics, :as_json unless instance_methods.include?(:to_elastics)
      end

      module ClassMethods
        def elastics_params
          {
            index:  elastics_index_name,
            type:   elastics_type_name,
            model:  self,
          }
        end

        def request_elastics(params)
          elastics.request(elastics_params.merge!(params))
        end

        def bulk_elastics(params = {}, &block)
          elastics.bulk(elastics_params.merge!(params), &block)
        end

        def search_elastics(data = {}, options = {})
          request = {
            id:   :_search,
            body: data,
          }
          if routing = options[:routing]
            request[:query] = {routing: routing}
          end
          SearchResult.new self, request_elastics(request), options
        end

        def find_all_ordered(ids)
          items_by_id = where(id: ids).index_by(&:id)
          ids.map { |i| items_by_id[i] }
        end

        def elastics_mapping
          request_elastics(method: :get, id: :_mapping)
        end

        def index_all_elastics(*args)
          find_in_batches(*args) do |batch|
            bulk_elastics do |bulk|
              batch.each do |record|
                bulk.index record.id, record.to_elastics
              end
            end
          end
        end

        # Reindexes records with `#index_all_elastics`. If model has scope
        # named `reindex_scope`, this method will apply it.
        #
        # Also supports `:updated_after` option to reindex only updated records.
        # Nothing is performed when `:updated_after` is set but model
        # has not `updated_at` column.
        def reindex_elastics(options = {})
          scope = respond_to?(:reindex_scope) ? reindex_scope : all
          if after = options.delete(:updated_after)
            if updated_at = arel_table[:updated_at]
              scope = scope.where(updated_at.gt(after))
            else
              return
            end
          end
          scope.index_all_elastics(options)
        end

        def refresh_elastics
          request_elastics(method: :post, type: nil, id: :_refresh)
        end
      end

      def index_elastics
        self.class.request_elastics(method: :post, id: id, body: to_elastics)
      end

      def update_elastics(data)
        self.class.request_elastics(method: :post, id: "#{id}/_update", body: data)
      end

      def update_elastics_doc(fields)
        update_elastics(doc: fields)
      end

      def delete_elastics
        self.class.request_elastics(method: :delete, id: id)
      rescue NotFound
      end
    end
  end
end
