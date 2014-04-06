require 'spec_helper'

describe Chewy::Query::Nodes::Query do
  describe '#__render__' do
    def render &block
      Chewy::Query::Filters.new(&block).__render__
    end

    specify { render { q(query_string: {query: 'name: hello'}) }.should == {query: {query_string: {query: 'name: hello'}}} }
    specify { render { ~q(query_string: {query: 'name: hello'}) }.should == {fquery: {query: {query_string: {query: 'name: hello'}}, _cache: true}} }
  end
end
