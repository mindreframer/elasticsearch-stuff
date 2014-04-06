require 'spec_helper'

describe Daedal::Filters::TermFilter do

  subject do
    Daedal::Filters::TermFilter
  end

  let(:field) do
    :foo
  end

  let(:term) do
    :bar
  end

  let(:hash_filter) do
    {term: {field => term}}
  end

  context 'without a field or a term specified' do
    it 'will raise an error' do
      expect {subject.new}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without a field specified' do
    it 'will raise an error' do
      expect {subject.new(term: term)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without a term specified' do
    it 'will raise an error' do
      expect {subject.new(field: field)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a field and a term specified' do
    let(:filter) do
      subject.new(field: field, term: term)
    end
    it 'will populate the field and term attributes appropriately' do
      expect(filter.field).to eq field
      expect(filter.term).to eq term
    end
    it 'will have the correct hash representation' do
      expect(filter.to_hash).to eq hash_filter
    end
    it 'will have the correct json representation' do
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end
end