require 'test_helper'
module Umedia
  class SortListTest < ActiveSupport::TestCase
    it 'creates a list of sort configurations' do
      query = Parhelion::Query.new
      sort_query_klass = Minitest::Mock.new
      sort_query_klass.expect :new, nil, [{value:"score desc, title_s desc", query: query}]
      sort_query_klass.expect :new, nil, [{value:"title_s asc, date_created_sort desc", query: query}]
      sort_query_klass.expect :new, nil, [{value:"title_s desc, date_created_sort desc", query: query}]
      sort_query_klass.expect :new, nil, [{value:"creator_sort asc, title_s asc", query: query}]
      sort_query_klass.expect :new, nil, [{value:"creator_sort desc, title_s asc", query: query}]
      sort_query_klass.expect :new, nil, [{value:"date_created_sort asc, title_s asc", query: query}]
      sort_query_klass.expect :new, nil, [{value:"date_created_sort desc, title_s asc", query: query}]
      labels = SortList.new(sort_query_klass: sort_query_klass,
                            query: query ).map { |sort| sort[:label] }
      labels.must_equal ["Relevance", "Title: A to Z", "Title: Z to A", "Creator: A to Z", "Creator: Z to A", "Date: Oldest First", "Date: Newest First"]
      sort_query_klass.verify
    end
  end
end