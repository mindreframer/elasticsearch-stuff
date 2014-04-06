require 'spec_helper'

describe Daedal::Queries::MatchQuery do

  subject do
    Daedal::Queries::MatchQuery
  end

  let(:base_query) do
    {match: {foo: {query: :bar}}}
  end

  context 'without a field or term given' do
    it 'will raise an error' do
      expect {subject.new}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without a term given' do
    it 'will raise an error' do
      expect {subject.new(field: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a field and term given' do

    let(:match_query) do
      subject.new(field: :foo, query: :bar)
    end

    it 'will create a match query object that has the correct field and term' do
      expect(match_query.field).to eq :foo
      expect(match_query.query).to eq :bar
    end

    it 'will have the other options set to nil' do
      expect(match_query.minimum_should_match).to eq nil
      expect(match_query.cutoff_frequency).to eq nil
      expect(match_query.type).to eq nil
      expect(match_query.analyzer).to eq nil
      expect(match_query.boost).to eq nil
      expect(match_query.fuzziness).to eq nil
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context "with an operator of :and specified" do

    let(:match_query) do
      subject.new(field: :foo, query: :bar, operator: :and)
    end

    before do
      base_query[:match][:foo][:operator] = :and
    end

    it 'will set the operator to :and' do
      expect(match_query.operator).to eq :and
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non-valid operator specified' do
    it 'will raise an error' do
      expect {subject.new(field: :foo, query: :bar, operator: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a phrase type specified' do
    let(:match_query) do
      subject.new(field: :foo, query: :bar, type: :phrase)
    end

    before do
      base_query[:match][:foo][:type] = :phrase
    end

    it 'will set the phrase type to :phrase' do
      expect(match_query.type).to eq :phrase
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non-valid type specified' do
    it 'will raise an error' do
      expect {subject.new(field: :foo, query: :bar, type: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a minimum should match of 2 specified' do
    let(:match_query) do
      subject.new(field: :foo, query: :bar, minimum_should_match: 2)
    end

    before do
      base_query[:match][:foo][:minimum_should_match] = 2
    end

    it 'will set the phrase type to :phrase' do
      expect(match_query.minimum_should_match).to eq 2
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non-integer minimum should match specified' do
    it 'will raise an error' do
      expect {subject.new(field: :foo, query: :bar, minimum_should_match: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a cutoff frequency of 0.5 specified' do
    let(:match_query) do
      subject.new(field: :foo, query: :bar, cutoff_frequency: 0.5)
    end

    before do
      base_query[:match][:foo][:cutoff_frequency] = 0.5
    end

    it 'will set the phrase type to :phrase' do
      expect(match_query.cutoff_frequency).to eq 0.5
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non-float cutoff frequency specified' do
    it 'will raise an error' do
      expect {subject.new(field: :foo, query: :bar, cutoff_frequency: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with an analyzer of :foo specified' do
    let(:match_query) do
      subject.new(field: :foo, query: :bar, analyzer: :foo)
    end

    before do
      base_query[:match][:foo][:analyzer] = :foo
    end

    it 'will set the phrase type to :phrase' do
      expect(match_query.analyzer).to eq :foo
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context 'with a boost of 2 specified' do
    let(:match_query) do
      subject.new(field: :foo, query: :bar, boost: 2)
    end

    before do
      base_query[:match][:foo][:boost] = 2.0
    end

    it 'will set the phrase type to :phrase' do
      expect(match_query.boost).to eq 2.0
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non integer boost specified' do
    it 'will raise an error' do
      expect {subject.new(field: :foo, query: :bar, boost: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a slop of 2 specified' do
    let(:match_query) do
      subject.new(field: :foo, query: :bar, slop: 2)
    end

    before do
      base_query[:match][:foo][:slop] = 2
    end

    it 'will set the phrase type to :phrase' do
      expect(match_query.slop).to eq 2
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context 'with a non integer slop specified' do
    it 'will raise an error' do
      expect {subject.new(field: :foo, query: :bar, slop: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a fuzziness of 0.5 specified' do
    let(:match_query) do
      subject.new(field: :foo, query: :bar, fuzziness: 0.5)
    end

    before do
      base_query[:match][:foo][:fuzziness] = 0.5
    end

    it 'will set fuzziness correctly' do
      expect(match_query.fuzziness).to eq 0.5
    end

    it 'will have the correct hash representation' do
      expect(match_query.to_hash).to eq base_query
    end

    it 'will have the correct json representation' do
      expect(match_query.to_json).to eq base_query.to_json
    end
  end

  context 'with an invalid fuzziness specified' do
    it 'will raise an error' do
      expect {subject.new(field: :foo, query: :bar, fuzziness: {})}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a lenient specified' do
    let(:query) do
      subject.new field: :foo, query: :bar, lenient: true
    end
    
    before do
      base_query[:match][:foo][:lenient] = true
    end
    it 'will set the lenient correctly' do
      expect(query.lenient).to eq true
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq base_query
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with a max_expansions specified' do
    let(:query) do
      subject.new field: :foo, query: :bar, max_expansions: 1
    end
    
    before do
      base_query[:match][:foo][:max_expansions] = 1
    end
    it 'will set the max_expansions correctly' do
      expect(query.max_expansions).to eq 1
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq base_query
      expect(query.to_json).to eq base_query.to_json
    end
  end

  context 'with a prefix_length specified' do
    let(:query) do
      subject.new field: :foo, query: :bar, prefix_length: 1
    end
    
    before do
      base_query[:match][:foo][:prefix_length] = 1
    end
    it 'will set the prefix_length correctly' do
      expect(query.prefix_length).to eq 1
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq base_query
      expect(query.to_json).to eq base_query.to_json
    end
  end
end