require 'spec_helper'

describe Daedal::Queries::DisMaxQuery do

  subject do
    Daedal::Queries::DisMaxQuery
  end

  let(:match_query) do
    Daedal::Queries::MatchQuery
  end

  let(:hash_query) do
    {dis_max: {queries: []}}
  end

  context 'with no initial queries specified' do
    let(:query) do
      subject.new
    end

    it 'will give an empty dis max query' do
      expect(query.queries).to eq Array.new
    end

    it 'will have the correct hash representation' do
      expect(query.to_hash).to eq hash_query
    end

    it 'will have the correct json representation' do
      expect(query.to_json).to eq hash_query.to_json
    end

    context 'with a tie breaker specified' do
      before do
        hash_query[:dis_max][:tie_breaker] = 2.0
      end
      let(:query_with_min) do
        subject.new(tie_breaker: 2)
      end
      it 'will set the tie_breaker parameter' do
        expect(query_with_min.tie_breaker).to eq 2.0
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
        hash_query[:dis_max][:boost] = 2.0
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

  context 'with initial array of queries specified' do

    let(:queries) do
      [match_query.new(field: :a, query: :b), match_query.new(field: :c, query: :d)]
    end

    let(:query) do
      subject.new(queries: queries)
    end

    before do
      hash_query[:dis_max][:queries] = queries.map {|q| q.to_hash}
    end

    it 'will create a dis_max query with the appropriate initial array of queries' do
      expect(query.queries).to eq queries
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
      expect {subject.new(queries: [:foo])}.to raise_error(Virtus::CoercionError)
    end
  end

  context 'with a query (not in an array) specified' do
    let(:mq) do
      match_query.new(field: :a, query: :b)
    end

    let(:query) do
      subject.new(queries: mq)
    end

    it 'will convert the input into an array of the single query' do
      expect(query.queries).to eq([mq])
    end
  end

  context 'with name specified' do
    let(:query) do
      subject.new(name: :foo)
    end
    before do
      hash_query[:dis_max][:_name] = :foo
    end
    it 'will set name properly' do
      expect(query.name).to eq :foo
    end
    it 'will have the correct hash and json representations' do
      expect(query.to_hash).to eq hash_query
      expect(query.to_json).to eq hash_query.to_json
    end
  end

  context 'when adding more queries' do
    let(:query) do
      subject.new
    end
    let(:mq) do
      match_query.new(field: :a, query: :b)
    end

    context 'with the queries.<< method' do
      before do
        query.queries << mq
      end
      it 'will add a query' do
        expect(query.queries).to eq [mq]
      end

      context 'twice' do
        before do
          query.queries << mq
        end
        it 'will append the second query' do
          expect(query.queries).to eq [mq, mq]
        end
      end

      context 'with a non-valid query' do
        it 'will raise an error' do
          expect{query.queries << :foo}.to raise_error(Virtus::CoercionError)
        end
      end
    end
  end
end