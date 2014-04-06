require 'spec_helper'

describe Daedal::Filters::NestedFilter do

  subject do
    Daedal::Filters::NestedFilter
  end

  let(:term_filter) do
    Daedal::Filters::TermFilter.new field: 'foo', term: 'bar'
  end

  context 'with no path specified' do
    it 'will raise an error' do
      expect{subject.new(filter: term_filter)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with no filter specified' do
    it 'will raise an error' do
      expect{subject.new(path: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with an invalid filter specified' do
    it 'will raise an error' do
      expect{subject.new(filter: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a filter and a path specified' do
    let(:filter) do
      subject.new filter: term_filter, path: :foo
    end
    let(:hash_filter) do
      {nested: {path: :foo, filter: term_filter.to_hash}}
    end

    it 'will create a nested filter with the appropriate fields' do
      expect(filter.filter).to eq term_filter
      expect(filter.path).to eq :foo
    end

    it 'will have the correct hash representation' do
      expect(filter.to_hash).to eq hash_filter
    end

    it 'will have the correct json representation' do
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end

  context 'with cache set to true' do
    let(:filter) do
      subject.new filter: term_filter, path: :foo, cache: true
    end
    it 'will set _cache to true' do
      expect(filter.cache).to eq true
      expect(filter.to_hash[:nested][:_cache]).to eq true
    end
  end
end