require "spec_helper"

describe Icelastic::CsvWriter do

  def writer(q=nil)
    Icelastic::CsvWriter.new(request(q), documents)
  end

  def request(query=nil)
    query ||= "q=&format=csv&fields=measurement,label,sarray"
    Rack::Request.new(
      Rack::MockRequest.env_for(
        "/endpoint", "HTTP_HOST" => "example.org", "REQUEST_PATH" => "/endpoint",
        "QUERY_STRING" => query
      )
    )
  end

  def documents
    [
      {
        "measurement" => 3464123760.410081,
        "label" => "text",
        "sarray" => ["a","b","c"],
        "narray" => [1,2,3],
        "object" => {"key" => "value"}
      },
      {
        "measurement" => 3464123760.410081,
        "label" => "text",
        "sarray" => ["a","b","c"],
        "narray" => [1,2,3],
        "aarray" => [[1,3],[2,4],[3,5]],
        "object" => {"key" => "value"}
      },
      {
        "measurement" => 3464123760.410081,
        "label" => "text",
        "narray" => [1,2,3],
        "oarray" => [{"a" => "v1"},{"b" => "v2"},{"c" => "v3"}],
        "object" => {"key" => "value"},
        "nested" => {"key" => {"nested_key" => "nVal"}}
      }
    ]
  end

  def config
    {:index => "test", :type => "rspec" }
  end

  context "#initialize" do
    
    it "set the request env" do
      writer.env.should include('QUERY_STRING')
    end

    it "set a document array" do
      writer.documents.should be_a_kind_of( Array )
    end

  end

  context "#build" do

    it "return top lvl csv when fields=nil" do
      writer("q=").build.should include(
        "3464123760.410081\ttext\tnull\t1|2|3\t{\"key\":\"value\"}\tnull\t{\"a\":\"v1\"}|{\"b\":\"v2\"}|{\"c\":\"v3\"}\t{\"key\":\"{\"nested_key\":\"nVal\"}\"}"
      )
    end

    it "return top lvl header when fields=nil" do
      writer("q=").build.should include(
        "measurement\tlabel\tsarray\tnarray\tobject\taarray\toarray\tnested\n"
      )
    end

    it "when fields generate header" do
      writer.build.should include("measurement\tlabel\tsarray\n")
    end

    it "when fields generate row" do
      writer.build.should include("3464123760.410081\ttext\ta|b|c\n")
    end

  end

end