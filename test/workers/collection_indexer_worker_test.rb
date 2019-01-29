require 'test_helper'

  class CollectionIndexerWorkerTest < ActiveSupport::TestCase
    it 'converts an OAI ListSets response to an array of collections and indexes them' do
      set =
        {
          'setSpec' => 'foobar:123',
          'setName' => 'Foo Bar Collection',
          'setDescription' => {
            'dc' => {'description' => 'A collection about foo'}
          }
        }
      # Set Klass Mock
      set_klass = Minitest::Mock.new
      set_klass_obj = Minitest::Mock.new
      set_klass.expect :new, set_klass_obj, [{set: set}]
      set_klass_obj.expect :to_collection, 'collection here', []

      # Indexer Mock
      indexer_klass = Minitest::Mock.new
      indexer_klass_obj = Minitest::Mock.new
      indexer_klass.expect :new, indexer_klass_obj, [{:collection=>"collection here"}]
      indexer_klass_obj.expect :index!, false, []

      worker = CollectionIndexerWorker.new
      worker.set_klass = set_klass
      worker.indexer_klass = indexer_klass
      worker.perform(set)
      set_klass.verify
      indexer_klass.verify
    end
  end
