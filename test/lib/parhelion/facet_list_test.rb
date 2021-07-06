require 'test_helper'
module Parhelion
  class FacetListTest < ActiveSupport::TestCase
    it 'takes an rsolr facet result hash and turns it into a list of facet object' do
      facet_hash = {
        'publisher' => ['UMN', 222, 'Somebody', 295]
      }
      facet_list = FacetList.new(facet_hash: facet_hash)
      facet_list.map { |fl| _(fl).must_equal(
        Facet.new(rows: facet_hash['publisher'], name: 'publisher')
      )
      }
    end
  end
end
