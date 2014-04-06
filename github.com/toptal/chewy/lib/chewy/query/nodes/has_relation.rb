require 'chewy/query/compose'

module Chewy
  class Query
    module Nodes
      class HasRelation < Expr
        include Compose

        def initialize type, outer = nil
          @type = type.to_s
          @outer = outer
          @query_mode = :must
          @filter_mode = :and
          @queries = []
          @filters = []
        end

        def query_mode mode
          @query_mode = mode
          self
        end

        def filter_mode mode
          @filter_mode = mode
          self
        end

        def query params = nil, &block
          if block
            raise 'Query DLS is not supported yet'
          else
            @queries.push(params)
          end
          self
        end

        def filter params = nil, &block
          if block
            @filters.push(Chewy::Query::Filters.new(@outer, &block).__render__)
          else
            @filters.push(params)
          end
          self
        end

        def __render__
          queries = _queries_join @queries, @query_mode
          filters = _filters_join @filters, @filter_mode

          body = if filters && !queries
            {filter: filters}
          else
            _composed_query(queries, filters)
          end || {}

          {_relation => body.merge(type: @type)} if body
        end
      end
    end
  end
end
