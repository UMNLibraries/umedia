require 'test_helper'

  class OaiSetTest < ActiveSupport::TestCase
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
      oai_set = Umedia::OaiSet.new(set: set,
                                   collection_klass: collection_klass).to_collection
      collection_klass.verify
    end
  end
