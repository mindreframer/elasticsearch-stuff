require 'spec_helper'

describe Daedal::Filters::AndFilter do

  subject do
    Daedal::Filters::AndFilter
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
    it 'will have an empty array of filters set' do
      expect(filter.filters).to eq []
    end
    it 'will have the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end

  context 'with an initial array of filters' do
    let(:filter) do
      subject.new filters: [term_filter]
    end
    let(:hash_filter) do
      {:and => [term_filter.to_hash]}
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
    let(:hash_filter) do
      {:and => [term_filter.to_hash]}
    end

    before do
      filter.filters << term_filter
    end

    it 'will append the filter' do
      expect(filter.filters).to eq [term_filter]
    end
    it 'will end up with the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end

    context 'twice' do
      before do
        filter.filters << term_filter
        hash_filter[:and] << term_filter.to_hash
      end
      it 'will append the second filter' do
        expect(filter.filters).to eq [term_filter, term_filter]
      end
      it 'will still have the correct hasha nd json representations' do
        expect(filter.to_hash).to eq hash_filter
        expect(filter.to_json).to eq hash_filter.to_json
      end
    end

    context 'when adding an invalid filter' do
      it 'will raise an error' do
        expect{filter.filters << :foo}.to raise_error(Virtus::CoercionError)
      end
    end
  end
end