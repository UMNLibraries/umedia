require 'test_helper'

module Umedia
  class MltSearchTest < ActiveSupport::TestCase
    it 'finds related documents' do
      MltSearch.new(id: 'p16022coll202:3').items.first.index_id.must_equal 'p16022coll198:27'
    end
  end
end
