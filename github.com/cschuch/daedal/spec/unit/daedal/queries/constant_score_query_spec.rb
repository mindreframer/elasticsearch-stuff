require 'spec_helper'

describe Daedal::Queries::ConstantScoreQuery do

  subject do
    Daedal::Queries::ConstantScoreQuery
  end

  let(:match_query) do
    Daedal::Queries::MatchQuery.new(field: :foo, query: :bar)
  end

  let(:term_filter) do
    Daedal::Filters::TermFilter.new(field: :foo, term: :bar)
  end

  let(:hash_query) do
    {constant_score: { boost: 5.0, query: match_query.to_hash}}
  end

  let(:hash_filter) do
    {constant_score: { boost: 5.0, filter: term_filter.to_hash}}
  end

  context 'without a query or a filter specified' do
    it 'will raise an error' do
      expect{subject.new(boost: 5)}.to raise_error
    end
  end

  context 'without a boost specified' do
    it 'will raise an error' do
      expect{subject.new(query: match_query)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a boost but an invalid query specified' do
    it 'will raise an error' do
      expect {subject.new(boost: 5, query: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a boost but an invalid filter specified' do
    it 'will raise an error' do
      expect {subject.new(boost: 5, filter: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a query and a boost specified' do
    let(:query) do
      subject.new(query: match_query, boost: 5)
    end

    it 'will create a constant score query with the correct query and boost' do
      expect(query.query).to eq match_query
      expect(query.boost).to eq 5.0
    end
    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_query
    end
    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a filter and a boost specified' do
    let(:query) do
      subject.new(filter: term_filter, boost: 5)
    end

    it 'will create a constant score query with the correct filter and boost' do
      expect(query.filter).to eq term_filter
      expect(query.boost).to eq 5.0
    end
    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_filter
    end
    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_filter.to_json
    end
  end
end