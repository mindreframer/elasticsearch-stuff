require 'spec_helper'

describe Daedal::Filters::GeoDistanceFilter do

  subject do
    Daedal::Filters::GeoDistanceFilter
  end

  context 'without a field specified' do
    it 'will raise an error' do
      expect{subject.new(distance: 5, lat: 10, lon: 30)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without a distance specified' do
    it 'will raise an error' do
      expect{subject.new(field: :foo, lat: 10, lon: 30)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without a lat specified' do
    it 'will raise an error' do
      expect{subject.new(field: :foo, distance: 10, lon: 30)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'without a lon specified' do
    it 'will raise an error' do
      expect{subject.new(field: :foo, lat: 10, distance: 30)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a field, distance, lat, and lon specified' do
    let(:query) do
      subject.new(field: :foo, distance: 5, lat: 10, lon: 30)
    end
    let(:hash_query) do
      {geo_distance: {distance: '5.0km', foo: {lat: 10.0, lon: 30.0}}}
    end

    it 'will set the field and distance appropriately' do
      expect(query.field).to eq :foo
      expect(query.distance).to eq 5.0
      expect(query.lat).to eq 10.0
      expect(query.lon).to eq 30.0
    end

    it 'will use km as the default unit' do
      expect(query.unit).to eq 'km'
    end

    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a distance unit specified' do
    let(:query) do
      subject.new(field: :foo, distance: 5, lat: 10, lon: 30, unit: 'mi')
    end
    let(:hash_query) do
      {geo_distance: {distance: '5.0mi', foo: {lat: 10.0, lon: 30.0}}}
    end

    it 'will set the field and distance appropriately' do
      expect(query.field).to eq :foo
      expect(query.distance).to eq 5.0
      expect(query.lat).to eq 10.0
      expect(query.lon).to eq 30.0
      expect(query.unit).to eq 'mi'
    end

    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with an invalid unit specified' do
    it 'will raise an error' do
      expect{subject.new(field: :foo, distance: 5, lat: 10, lon: 30, unit: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with an invalid lat specified' do
    it 'will raise an error' do
      expect{subject.new(field: :foo, distance: 5, lat: 'foo', lon: 30)}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with an invalid lon specified' do
    it 'will raise an error' do
      expect{subject.new(field: :foo, distance: 5, lat: 10, lon: 'foo')}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with an invalid distance specified' do
    it 'will raise an error' do
      expect{subject.new(field: :foo, distance: 'foo', lat: 10, lon: 30)}.to raise_error(Virtus::CoercionError)
    end
  end
end