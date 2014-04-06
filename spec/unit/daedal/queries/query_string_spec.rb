require 'spec_helper'

describe Daedal::Queries::QueryStringQuery do

  subject do
    Daedal::Queries::QueryStringQuery
  end

  let(:hash_query) do
    {query_string: {query: 'foo'}}
  end

  context 'without a query string' do
    it 'will raise an error' do
      expect{subject.new}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a query that is not a string given' do
    let(:query) do
      subject.new query: :foo
    end
    it 'will convert to a string' do
      expect(query.query).to eq 'foo'
    end
  end

  context 'with a query' do
    let(:query) do
      subject.new query: 'foo'
    end
    it 'will create a query string with the correct value' do
      expect(query.query).to eq 'foo'
    end
    it 'will have the correct hash and json representation' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a default_field' do
    let(:query) do
      subject.new query: 'foo', default_field: :bar
    end
    before do
      hash_query[:query_string][:default_field] = :bar
    end
    it 'will set the default_field' do
      expect(query.default_field).to eq :bar
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with an array of fields' do
    let(:query) do
      subject.new query: 'foo', fields: [:bar]
    end
    before do
      hash_query[:query_string][:fields] = [:bar]
    end
    it 'will set the fields' do
      expect(query.fields).to eq [:bar]
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a default_operator' do
    let(:query) do
      subject.new query: 'foo', default_operator: 'OR'
    end
    before do
      hash_query[:query_string][:default_operator] = 'OR'
    end
    it 'will set the default_operator' do
      expect(query.default_operator).to eq 'OR'
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with an analyzer' do
    let(:query) do
      subject.new query: 'foo', analyzer: :bar
    end
    before do
      hash_query[:query_string][:analyzer] = :bar
    end
    it 'will set the analyzer' do
      expect(query.analyzer).to eq :bar
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a allow_leading_wildcard' do
    let(:query) do
      subject.new query: 'foo', allow_leading_wildcard: true
    end
    before do
      hash_query[:query_string][:allow_leading_wildcard] = true
    end
    it 'will set the allow_leading_wildcard' do
      expect(query.allow_leading_wildcard).to eq true
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a lowercase_expanded_terms' do
    let(:query) do
      subject.new query: 'foo', lowercase_expanded_terms: true
    end
    before do
      hash_query[:query_string][:lowercase_expanded_terms] = true
    end
    it 'will set the lowercase_expanded_terms' do
      expect(query.lowercase_expanded_terms).to eq true
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a enable_position_increments' do
    let(:query) do
      subject.new query: 'foo', enable_position_increments: true
    end
    before do
      hash_query[:query_string][:enable_position_increments] = true
    end
    it 'will set the enable_position_increments' do
      expect(query.enable_position_increments).to eq true
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a fuzzy_max_expansions' do
    let(:query) do
      subject.new query: 'foo', fuzzy_max_expansions: 50
    end
    before do
      hash_query[:query_string][:fuzzy_max_expansions] = 50
    end
    it 'will set the fuzzy_max_expansions' do
      expect(query.fuzzy_max_expansions).to eq 50
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a fuzzy_min_sim' do
    let(:query) do
      subject.new query: 'foo', fuzzy_min_sim: 0.5
    end
    before do
      hash_query[:query_string][:fuzzy_min_sim] = 0.5
    end
    it 'will set the fuzzy_min_sim' do
      expect(query.fuzzy_min_sim).to eq 0.5
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a fuzzy_prefix_length' do
    let(:query) do
      subject.new query: 'foo', fuzzy_prefix_length: 0
    end
    before do
      hash_query[:query_string][:fuzzy_prefix_length] = 0
    end
    it 'will set the fuzzy_prefix_length' do
      expect(query.fuzzy_prefix_length).to eq 0
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a phrase_slop' do
    let(:query) do
      subject.new query: 'foo', phrase_slop: 2
    end
    before do
      hash_query[:query_string][:phrase_slop] = 2
    end
    it 'will set the phrase_slop' do
      expect(query.phrase_slop).to eq 2
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a boost' do
    let(:query) do
      subject.new query: 'foo', boost: 1.0
    end
    before do
      hash_query[:query_string][:boost] = 1.0
    end
    it 'will set the boost' do
      expect(query.boost).to eq 1.0
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a analyze_wildcard' do
    let(:query) do
      subject.new query: 'foo', analyze_wildcard: true
    end
    before do
      hash_query[:query_string][:analyze_wildcard] = true
    end
    it 'will set the analyze_wildcard' do
      expect(query.analyze_wildcard).to eq true
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a auto_generate_phrase_queries' do
    let(:query) do
      subject.new query: 'foo', auto_generate_phrase_queries: true
    end
    before do
      hash_query[:query_string][:auto_generate_phrase_queries] = true
    end
    it 'will set the auto_generate_phrase_queries' do
      expect(query.auto_generate_phrase_queries).to eq true
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a minimum_should_match' do
    let(:query) do
      subject.new query: 'foo', minimum_should_match: 2
    end
    before do
      hash_query[:query_string][:minimum_should_match] = 2
    end
    it 'will set the minimum_should_match' do
      expect(query.minimum_should_match).to eq 2
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a lenient' do
    let(:query) do
      subject.new query: 'foo', lenient: true
    end
    before do
      hash_query[:query_string][:lenient] = true
    end
    it 'will set the lenient' do
      expect(query.lenient).to eq true
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end
end