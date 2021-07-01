# frozen_string_literal: true

require 'test_helper'

class SearchWithChilrenTest < ActiveSupport::TestCase
  it 'runs a search and returns child page data included in search results' do
    skip 'seems to expect ids that do not change across test env builds, but it seems they do change'
    ids = SearchWithChildren.new(param_string: 'q=libraries', rows: 1)
                            .docs
                            .map { |item| item['id'] }
    _(ids).must_equal ['p16022coll416:904']
  end
end
