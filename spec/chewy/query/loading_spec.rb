require 'spec_helper'

describe Chewy::Query::Loading do
  include ClassHelpers
  before { Chewy.client.indices.delete index: '*' }

  before do
    stub_model(:city)
    stub_model(:country)
  end

  context 'multiple types' do
    let(:cities) { 6.times.map { |i| City.create!(rating: i) } }
    let(:countries) { 6.times.map { |i| Country.create!(rating: i) } }

    before do
      stub_index(:places) do
        define_type City do
          field :rating, type: 'integer', value: ->(o){ o.rating }
        end
        define_type Country do
          field :rating, type: 'integer', value: ->(o){ o.rating }
        end
      end
    end

    before { PlacesIndex.import!(cities: cities, countries: countries) }

    specify { PlacesIndex.order(:rating).limit(6).load.total_count.should == 12 }
    specify { PlacesIndex.order(:rating).limit(6).load.should =~ cities.first(3) + countries.first(3) }
    specify { PlacesIndex.order(:rating).limit(6).load(city: { scope: ->{ where('rating < 2') } })
      .should =~ cities.first(2) + countries.first(3) + [nil] }
    specify { PlacesIndex.order(:rating).limit(6).load(scope: ->{ where('rating < 2') })
      .should =~ cities.first(2) + countries.first(2) + [nil, nil] }
    specify { PlacesIndex.order(:rating).limit(6).load(city: { scope: City.where('rating < 2') })
      .should =~ cities.first(2) + countries.first(3) + [nil] }
  end
end
