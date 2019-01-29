# frozen_string_literal: true

# Convert an OAI ListSet response to Collection list and run the indexer_klass
class IndexCollections
  attr_reader :sets, :set_spec, :indexer_worker
  def initialize(set_spec: false,
                 sets: UmediaETL.new.sets,
                 indexer_worker: CollectionIndexerWorker)
    @sets = sets
    @indexer_worker = indexer_worker
    @set_spec = set_spec
  end

  def index!
    index_sets.map do |set|
      indexer_worker.perform_async(set)
    end
  end

  private

  def index_sets
    if set_spec
      sets.select { |set| set['setSpec'] == set_spec }
    else
      sets
    end
  end
end
