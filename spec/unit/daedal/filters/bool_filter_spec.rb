require 'spec_helper'

describe Daedal::Filters::BoolFilter do

  subject do
    Daedal::Filters::BoolFilter
  end

  let(:term_filter) do
    Daedal::Filters::TermFilter.new field: :foo, term: :bar
  end

  context 'without an initial array of filters' do
    let(:filter) do
      subject.new
    end
    let(:hash_filter) do
      {bool: {should: [], must: [], must_not: []}}
    end
    it 'will set must should and must_not to empty arrays' do
      expect(filter.must).to eq []
      expect(filter.should).to eq []
      expect(filter.must_not).to eq []
    end
    it 'will have the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end

  context 'with initial arrays of filters specified' do
    let(:filter) do
      subject.new should: [term_filter], must: [term_filter, term_filter], must_not: [term_filter, term_filter, term_filter]
    end
    let(:hash_filter) do
      {bool: {should: [term_filter.to_hash], must: [term_filter.to_hash, term_filter.to_hash], must_not: [term_filter.to_hash, term_filter.to_hash, term_filter.to_hash]}}
    end

    it 'will have the correct filter array set' do
      expect(filter.should).to eq [term_filter]
      expect(filter.must).to eq [term_filter, term_filter]
      expect(filter.must_not).to eq [term_filter, term_filter, term_filter]
    end
    it 'will have the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end

  context 'when adding more filters' do
    let(:filter) do
      subject.new
    end

    before do
      filter.should << term_filter
      filter.must << term_filter
      filter.must << term_filter
      filter.must_not << term_filter
      filter.must_not << term_filter
      filter.must_not << term_filter
    end

    it 'will append the filters to their arrays' do
      expect(filter.should).to eq [term_filter]
      expect(filter.must).to eq [term_filter, term_filter]
      expect(filter.must_not).to eq [term_filter, term_filter, term_filter]
    end
  end

  context 'with non filters during initialization' do
    it 'will raise an error' do
      expect{subject.new should: [:foo]}.to raise_error(Virtus::CoercionError)
      expect{subject.new must: [:foo]}.to raise_error(Virtus::CoercionError)
      expect{subject.new must_not: [:foo]}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'when trying to add a non filter' do
    let(:filter) do
      subject.new
    end
    it 'will raise an error' do
      expect{filter.should << :foo}.to raise_error(Virtus::CoercionError)
      expect{filter.must << :foo}.to raise_error(Virtus::CoercionError)
      expect{filter.must_not << :foo}.to raise_error(Virtus::CoercionError)
    end
  end
end