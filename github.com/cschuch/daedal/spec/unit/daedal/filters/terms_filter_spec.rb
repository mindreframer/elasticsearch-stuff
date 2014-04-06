require 'spec_helper'

describe Daedal::Filters::TermsFilter do

  subject do
    Daedal::Filters::TermsFilter
  end

  let(:field) do
    :foo
  end

  let(:terms) do
    [:foo, :bar]
  end

  let(:hash_filter) do
    {terms: {field => terms}}
  end

  context 'without a field or a list of terms specified' do
    it 'will raise an error' do
      expect {subject.new}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without a field specified' do
    it 'will raise an error' do
      expect {subject.new(terms: terms)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a field and a list of terms specified' do
    let(:filter) do
      subject.new(field: field, terms: terms.map {|t| t.to_s})
    end
    let(:hash_filter) do
      {terms: {field => terms.map {|t| t.to_s}}}
    end
    it 'will populate the field and term attributes appropriately' do
      expect(filter.field).to eq field
      expect(filter.terms).to eq terms.map {|t| t.to_s}
    end
    it 'will have the correct hash representation' do
      expect(filter.to_hash).to eq hash_filter
    end
    it 'will have the correct json representation' do
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end
end