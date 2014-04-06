require 'spec_helper'

describe Chewy::Query::Nodes::Regexp do
  describe '#__render__' do
    def render &block
      Chewy::Query::Filters.new(&block).__render__
    end

    specify { render { names.first == /nam.*/ }.should == {regexp: {'names.first' => 'nam.*'}} }
    specify { render { names.first =~ /nam.*/ }.should == {regexp: {'names.first' => 'nam.*'}} }
    specify { render { name != /nam.*/ }.should == {not: {regexp: {'name' => 'nam.*'}}} }
    specify { render { name !~ /nam.*/ }.should == {not: {regexp: {'name' => 'nam.*'}}} }

    specify { render { names.first(flags: [:anystring, :intersection, :borogoves]) == /nam.*/ }
      .should == {regexp: {'names.first' => {value: 'nam.*', flags: 'ANYSTRING|INTERSECTION'}}} }
    specify { render { names.first(:anystring, :intersection, :borogoves) == /nam.*/ }
      .should == {regexp: {'names.first' => {value: 'nam.*', flags: 'ANYSTRING|INTERSECTION'}}} }

    specify { render { names.first(flags: [:anystring, :intersection, :borogoves]) =~ /nam.*/ }
      .should == {regexp: {'names.first' => {value: 'nam.*', flags: 'ANYSTRING|INTERSECTION'}}} }
    specify { render { names.first(:anystring, :intersection, :borogoves) =~ /nam.*/ }
      .should == {regexp: {'names.first' => {value: 'nam.*', flags: 'ANYSTRING|INTERSECTION'}}} }

    specify { render { ~names.first == /nam.*/ }.should == {regexp: {'names.first' => 'nam.*', _cache: true, _cache_key: 'nam.*'}} }
    specify { render { names.first(cache: 'name') == /nam.*/ }.should == {regexp: {'names.first' => 'nam.*', _cache: true, _cache_key: 'name'}} }
    specify { render { ~names.first(:anystring) =~ /nam.*/ }
      .should == {regexp: {'names.first' => {value: 'nam.*', flags: 'ANYSTRING'}, _cache: true, _cache_key: 'nam.*'}} }
    specify { render { names.first(:anystring, cache: 'name') =~ /nam.*/ }
      .should == {regexp: {'names.first' => {value: 'nam.*', flags: 'ANYSTRING'}, _cache: true, _cache_key: 'name'}} }
  end
end
