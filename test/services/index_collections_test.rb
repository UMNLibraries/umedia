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

      collection_args = {
        set_spec: 'foobar:123',
        name: 'Foo Bar Collection',
        description: 'A collection about foo'
      }

      # Collection mock
      collection_klass = Minitest::Mock.new
      collection_klass_obj = Minitest::Mock.new
      collection_klass.expect :new, collection_klass_obj, [collection_args]

      # CollectionIndexer mock
      indexer_klass = Minitest::Mock.new
      indexer_klass_obj = Minitest::Mock.new
      indexer_klass.expect :new, indexer_klass_obj, [{collections: [collection_klass_obj]}]
      indexer_klass_obj.expect :index!, nil, []



      Umedia::IndexCollections.new(sets: [set],
                                   indexer_klass: indexer_klass,
                                   collection_klass: collection_klass).index!
      indexer_klass.verify
      indexer_klass_obj.verify
      collection_klass.verify
    end
  end
