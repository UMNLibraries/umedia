require 'test_helper'

module Umedia
  class SuperCollectionsTest < ActiveSupport::TestCase
    it 'searches for a single item' do
      solr = Minitest::Mock.new
      SuperCollections.new.names.must_equal ["Exploring Minnesota's Natural History", "Revealing Bound Maps", "Minnesota's Radio History", "The Green Revolution", "African American Archival Materials", "Seoul National University", "Atlantic World"]
      SuperCollections.new.item_ids_for('Revealing Bound Maps').must_equal ["p16022coll251:1227", "p16022coll251:1245", "p16022coll251:5895"]
      SuperCollections.new.item_ids_for("Exploring Minnesota's Natural History").must_equal ["p16022coll349:8804", "p16022coll243:1386", "p16022coll174:3318"]
      SuperCollections.new.item_ids_for("Minnesota's Radio History").must_equal ["p16022coll171:1222", "p16022coll171:2119", "p16022coll171:2224"]
      SuperCollections.new.item_ids_for("The Green Revolution").must_equal ["p16022coll345:12027", "p16022coll342:46679", "p16022coll347:32763"]
      SuperCollections.new.item_ids_for("African American Archival Materials").must_equal ["p16022coll300:83", "p16022coll226:107", "p16022coll317:364"]
      SuperCollections.new.item_ids_for('foo').must_equal []
      solr.verify
    end
  end
end
