require 'spec_helper'

describe Daedal::Queries::NestedQuery do

  subject do
    Daedal::Queries::NestedQuery
  end

  let(:match_all_query) do
    Daedal::Queries::MatchAllQuery.new
  end

  context 'with no path specified' do
    it 'will raise an error' do
      expect{subject.new(query: match_all_query)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with no query specified' do
    it 'will raise an error' do
      expect{subject.new(path: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with an invalid query specified' do
    it 'will raise an error' do
      expect{subject.new(query: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a query and a path specified' do
    let(:query) do
      subject.new query: match_all_query, path: :foo
    end
    let(:hash_query) do
      {nested: {path: :foo, query: match_all_query.to_hash}}
    end

    it 'will create a nested query with the appropriate fields' do
      expect(query.query).to eq match_all_query
      expect(query.path).to eq :foo
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with score_mode specified' do
    let(:query) do
      subject.new query: match_all_query, path: :foo, score_mode: :avg
    end
    let(:hash_query) do
      {nested: {path: :foo, query: match_all_query.to_hash, score_mode: :avg}}
    end

    it 'will create a nested query with the appropriate fields' do
      expect(query.query).to eq match_all_query
      expect(query.path).to eq :foo
      expect(query.score_mode).to eq :avg
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_query
    end
    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with an invalid score_mode specified' do
    it 'will raise an error' do
      expect{subject.new(query: match_all_query, path: :foo, score_mode: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end
end