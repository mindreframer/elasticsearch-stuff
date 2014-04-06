module Daedal
  module Attributes
    """Custom coercer for the value of any query - can be 
    a string, a symbol, a float, or an integer. If it's none
    of those, raises a coercion error."""
    class QueryValue < Virtus::Attribute
      ALLOWED_QUERY_VALUE_CLASSES = [String, Symbol, Float, Fixnum, Boolean, TrueClass, FalseClass]
      def coerce(q)
        if !required? and q.nil?
          return q
        elsif ALLOWED_QUERY_VALUE_CLASSES.include? q.class
          return q
        else
          raise Virtus::CoercionError.new(q, self.class)
        end
      end
    end
  end
end