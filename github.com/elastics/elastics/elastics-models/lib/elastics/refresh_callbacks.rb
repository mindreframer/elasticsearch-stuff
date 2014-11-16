module Elastics
  module RefreshCallbacks

    def self.included(base)
      base.class_eval do
        raise NotImplementedError, "the class #{self} must implement :after_create, :after_update and :after_destroy callbacks" \
              unless respond_to?(:after_save) && respond_to?(:after_destroy)
        refresh = proc{ Elastics.refresh_index :index => self.class.elastics.index }
        after_save    &refresh
        after_destroy &refresh
      end
    end

  end
end
