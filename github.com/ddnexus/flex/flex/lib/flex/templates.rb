module Flex
  module Templates

    extend self
    attr_accessor :contexts
    @contexts = []

    def self.included(context)
      context.class_eval do
        Flex::Templates.contexts |= [context]
        @flex ||= ClassProxy::Base.new(context)
        @flex.extend(ClassProxy::Templates).init
        def self.flex; @flex end
        def self.template_methods; flex.templates.keys end
        eval "extend module #{context}::FlexTemplateMethods; self end"
      end
    end

  end
end
