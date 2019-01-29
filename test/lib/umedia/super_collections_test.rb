require 'test_helper'

module Umedia
  class SuperCollectionsTest < ActiveSupport::TestCase
    it 'searches for a single item' do
      SuperCollections.new.names.must_equal ["Exploring Minnesota's Natural History", "Revealing Bound Maps", "Minnesota's Radio History", "The Green Revolution", "African American Archival Materials"]
      SuperCollections.new.item_ids_for('Revealing Bound Maps').must_equal [["p16022coll251:844", "p16022coll251:670", "p16022coll243:22"]]
      SuperCollections.new.item_ids_for('foo').must_equal []
      solr.verify
    end
  end
end
