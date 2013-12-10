module Elastictastic
  module EmbeddedDocument
    extend ActiveSupport::Concern

    included do
      include Properties
      include Dirty
      include Dirty::EmbeddedDocumentMethods
      include MassAssignmentSecurity
      include Validations

      include ActiveModel::Serializers::JSON
      include ActiveModel::Serializers::Xml

      self.include_root_in_json = false
    end

    def initialize_copy(original)
      self.write_attributes(original.read_attributes.dup)
    end

    def attributes
      {}
    end

    def ==(other)
      other.nil? ? false : @_attributes == other.read_attributes && @_embeds == other.read_embeds
    end

    def eql?(other)
      self.class == other.class && self == other
    end
  end
end
