require 'spec_helper'

describe Daedal::Queries::FuzzyQuery do

  subject do
    Daedal::Queries::FuzzyQuery
  end

  let(:hash_query) do
    {fuzzy: {foo: {value: :bar}}}
  end

  context 'without a field' do
    it 'will raise an error' do
      expect{subject.new(query: :foo)}.to raise_error
    end
  end

  context 'without a search term' do
    it 'will raise an error' do
      expect{subject.new(field: :foo)}.to raise_error
    end
  end

  context 'with a field and a search term' do
    let(:query) do
      subject.new field: :foo, query: :bar
    end
    it 'will create a fuzzy query with the correct fields' do
      expect(query.field).to eq :foo
      expect(query.query).to eq :bar
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a boost specified' do
    let(:query) do
      subject.new field: :foo, query: :bar, boost: 5.0
    end
    
    before do
      hash_query[:fuzzy][:foo][:boost] = 5.0
    end
    it 'will set the boost correctly' do
      expect(query.boost).to eq 5.0
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a min_similarity specified' do
    let(:query) do
      subject.new field: :foo, query: :bar, min_similarity: 0.5
    end
    
    before do
      hash_query[:fuzzy][:foo][:min_similarity] = 0.5
    end
    it 'will set the min_similarity correctly' do
      expect(query.min_similarity).to eq 0.5
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a prefix_length specified' do
    let(:query) do
      subject.new field: :foo, query: :bar, prefix_length: 1
    end
    
    before do
      hash_query[:fuzzy][:foo][:prefix_length] = 1
    end
    it 'will set the prefix_length correctly' do
      expect(query.prefix_length).to eq 1
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a fuzziness of 0.5 specified' do
    let(:query) do
      subject.new(query: :bar, field: :foo, fuzziness: 0.5)
    end

    before do
      hash_query[:fuzzy][:foo][:fuzziness] = 0.5
    end

    it 'will set the fuzziness' do
      expect(query.fuzziness).to eq 0.5
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with an invalid fuzziness specified' do
    it 'will raise an error' do
      expect {subject.new(query: :bar, field: :foo, fuzziness: {})}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with max_expansions specified' do
    context 'when given an int' do
      before { hash_query[:fuzzy][:foo][:max_expansions] = 2 }
      it 'will use the max_expansions' do
        expect(subject.new(query: :bar, field: :foo, max_expansions: 2).to_hash).to eq hash_query
      end
    end
    context 'with invalid input' do
      it 'will raise an error' do
        expect {subject.new(query: :bar, field: :foo, max_expansions: {})}.to raise_error(Virtus::CoercionError)
      end
    end
  end
end