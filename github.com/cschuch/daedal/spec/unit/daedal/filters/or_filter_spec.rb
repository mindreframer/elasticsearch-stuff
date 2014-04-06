require 'spec_helper'

describe Daedal::Filters::OrFilter do

  subject do
    Daedal::Filters::OrFilter
  end

  let(:term_filter) do
    Daedal::Filters::TermFilter.new field: :foo, term: :bar
  end

  context 'without an initial array of filters' do
    let(:filter) do
      subject.new
    end
    let(:hash_filter) do
      nil
    end
    it 'will set must should and must_not to empty arrays' do
      expect(filter.filters).to eq []
    end
    it 'will have the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end

  context 'with initial array of filters specified' do
    let(:filter) do
      subject.new filters: [term_filter]
    end
    let(:hash_filter) do
      {:or => [term_filter.to_hash]}
    end

    it 'will have the correct filter array set' do
      expect(filter.filters).to eq [term_filter]
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
      filter.filters << term_filter
    end

    it 'will append the filters to their arrays' do
      expect(filter.filters).to eq [term_filter]
    end
  end

  context 'with non filters during initialization' do
    it 'will raise an error' do
      expect{subject.new filters: [:foo]}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'when trying to add a non filter' do
    let(:filter) do
      subject.new
    end
    it 'will raise an error' do
      expect{filter.filters << :foo}.to raise_error(Virtus::CoercionError)
    end
  end
end