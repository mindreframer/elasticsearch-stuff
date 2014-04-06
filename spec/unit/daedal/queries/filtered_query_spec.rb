require 'spec_helper'

describe Daedal::Queries::FilteredQuery do

  subject do
    Daedal::Queries::FilteredQuery
  end

  let(:match_query) do
    Daedal::Queries::MatchQuery.new(field: :foo, query: :bar)
  end

  let(:term_filter) do
    Daedal::Filters::TermFilter.new(field: :foo, term: :bar)
  end

  let(:hash_query) do
    {filtered: {query: match_query.to_hash, filter: term_filter.to_hash}}
  end

  context 'with no query or filter specified' do

    let(:base_filter) do
      Daedal::Filters::Filter.new
    end
    let(:match_all_query) do
      Daedal::Queries::MatchAllQuery.new
    end
    let(:query) do
      subject.new
    end

    it 'will create an empty filtered query with a match_all query and a blank filter' do
      expect(query.query.to_hash).to eq match_all_query.to_hash
      expect(query.filter.to_hash).to eq base_filter.to_hash
    end
    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq({filtered: {query: {match_all: {}}, filter: nil}})
    end
  end

  context 'with an invalid query specified' do
    it 'will raise an error' do
      expect{subject.new(query: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with an invalid filter specified' do
    it 'will raise an error' do
      expect{subject.new(filter: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a query and a filter specified' do
    let(:query) do
      subject.new(query: match_query, filter: term_filter)
    end

    it 'will create a filtered query with the correct values' do
      expect(query.query).to eq match_query
      expect(query.filter).to eq term_filter
    end
    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_query
    end
    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_query.to_json
    end
  end

end