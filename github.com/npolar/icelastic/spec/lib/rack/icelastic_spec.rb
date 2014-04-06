require "spec_helper"

describe Rack::Icelastic do

  def app
    Rack::Builder.new do |builder|
      use Rack::Icelastic, :index => 'test', :type => 'rspec', :params => {:limit => 1}
      run lambda{|env| [200, {"Content-Type" => "text/plain"}, ["passed"]]}
    end
  end

  def env(query = "")
    Rack::MockRequest.env_for("/", "HTTP_HOST" => "example.org", "REQUEST_PATH" => "", "QUERY_STRING" => query)
  end

  context "#initialize" do

  end

  context "#call" do

    context "GET" do

      it "pass on non search requests" do
        status, headers, body = app.call(env)
        body[0].should == "passed"
      end

      it "search when query" do
        status, headers, body = app.call(env("q="))
        body[0].should include("feed")
      end

      it "search when field query" do
        status, headers, body = app.call(env("q-field="))
        body[0].should include("feed")
      end

      it "search when it has a filter" do
        status, headers, body = app.call(env("filter-test=filter"))
        body[0].should include("feed")
      end

      it "search when it has an exclusion filter" do
        status, headers, body = app.call(env("not-test=filter"))
        body[0].should include("feed")
      end

      it "not search on non query params" do
        status, headers, body = app.call(env("rev=1-234dsf2wf45sdf34v2d"))
        body[0].should == "passed"
      end

    end

  end

end
