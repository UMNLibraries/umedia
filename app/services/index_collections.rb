# frozen_string_literal: true

# Convert an OAI ListSet response to Collection list and run the indexer_klass
class IndexCollections
  attr_reader :sets, :indexer_worker
  def initialize(sets: UmediaETL.new.sets,
                 indexer_worker: CollectionIndexerWorker)
    @sets = sets
    @indexer_worker = indexer_worker
  end

  def index!
    sets.map { |set| indexer_worker.perform_async(set) }
  end
end
