require 'spec_helper'

describe Daedal::Filters::RangeFilter do

  subject do
    Daedal::Filters::RangeFilter
  end

  let(:hash_filter) do
    {range: {foo: {gte: 1, lte: 2}}}
  end

  context 'without a field specified' do
    it 'will raise an error' do
      expect{subject.new(gte: 1, lte: 2)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without a gte, lte, lt, or gt specified' do
    it 'will raise an error' do
      expect{subject.new(field: :foo)}.to raise_error
    end
  end

  context 'with number gte and lte' do
    let(:filter) do
      subject.new(field: :foo, gte: 1, lte: 2)
    end
    it 'will create a range filter with the appropriate fields' do
      expect(filter.field).to eq :foo
      expect(filter.gte).to eq 1
      expect(filter.lte).to eq 2
    end
    it 'will have the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end

  context 'with string gte and lte' do
    let(:filter) do
      subject.new(field: :foo, gte: 'a', lte: 'b')
    end
    before do
      hash_filter[:range][:foo][:gte] = 'a'
      hash_filter[:range][:foo][:lte] = 'b'
    end
    it 'will create a range filter with the appropriate fields' do
      expect(filter.field).to eq :foo
      expect(filter.gte).to eq 'a'
      expect(filter.lte).to eq 'b'
    end
    it 'will have the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end

  context 'with number gt and lt' do
    let(:filter) do
      subject.new(field: :foo, gt: 1, lt: 2)
    end
    let(:hash_filter) do
      {range: {foo: {lt: 2, gt: 1}}}
    end
    it 'will have the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end

  context 'with string gt and lt' do
    let(:filter) do
      subject.new(field: :foo, gt: 'a', lt: 'b')
    end
    let(:hash_filter) do
      {range: {foo: {lt: 'b', gt: 'a'}}}
    end
    it 'will create a range filter with the appropriate fields' do
      expect(filter.field).to eq :foo
      expect(filter.gt).to eq 'a'
      expect(filter.lt).to eq 'b'
    end
    it 'will have the correct hash and json representations' do
      expect(filter.to_hash).to eq hash_filter
      expect(filter.to_json).to eq hash_filter.to_json
    end
  end
end