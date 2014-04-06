require 'spec_helper'

describe Daedal::Queries::MultiMatchQuery do

  subject do
    Daedal::Queries::MultiMatchQuery
  end

  let(:term) do
    :foo
  end

  let(:fields) do
    [:a, :b]
  end

  let(:base_query) do
    {multi_match: {query: term, fields: fields}}
  end

  context 'without a field or term given' do
    it 'will raise an error' do
      expect {subject.new}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without fields given' do
    it 'will raise an error' do
      expect {subject.new(query: term)}.to raise_error(RuntimeError)
    end
  end

  context 'with a term and fields given' do

    let(:query) do
      subject.new(query: term, fields: fields)
    end

    it 'will create a match query object that has the correct field and term' do
      expect(query.fields).to eq fields
      expect(query.query).to eq term
    end

    it 'will have the other options set to nil' do
      expect(query.minimum_should_match).to eq nil
      expect(query.cutoff_frequency).to eq nil
      expect(query.type).to eq nil
      expect(query.analyzer).to eq nil
      expect(query.boost).to eq nil
      expect(query.fuzziness).to eq nil
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context "with an operator of :and specified" do

    let(:query) do
      subject.new(query: term, fields: fields, operator: :and)
    end

    before do
      base_query[:multi_match][:operator] = :and
    end

    it 'will set the operator to :and' do
      expect(query.operator).to eq :and
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non-valid operator specified' do
    it 'will raise an error' do
      expect {subject.new(query: term, fields: fields, operator: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a phrase type specified' do
    let(:query) do
      subject.new(query: term, fields: fields, type: :phrase)
    end

    before do
      base_query[:multi_match][:type] = :phrase
    end

    it 'will set the phrase type to :phrase' do
      expect(query.type).to eq :phrase
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non-valid type specified' do
    it 'will raise an error' do
      expect {subject.new(query: term, fields: fields, type: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a minimum should match of 2 specified' do
    let(:query) do
      subject.new(query: term, fields: fields, minimum_should_match: 2)
    end

    before do
      base_query[:multi_match][:minimum_should_match] = 2
    end

    it 'will set the minimum_should_match' do
      expect(query.minimum_should_match).to eq 2
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non-integer minimum should match specified' do
    it 'will raise an error' do
      expect {subject.new(query: term, fields: fields, minimum_should_match: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a cutoff frequency of 0.5 specified' do
    let(:query) do
      subject.new(query: term, fields: fields, cutoff_frequency: 0.5)
    end

    before do
      base_query[:multi_match][:cutoff_frequency] = 0.5
    end

    it 'will set the cutoff_frequency' do
      expect(query.cutoff_frequency).to eq 0.5
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non-float cutoff frequency specified' do
    it 'will raise an error' do
      expect {subject.new(query: term, fields: fields, cutoff_frequency: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with an analyzer of :foo specified' do
    let(:query) do
      subject.new(query: term, fields: fields, analyzer: :foo)
    end

    before do
      base_query[:multi_match][:analyzer] = :foo
    end

    it 'will set the analyzer' do
      expect(query.analyzer).to eq :foo
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with a boost of 2 specified' do
    let(:query) do
      subject.new(query: term, fields: fields, boost: 2)
    end

    before do
      base_query[:multi_match][:boost] = 2.0
    end

    it 'will set the boost' do
      expect(query.boost).to eq 2.0
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non integer boost specified' do
    it 'will raise an error' do
      expect {subject.new(query: term, fields: fields, boost: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a fuzziness of 0.5 specified' do
    let(:query) do
      subject.new(query: term, fields: fields, fuzziness: 0.5)
    end

    before do
      base_query[:multi_match][:fuzziness] = 0.5
    end

    it 'will set the fuzziness' do
      expect(query.fuzziness).to eq 0.5
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with an invalid fuzziness specified' do
    it 'will raise an error' do
      expect {subject.new(query: term, fields: fields, fuzziness: {})}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with prefix_length specified' do
    context 'when given an int' do
      before { base_query[:multi_match][:prefix_length] = 2 }
      it 'will use the prefix_length' do
        expect(subject.new(query: term, fields: fields, prefix_length: 2).to_hash).to eq base_query
      end
    end
    context 'with invalid input' do
      it 'will raise an error' do
        expect {subject.new(query: term, fields: fields, prefix_length: {})}.to raise_error(Virtus::CoercionError)
      end
    end
  end

  context 'with max_expansions specified' do
    context 'when given an int' do
      before { base_query[:multi_match][:max_expansions] = 2 }
      it 'will use the max_expansions' do
        expect(subject.new(query: term, fields: fields, max_expansions: 2).to_hash).to eq base_query
      end
    end
    context 'with invalid input' do
      it 'will raise an error' do
        expect {subject.new(query: term, fields: fields, max_expansions: {})}.to raise_error(Virtus::CoercionError)
      end
    end
  end

end