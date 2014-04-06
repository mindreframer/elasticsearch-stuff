require 'spec_helper'

describe Daedal::Queries::MatchAllQuery do

  subject do
    Daedal::Queries::MatchAllQuery.new
  end

  context 'when calling #new' do
    it 'will have the correct hash representation' do
      expect(subject.to_hash).to eq({match_all: {}})
    end
    it 'will have the correct json representation' do
      expect(subject.to_json).to eq({match_all: {}}.to_json)
    end
  end

end