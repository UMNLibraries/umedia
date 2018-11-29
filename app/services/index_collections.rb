# frozen_string_literal: true

# Convert an OAI ListSet response to Collection list and run the indexer_klass
class IndexCollections
  attr_reader :sets, :collection_klass, :indexer_klass
  def initialize(sets: UmediaETL.new.sets,
                 collection_klass: Umedia::Collection,
                 indexer_klass: Umedia::CollectionIndexer)
    @sets = sets
    @collection_klass = collection_klass
    @indexer_klass = indexer_klass
  end

  def index!
    indexer_klass.new(collections: collections).index!
  end

  private

  def collections
    sets.map do |set|
      collection_klass.new(
        set_spec: set['setSpec'],
        name: set['setName'],
        description: description(set)
      )
    end
  end

  def description(set)
    set
      .fetch('setDescription', {})
      .fetch('dc', {})
      .fetch('description', {})
  end
end
