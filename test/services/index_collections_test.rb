require 'test_helper'

  class IndexCollectionsTest < ActiveSupport::TestCase
    it 'converts an OAI ListSets response to an array of collections and indexes them' do
      set =
        {
          'setSpec' => 'foobar:123',
          'setName' => 'Foo Bar Collection',
          'setDescription' => {
            'dc' => {'description' => 'A collection about foo'}
          }
        }

      # IndexerWorker
      indexer_worker_klass = Minitest::Mock.new
      indexer_worker_klass.expect :perform_async, '', [set]

      Umedia::IndexCollections.new(sets: [set],
                                   indexer_worker: indexer_worker_klass).index!
      indexer_worker_klass.verify
    end
  end
