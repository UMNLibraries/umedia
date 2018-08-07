require 'test_helper'

module Umedia
  class ChildHighlightsTest < ActiveSupport::TestCase
    it 'runs two searches: one child search with a query and one without' do
      parent_id = 9942
      q = ''
      child_search_klass = Minitest::Mock.new
      child_search_obj = Minitest::Mock.new
      child_search_klass.expect :new, child_search_obj, [{:parent_id=>9942}]
      child_search_obj.expect :items, [{foo: 'bar'}], []

      child_search_klass.expect :new, child_search_obj, [{:q=>"", :parent_id=>9942}]
      child_search_obj.expect :highlighting, [{highlight: 'bar'}], []
      search = ChildHighlights.new(q: '', parent_id: parent_id, child_search_klass: child_search_klass)
      search.items
      search.highlighting
      child_search_klass.verify
    end
  end
end
