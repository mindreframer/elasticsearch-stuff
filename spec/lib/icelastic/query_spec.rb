require "spec_helper"
require "icelastic/query.rb"

describe Icelastic::Query do

  subject do
    query = Icelastic::Query.new
  end

  context "#params" do

    it "q=* when no params provided" do
      subject.params.should == {"q" => "*"}
    end

    it "expose a parameter hash" do
      subject.params = {"q" => "my query"}
      subject.params.should == {"q" => "my query"}
    end

  end

  context "#params=" do

    it "convert parameter string to hash" do
      subject.params = "q=my query&filter-field=value"
      subject.params.should == {"q" => "my query", "filter-field" => "value"}
    end

    it "raise error when non Hash || String argument" do
      expect { subject.params = ["Array"] }.to raise_error
    end

  end

  context "Query building" do

    context "#build" do

      before(:each) do
        subject.stub(:query_block){{:query => :called}}
        subject.stub(:fields){{:fields => [:called]}}
        subject.stub(:highlight){{:highlight => :called}}
        subject.stub(:facets){{:facets => {:term => :called}}}
        subject.stub(:sort){{:sort => [:called]}}
      end

      it "generate complete json query" do
        subject.params = "q=nesting&filter-created=2008..2009&fields=title,summary&facets=topics"
        subject.build.should == {
          :from => 0,
          :size => 25,
          :sort => [:called],
          :fields => [:called],
          :highlight => :called,
          :query => :called,
          :facets => {:term => :called}
        }.to_json
      end

    end

    context "#query_block" do

      it "generate regular query syntax" do
        subject.params = "q="
        subject.stub(:global_query){:global_query_called}
        subject.query_block.should == {:query => :global_query_called}
      end

      it "generate filtered query syntax" do
        subject.params = "q=&not-text=test"
        subject.stub(:filtered_query){:filtered_query_called}
        subject.query_block.should == {:query => :filtered_query_called}
      end

    end

  end

  context "Query Segments" do

    context "#query_string" do

      it "call #global_query when q" do
        subject.stub(:global_query){:global_query}
        subject.params = "q="
        subject.query_string.should == :global_query
      end

      it "call #field_query when q-<field>,*" do
        subject.stub(:field_query){:field_query}
        subject.params = "q-title="
        subject.query_string.should == :field_query
      end

      it "do a wildcard query when no q= is in the query" do
        subject.params = "?facets=false"
        subject.query_string.should == {
        :query_string => {
          :default_field => :_all,
          :query => "*"
        }
      }
      end

    end

    context "#global_query" do

      it "handle q=" do
        subject.params = "q="
        subject.global_query.should == {
          :query_string => {
            :default_field => :_all,
            :query => "*"
          }
        }
      end

      it "handle as semi fuzzy q=inter" do
        subject.params = "q=inter"
        subject.global_query.should == {
          :query_string => {
            :default_field => :_all,
            :query => "inter inter*"
          }
        }
      end

      it "handle q=\"explicit qeury\"" do
        subject.params = "q=\"explicit query\""
        subject.global_query.should == {
          :query_string => {
            :default_field => :_all,
            :query => "explicit query"
          }
        }
      end

      it "ignore ! characters in q=" do
        subject.params = "q=BOO!"
        subject.global_query.should == {
          :query_string => {
            :default_field => :_all,
            :query => "BOO BOO*"
          }
        }
      end

      it "strip extra whitespaces in q=" do
        subject.params = "q= my  sloppy query!   "
        subject.global_query.should == {
          :query_string => {
            :default_field => :_all,
            :query => "my sloppy query my sloppy query*"
          }
        }
      end

      it "handle q=<value>" do
        subject.params = "q=search"
        subject.global_query.should == {
          :query_string => {
            :default_field => :_all,
            :query => "search search*"
          }
        }
      end

    end

    context "#field_query" do

      it "handle q-<field>=<value>" do
        subject.params = "q-title=search"
        subject.field_query.should == {
          :query_string => {
            :default_field => "title",
            :query => "search search*"
          }
        }
      end

      it "?q=<value> when recieving ?q-=<value>" do
        subject.params = "q-=search"
        subject.query_string.should == {
          :query_string => {
            :default_field => :_all,
            :query => "search search*"
          }
        }
      end

      it "handle q-<field1>,<field2>=<value>" do
        subject.params = "q-title,summary=search"
        subject.field_query.should == {
          :query_string => {
            :fields => ["title", "summary"],
            :query => "search search*"
          }
        }
      end

      it "handle q-<field.*>" do
        subject.params = "q-block.*=search"
        subject.field_query.should == {
          :query_string => {
            :fields => ["block.*"],
            :query => "search search*"
          }
        }
      end

    end

    context "#filtered_query" do

      it "generate filtered query structure" do
        subject.params = "q=&filter-title=test"
        subject.stub(:query_string){:query_segment}
        subject.stub(:filter){:filter_segment}
        subject.filtered_query.should == {
          :filtered => {
            :query => :query_segment,
            :filter => :filter_segment
          }
        }
      end

    end

  end

  context "Filter Segments" do

    context "#filter" do

      it "handle filter-<field>=<value>" do
        subject.params = "q=&filter-test=value"
        subject.filter.should == {
          :and => [
            {:term => {"test" => "value"}}
          ]
        }
      end

      it "handle filter-<field>=<value1>,<value2>" do
        subject.params = "q=&filter-test.field=value1,value2"
        subject.filter.should == {
          :and => [
            {:term => {"test.field" => "value1"}},
            {:term => {"test.field" => "value2"}}
          ]
        }
      end

      it "handle filter-<field>=<value>&filter-<field>=<value>" do
        subject.params = "q=&filter-test1=value&filter-test2=value"
        subject.filter.should == {
          :and => [
            {:term => {"test1" => "value"}},
            {:term => {"test2" => "value"}}
          ]
        }
      end

      context "OR filter" do

        it "handle filter-<field>=<value1>|<value2>" do
          subject.params="q=&filter-test=val1|val2"
          subject.filter.should == {
            :and => [
              {
                :or => [
                  {:term => {"test" => "val1"}},
                  {:term => {"test" => "val2"}}
                ]
              }
            ]
          }
        end

        it "handle filter-<field>=<value1>|<value2>,<value3>" do
          subject.params="q=&filter-test=val1|val2,val3"
          subject.filter.should == {
            :and => [
              {
                :or => [
                  {:term => {"test" => "val1"}},
                  {:term => {"test" => "val2"}}
                ]
              },
              {:term => {"test" => "val3"}}
            ]
          }
        end

      end

      context "Range filter" do

        it "handle filter-<field>=<value1>..<value2>" do
          subject.params="q=&filter-test=1..10"
          subject.filter.should == {
            :and => [
              {:range => {"test" => {:gte => "1", :lte => "10"}}}
            ]
          }
        end

        it "handle filter-<field>=<value1>.." do
          subject.params="q=&filter-test=5.."
          subject.filter.should == {
            :and => [
              {:range => {"test" => {:gte => "5"}}}
            ]
          }
        end

        it "handle filter-<field>=..<value2>" do
          subject.params="q=&filter-test=..5"
          subject.filter.should == {
            :and => [
              {:range => {"test" => {:lte => "5"}}}
            ]
          }
        end

        it "handle filter-<field>=20..10" do
          subject.params="q=&filter-test=20..10"
          subject.filter.should == {
            :and => [
              {:range => {"test" => {:gte => "10", :lte => "20"}}}
            ]
          }
        end

        it "handle filter-<date_time_field>=<dt1>..<dt2>" do
          subject.params="q=&filter-date=2013-08-01T15:00:00Z..2013-08-01T12:00:00Z"
          subject.filter.should == {
            :and => [
              {:range => {"date" => {:gte => "2013-08-01T12:00:00Z", :lte => "2013-08-01T15:00:00Z"}}}
            ]
          }
        end

      end

      context "NOT filter" do

        it "handle not-<field>=<value>" do
          subject.params = "q=&not-test=value"
          subject.filter.should == {
            :and => [
              {:not => {:term => {"test" => "value"}}}
            ]
          }
        end

        it "handle not-<field>=20..10" do
          subject.params="q=&not-test=20..10"
          subject.filter.should == {
            :and => [
              {
                :not => {:range => {"test" => {:gte => "10", :lte => "20"}}}
              }
            ]
          }
        end

        it "handle not-<field>=20..10|30..50" do
          subject.params="q=&not-test=20..10|30..50"
          subject.filter.should == {
            :and => [
              {
                :not => {
                  :or => [
                    {:range => {"test" => {:gte => "10", :lte => "20"}}},
                    {:range => {"test" => {:gte => "30", :lte => "50"}}}
                  ]
                }
              }
            ]
          }
        end

        it "handle not-<field>=<val1>,<val2>|<val3>,<val4>..<val5>" do
          subject.params="q=&not-test=5,10|50,60..90"
          subject.filter.should == {
            :and => [
              {:not => {:term => {"test" => "5"}}},
              {:not =>
                {
                  :or => [
                    {:term => {"test" => "10"}},
                    {:term => {"test" => "50"}}
                  ]
                }
              },
              {:not => {:range => {"test" => {:gte => "60", :lte => "90"}}}}
            ]
          }
        end

      end

    end

  end

  context "Facets" do

    context "Term Facets" do

      it "handle facets=<field1>,<field2>" do
        subject.params = "q=&facets=topics,tags"
        subject.facets.should == {
          :facets => {
            "topics" => {
              :terms => {:field => "topics", :size => 10}
            },
            "tags" => {
              :terms => {:field => "tags", :size => 10}
            }
          }
        }
      end

      it "handle facet-<name>=<field>" do
        subject.params = "q=&facet-my_facet=test"
        subject.facets.should == {
          :facets => {
            "my_facet" => {
              :terms => {:field => "test", :size => 10}
            }
          }
        }
      end

      it "handle facet chaining &facets=<field2>,<field3>&facet-<name>=field" do
        subject.params = "q=&facets=link,tags&facet-keywords=topics"
        subject.facets.should == {
          :facets => {
            "link" => {
              :terms => {:field => "link", :size => 10}
            },
            "tags" => {
              :terms => {:field => "tags", :size => 10}
            },
            "keywords" => {
              :terms => {:field => "topics", :size => 10}
            }
          }
        }
      end

      it "handle size-facet=<val>" do
        subject.params = "q=&facet-my_facet=test&size-facet=15"
        subject.facets.should == {
          :facets => {
            "my_facet" => {
              :terms => {:field => "test", :size => 15}
            }
          }
        }
      end

    end

    context "Statistical Facets" do

      it "handle stat-<name>=<field>" do
        subject.params = "q=&stat-temperature_statistic=temperature"
        subject.facets.should == {
          :facets => {
            "temperature_statistic" => {
              :statistical => {:field => "temperature"}
            }
          }
        }
      end

      it "handle stat chaining &stats=<field1>,<field2>" do
        subject.params = "q=&stats=salinity,oxygen"
        subject.facets.should == {
          :facets => {
            "salinity-statistics" => {
              :statistical => {:field => "salinity"}
            },
            "oxygen-statistics" => {
              :statistical => {:field => "oxygen"}
            }
          }
        }
      end

    end

    context "Date Facets" do

      it "handle date-year=<field>" do
        subject.params = "q=&date-year=created"
        subject.facets.should == {
          :facets => {
            "year-created" => {
              :date_histogram => {
                :field => "created",
                :interval => "year"
              }
            }
          }
        }
      end

      it "handle date-month=<field>" do
        subject.params = "q=&date-month=created"
        subject.facets.should == {
          :facets => {
            "month-created" => {
              :date_histogram => {
                :field => "created",
                :interval => "month"
              }
            }
          }
        }
      end

      it "handle date-day=<field>" do
        subject.params = "q=&date-day=created"
        subject.facets.should == {
          :facets => {
            "day-created" => {
              :date_histogram => {
                :field => "created",
                :interval => "day"
              }
            }
          }
        }
      end

      it "handle date-<interval>=<field1>,<field2>" do
        subject.params = "q=&date-year=created,updated"
        subject.facets.should == {
          :facets => {
            "year-created" => {
              :date_histogram => {
                :field => "created",
                :interval => "year"
              }
            },
            "year-updated" => {
              :date_histogram => {
                :field => "updated",
                :interval => "year"
              }
            }
          }
        }
      end

      it "handle date-year=<field1>,<field2>&date-month=<field3>" do
        subject.params = "q=&date-year=created,updated&date-month=position_date"
        subject.facets.should == {
          :facets => {
            "year-created" => {
              :date_histogram => {
                :field => "created",
                :interval => "year"
              }
            },
            "year-updated" => {
              :date_histogram => {
                :field => "updated",
                :interval => "year"
              }
            },
            "month-position_date" => {
              :date_histogram => {
                :field => "position_date",
                :interval => "month"
              }
            }
          }
        }
      end

    end

    context "Facet Disabling" do

      it "not return facets when ?facets=false" do
        subject.params = "q=&facets=false"
        subject.facets.should == nil
      end

      it "not return date facets when ?facets=false" do
        subject.params = "q=&facets=false&date-year=created"
        subject.facets.should == nil
      end

    end

  end

  context "Sorting" do

    it "sort ascending on sort=<field>" do
      subject.params = "q=&sort=title"
      subject.sort.should == {:sort =>
        [{"title" => {:order => :asc, :ignore_unmapped => true}}]
      }
    end

    it "sort descending on sort=-<field>" do
      subject.params = "q=&sort=-title"
      subject.sort.should == {
        :sort => [
          {"title" => {:order => :desc, :ignore_unmapped => true}}
        ]
      }
    end

    it "handle multi sort on sort=<field1>,-<field2>" do
      subject.params = "q=&sort=location,-rating"
      subject.sort.should == {
        :sort => [
          {"location" => {:order => :asc, :ignore_unmapped => true}},
          {"rating" => {:order => :desc, :ignore_unmapped => true}}
        ]
      }
    end

    it "handle chained sort params &sort=<field1>&sort=field2" do
      subject.params = "q=&sort=location&sort=rating"
      subject.sort.should == {
        :sort => [
          {"location" => {:order => :asc, :ignore_unmapped => true}},
          {"rating" => {:order => :asc, :ignore_unmapped => true}}
        ]
      }
    end

  end

  context "Paging" do

    it "start at 0 when undefined" do
      subject.params = "q="
      subject.start.should == {:from => 0}
    end

    it "handle start=<pos>" do
      subject.params = "q=&start=10"
      subject.start.should == {:from => 10}
    end

    it "set limit to 25 when undefined" do
      subject.params = "q="
      subject.limit.should == {:size => 25}
    end

    it "handle limit=<size>" do
      subject.params = "q=&limit=10"
      subject.limit.should == {:size => 10}
    end

    it "handle fields=<field>" do
      subject.params = "q=&fields=title"
      subject.fields.should == {:fields => ["title"]}
    end

    it "handle fields=<field1>,<field2>" do
      subject.params = "q=&fields=title,summary"
      subject.fields.should == {:fields => ["title","summary"]}
    end

    it "not allow fields=<field1>,<field1>" do
      subject.params = "q=&fields=title,title"
      subject.fields.should == {:fields => ["title"]}
    end

  end

  context "Features" do

    it "try to highlight on the _all field by default" do
      subject.highlight.should == {
        :highlight => {
          :fields => {
            :_all => {
              :pre_tags => ["<em><strong>"],
              :post_tags => ["</strong></em>"],
              :fragment_size => 50,
              :number_of_fragments => 3
            }
          }
        }
      }
    end

  end

end
