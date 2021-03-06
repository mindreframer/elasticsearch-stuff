module Elastics
  class VersionManager
    class << self
      def default_version
        @default_version = ENV['ELASTICS_MAPPING_VERSION'] unless defined?(@default_version)
        @default_version
      end

      def default_version=(version)
        @default_version = version
        Elastics.models.each &:reset_elastics_index_name
      end

      def use_version(version)
        old_version = default_version
        self.default_version = version
        yield
      ensure
        self.default_version = old_version
      end
    end

    attr_reader :service_index

    def initialize(client, options = {})
      @service_index = options[:service_index] || '.elastics'
      @index_prefix = options[:index_prefix]
      @client = client
    end

    def reset
      @versions = nil
      self
    end

    def update(index, data)
      set index, versions[index].merge(data)
    end

    def set(index, data)
      @client.post index: @service_index, type: :mapping_versions,
        id: prefixed_index(index), body: data
      @versions[index] = data.with_indifferent_access
    end

    def versions
      @versions ||= Hash.new do |hash, index|
        result = @client.get index: @service_index, type: :mapping_versions,
          id: prefixed_index(index)
        if result
          hash[index] = result['_source'].with_indifferent_access
        else
          set index, current: 0
        end
      end
    end

    def current_version(index)
      versions[index][:current]
    end

    def next_version(index)
      current_version(index) + 1
    end

    def version_number(index, version)
      case version.to_s
      when 'current'  then current_version(index)
      when 'next'     then next_version(index)
      else raise NameError, "Invalid version alias: #{version}"
      end
    end

    def prefixed_index(index)
      "#{@index_prefix}#{index}"
    end

    def index_name(index, version = self.class.default_version)
      if version && version != :alias
        "#{prefixed_index(index)}-v#{version_number index, version}"
      else
        prefixed_index(index)
      end
    end
  end
end
