require "spec_helper"

describe Icelastic::Result do

  def result(request, search_response)
    Icelastic::Result.new(request, search_response)
  end

  def http_search(query)
    Rack::Request.new(
      Rack::MockRequest.env_for(
        "/endpoint", "HTTP_HOST" => "example.org", "REQUEST_PATH" => "/endpoint",
        "QUERY_STRING" => "#{query}"
      )
    )
  end

  def ssl_search(query)
    Rack::Request.new(
      Rack::MockRequest.env_for(
        "/endpoint", "rack.url_scheme" => "https", "HTTP_HOST" => "example.org",
        "REQUEST_PATH" => "/endpoint", "QUERY_STRING" => "#{query}"
      )
    )
  end

  context "Feed" do

    before(:each) do
      @response = {
        "took"=>34,
        "timed_out"=>false,
        "_shards"=>{"total"=>8, "successful"=>8, "failed"=>0},
        "hits"=>
        {
          "total"=>2,
          "max_score"=>0.7834767,
          "hits"=> [
            {"_source"=> {"title"=>"test1"}},
            {"_source"=> {"title"=>"test2"}}
          ]
        }
      }

      @r = result(http_search("q=nesting&filter-created=2008..2009"), @response)
    end

    it "return opensearch, list, search, facets and entries" do
      @r.stub(:opensearch){nil}
      @r.stub(:list){nil}
      @r.stub(:search){nil}
      @r.stub(:facets){nil}
      @r.stub(:entries){nil}
      @r.feed.should include(:feed)
    end

    context "Opensearch" do

      it "return totalResults" do
        @r.opensearch.should include(:totalResults => 2)
      end

      it "return itemsPerPage" do
        @r.opensearch.should include(:itemsPerPage => 25)
      end

      it "return startIndex" do
        @r.opensearch.should include(:startIndex => 0)
      end

    end

    context "List" do

      it "self uri" do
        @r.send(:self_uri).should ==
        "http://example.org/endpoint?q=nesting&filter-created=2008..2009"
      end

      it "return value for last item" do
        @response['hits']['total'] = 50
        @r.send(:last).should == 24
      end

      it "return correct value for last item on small page" do
        @r.send(:last).should == 2
      end

      context "next page" do

        it "return uri for next page" do
          @response['hits']['total'] = 50
          r = result(http_search("q=nesting&start=12&filter-created=2008..2009"), @response)
          r.send(:next_uri).should ==
          "http://example.org/endpoint?q=nesting&start=37&filter-created=2008..2009"
        end

        it "return false when total_hits < page size" do
          @r.send(:next_uri).should == false
        end

        it "false on the last page" do
          @response['hits']['total'] = 50
          r = result(http_search("q=nesting&start=25"), @response)
          r.send(:next_uri).should == false
        end

      end

      context "previous page" do

        it "return uri for previous page" do
          @response['hits']['total'] = 50
          r = result(http_search("q=nesting&start=12"), @response)
          r.send(:previous_uri).should ==
          "http://example.org/endpoint?q=nesting&start=0"
        end

        it "false on first page" do
          @r.send(:previous_uri).should == false
        end

      end


      it "include self, first, last, next, previous" do
        @r.stub(:self_uri){nil}
        @r.stub(:first){nil}
        @r.stub(:last){nil}
        @r.stub(:next){nil}
        @r.stub(:previous){nil}
        @r.list.should include(:self, :first, :last, :next, :previous)
      end

    end

    context "Search" do

      it "return qtime and q" do
        @r.search.should include(:qtime, "q")
      end

      it "return query time" do
        @r.send(:query_time).should == 34
      end

      it "return query" do
        @r.send(:query_param).should include("q" => "nesting")
      end

    end

    context "Facets" do

      before(:each) do
        @response = {
          "facets"=>{
            "topics"=>{"_type"=>"terms","missing"=>29,"total"=>189,
            "other"=>3,"terms"=>[{"term"=>"test","count"=>10}]}
          }
        }
        @r = result(http_search("q=&facets=topics"), @response)
      end

      it "be an array" do
        @r.facets.first["topics"].should be_a( Array )
      end

      it "return term" do
        @r.facets.first["topics"][0].should include(:term => "test")
      end

      it "return count" do
        @r.facets.first["topics"][0].should include(:count => 10)
      end

      it "return uri" do
        @r.facets.first["topics"][0].should include(
          :uri => "http://example.org/endpoint?q=&facets=topics&filter-topics=test"
        )
      end

      context "Uri" do

        it "add filter when not present" do
          @r.facets.first["topics"][0][:uri].should include("q=&facets=topics&filter-topics=test")
        end

        it "add value when filter exists" do
          r = result(http_search("q=&facets=topics&filter-topics=biology"), @response)
          r.facets.first["topics"][0][:uri].should include("q=&facets=topics&filter-topics=biology,test")
        end

        it "remove filter when already request url" do
          r = result(http_search("q=&facets=topics&filter-topics=biology,test"), @response)
          r.facets.first["topics"][0][:uri].should == "http://example.org/endpoint?q=&facets=topics&filter-topics=biology"
        end

        it "add filter for custom named facet" do
          response = {
            "facets"=>{
              "custom"=>{"_type"=>"terms","missing"=>29,"total"=>189,
              "other"=>3,"terms"=>[{"term"=>"test","count"=>10}]}
            }
          }

          r = result(http_search("q=&facet-custom=topics"), response)
          r.facets.first["custom"][0][:uri].should include("q=&facet-custom=topics&filter-topics=test")
        end

        it "have correct uri scheme for SSL" do
          r = result(ssl_search("q=&facets=topics"), @response)
          r.facets.first["topics"][0][:uri].should include("https://example.org/endpoint?q=&facets=topics&filter-topics=test")
        end

      end

      context "Date" do

        context "Format" do

          it "return yyyy-mm-dd on day interval " do
            r = result(http_search("q=&date-day=created"), {"facets"=>{
              "day-created"=>{"_type"=>"date_histogram", "entries"=>[
              {"time"=>1230768000000, "count"=>1}]}}}
            )
            r.facets.first["day-created"][0].should include(:term => "2009-01-01")
          end

          it "return yyyy-mm format for month interval" do
            r = result(http_search("q=&date-month=created"), {"facets"=>{
              "month-created"=>{"_type"=>"date_histogram", "entries"=>[
              {"time"=>1230768000000, "count"=>1}]}}}
            )
            r.facets.first["month-created"][0].should include(:term => "2009-01")
          end

          it "return yyyy format for year interval" do
            r = result(http_search("q=&date-year=created"), {"facets"=>{
              "year-created"=>{"_type"=>"date_histogram", "entries"=>[
              {"time"=>1230768000000, "count"=>1}]}}}
            )
            r.facets.first["year-created"][0].should include(:term => "2009")
          end

          it "return iso8601 for unknown interval" do
            r = result(http_search("q="), {"facets"=>{
              "hour-created"=>{"_type"=>"date_histogram", "entries"=>[
              {"time"=>1230768000000, "count"=>1}]}}}
            )
            r.facets.first["hour-created"][0].should include(:term => "2009-01-01T00:00:00Z")
          end

        end

        context "Uri" do

          it "24 hour range filter for days" do
            r = result(http_search("q="), {"facets"=>{
              "day-created"=>{"_type"=>"date_histogram", "entries"=>[
              {"time"=>1230768000000, "count"=>1}]}}}
            )
            r.facets.first["day-created"][0].should include(
              :uri => "http://example.org/endpoint?q=&filter-created=2009-01-01T00:00:00Z..2009-01-02T00:00:00Z"
            )
          end

          it "month range filter for months" do
            r = result(http_search("q="), {"facets"=>{
              "month-created"=>{"_type"=>"date_histogram", "entries"=>[
              {"time"=>1230768000000, "count"=>1}]}}}
            )
            r.facets.first["month-created"][0].should include(
              :uri => "http://example.org/endpoint?q=&filter-created=2009-01-01T00:00:00Z..2009-02-01T00:00:00Z"
            )
          end

          it "year range filter for years" do
            r = result(http_search("q="), {"facets"=>{
              "year-created"=>{"_type"=>"date_histogram", "entries"=>[
              {"time"=>1230768000000, "count"=>1}]}}}
            )
            r.facets.first["year-created"][0].should include(
              :uri => "http://example.org/endpoint?q=&filter-created=2009-01-01T00:00:00Z..2010-01-01T00:00:00Z"
            )
          end

        end

      end

    end

    context "Entries" do

      it "be an Array" do
        @r.entries.should be_a(Array)
      end

      it "return _source for complete documents" do
        @r.entries.should == [{"title" => "test1"},{"title" => "test2"}]
      end

      it "return fields for document segments" do
        @response['hits']['hits'].map{|e| e['fields'] = e.delete('_source'); e}
        r = result(http_search("q=nesting&fields=title"), @response)
        r.entries.should == [{"title" => "test1"},{"title" => "test2"}]
      end

    end

  end

end