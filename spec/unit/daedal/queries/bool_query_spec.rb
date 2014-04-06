require 'spec_helper'

describe Daedal::Queries::BoolQuery do

  subject do
    Daedal::Queries::BoolQuery
  end

  let(:match_query) do
    Daedal::Queries::MatchQuery
  end

  let(:hash_query) do
    {bool: {should: [], must: [], must_not: []}}
  end

  context 'with no initial queries specified' do
    let(:query) do
      subject.new
    end

    it 'will give an empty bool query' do
      expect(query.should).to eq Array.new
      expect(query.must).to eq Array.new
      expect(query.must_not).to eq Array.new
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_query.to_json
    end

    context 'with a minimum should match specified' do
      before do
        hash_query[:bool][:minimum_should_match] = 2
      end
      let(:query_with_min) do
        subject.new(minimum_should_match: 2)
      end
      it 'will set the minimum_should_match parameter' do
        expect(query_with_min.minimum_should_match).to eq 2
      end
      it 'will have the correct hash representation' do
        expect(query_with_min.to_hash).to eq hash_query
      end
      it 'will have the correct json representation' do
        expect(query_with_min.to_json).to eq hash_query.to_json
      end
    end

    context 'with a boost specified' do
      before do
        hash_query[:bool][:boost] = 2.0
      end
      let(:query_with_boost) do
        subject.new(boost: 2)
      end
      it 'will set the boost parameter' do
        expect(query_with_boost.boost).to eq 2
      end
      it 'will have the correct hash representation' do
        expect(query_with_boost.to_hash).to eq hash_query
      end
      it 'will have the correct json representation' do
        expect(query_with_boost.to_json).to eq hash_query.to_json
      end
    end
  end

  context 'with initial arrays of queries specified' do

    let(:should) do
      [match_query.new(field: :a, query: :b), match_query.new(field: :c, query: :d)]
    end
    let(:must) do
      [match_query.new(field: :e, query: :f), match_query.new(field: :g, query: :h)]
    end
    let(:must_not) do
      [match_query.new(field: :i, query: :j), match_query.new(field: :k, query: :l)]
    end

    let(:query) do
      subject.new(should: should, must: must, must_not: must_not)
    end

    before do
      hash_query[:bool][:should] = should.map {|q| q.to_hash}
      hash_query[:bool][:must] = must.map {|q| q.to_hash}
      hash_query[:bool][:must_not] = must_not.map {|q| q.to_hash}
    end

    it 'will create a bool query with the appropriate initial arrays of queries' do
      expect(query.should).to eq should
      expect(query.must).to eq must
      expect(query.must_not).to eq must_not
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with an initial array of non queries specified' do
    it 'will raise an error' do
      expect {subject.new(should: [:foo])}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with disable_coord specified' do
    let(:query) do
      subject.new(disable_coord: false)
    end
    before do
      hash_query[:bool][:disable_coord] = false
    end
    it 'will set disable_coord properly' do
      expect(query.disable_coord).to eq false
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with name specified' do
    let(:query) do
      subject.new(name: :foo)
    end
    before do
      hash_query[:bool][:_name] = :foo
    end
    it 'will set name properly' do
      expect(query.name).to eq :foo
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'with a non boolean name specified' do
    it 'will raise an error' do
      expect{subject.new(name: [])}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a query (not in an array) specified' do
    let(:mq) do
      match_query.new(field: :a, query: :b)
    end

    let(:query) do
      subject.new(should: mq)
    end

    it 'will convert the input into an array of the single query' do
      expect(query.should).to eq([mq])
    end
  end

  context 'when adding more queries' do
    let(:query) do
      subject.new
    end
    let(:mq) do
      match_query.new(field: :a, query: :b)
    end

    context 'with the should.<< method' do
      before do
        query.should << mq
      end
      it 'will add a should query' do
        expect(query.should).to eq [mq]
      end

      context 'twice' do
        before do
          query.should << mq
        end
        it 'will append the second query' do
          expect(query.should).to eq [mq, mq]
        end
      end

      context 'with a non-valid query' do
        it 'will raise an error' do
          expect{query.should << :foo}.to raise_error(Virtus::CoercionError)
        end
      end
    end

    context 'with the must.<< method' do
      before do
        query.must << mq
      end

      it 'will add a should query' do
        expect(query.must).to eq [mq]
      end

      context 'twice' do
        before do
          query.must << mq
        end
        it 'will append the second query' do
          expect(query.must).to eq [mq, mq]
        end
      end

      context 'with a non-valid query' do
        it 'will raise an error' do
          expect {query.must << :foo}.to raise_error(Virtus::CoercionError)
        end
      end

    end

    context 'with the must_not.<< method' do
      before do
        query.must_not << mq
      end

      it 'will add a must_not query' do
        expect(query.must_not).to eq [mq]
      end

      context 'twice' do
        before do
          query.must_not << mq
        end
        it 'will append the second query' do
          expect(query.must_not).to eq [mq, mq]
        end
      end

      context 'with a non-valid query' do
        it 'will raise an error' do
          expect {query.must_not << :foo}.to raise_error(Virtus::CoercionError)
        end
      end
    end
  end
end