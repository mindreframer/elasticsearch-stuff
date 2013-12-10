require "cgi"
require "multi_json"

require "elasticsearch/api/version"
require "elasticsearch/api/namespace/common"
require "elasticsearch/api/utils"

Dir[ File.expand_path('../api/actions/**/*.rb', __FILE__) ].each   { |f| require f }
Dir[ File.expand_path('../api/namespace/**/*.rb', __FILE__) ].each { |f| require f }

module Elasticsearch
  module API
    COMMON_PARAMS = [
                      :ignore,                        # Client specific parameters
                      :index, :type, :id,             # :index/:type/:id
                      :body,                          # Request body
                      :node_id,                       # Cluster APIs
                      :name,                          # Template, warmer APIs
                      :field,                         # Get field mapping
                      :pretty                         # Pretty-print the response
                    ]

    # Auto-include all namespaces in the receiver
    #
    def self.included(base)
      base.send :include,
                Elasticsearch::API::Common,
                Elasticsearch::API::Actions,
                Elasticsearch::API::Cluster,
                Elasticsearch::API::Indices
    end
  end
end
