require 'spec_helper'

describe Daedal::Queries::PrefixQuery do

  subject do
    Daedal::Queries::PrefixQuery
  end

  context 'with no field or term specified' do
    it 'will raise an error' do
      expect {subject.new}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with no field specified' do
    it 'will raise an error' do
      expect {subject.new(query: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with no term specified' do
    it 'will raise an error' do
      expect {subject.new(field: :foo)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a field and a term specified' do
    let(:query) do
      subject.new(field: :foo, query: :bar)
    end
    let(:hash_query) do
      {prefix: {foo: 'bar'}}
    end

    it 'will create a prefix query with the correct values' do
      expect(query.field).to eq :foo
      expect(query.query).to eq 'bar'
    end

    it 'will have the correct hash and json representation' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a field and an upper cased term specified' do
    let(:query) do
      subject.new(field: :foo, query: 'Bar')
    end
    let(:hash_query) do
      {prefix: {foo: 'bar'}}
    end

    it 'will create a prefix query and downcase the term' do
      expect(query.field).to eq :foo
      expect(query.query).to eq 'bar'
    end

    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a boost specified' do
    let(:query) do
      subject.new(field: :foo, query: :bar, boost: 5.0)
    end
    let(:hash_query) do
      {prefix: {foo: 'bar', boost: 5.0}}
    end

    it 'will create a prefix query with the correct values' do
      expect(query.field).to eq :foo
      expect(query.query).to eq 'bar'
      expect(query.boost).to eq 5.0
    end

    it 'will have the correct hash and json representation' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end
end