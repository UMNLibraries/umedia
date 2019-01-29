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

      IndexCollections.new(sets: [set],
                           indexer_worker: indexer_worker_klass).index!
      indexer_worker_klass.verify
    end

    describe 'when a single collection is specified' do
      it 'indexes just that set' do
        sets =
        [
          {
            'setSpec' => 'foobar:123',
            'setName' => 'Foo Bar Collection',
            'setDescription' => {
              'dc' => {'description' => 'A collection about foo'}
            }
          },
          {
            'setSpec' => 'stuff:123',
            'setName' => 'Foo Bar Collection',
            'setDescription' => {
              'dc' => {'description' => 'A collection about foo'}
            }
          }
        ]

        # IndexerWorker
        indexer_worker_klass = Minitest::Mock.new
        indexer_worker_klass.expect :perform_async, '', [sets.last]

        IndexCollections.new(set_spec: 'stuff:123',
                                     sets: sets,
                                     indexer_worker: indexer_worker_klass).index!
        indexer_worker_klass.verify
      end
    end
  end
