# frozen_string_literal: true

require 'test_helper'

module Umedia
  class MltSearchTest < ActiveSupport::TestCase
    it 'finds related documents' do
      _(MltSearch.new(id: 'p16022coll416:904').items.first.index_id).must_equal 'p16022coll358:6032'
    end
  end
end
