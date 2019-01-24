require 'sidekiq'
# frozen_string_literal: true

# Allow each featured collection to be indexed individually
# Eliminates long-running process and also handles
# indexing errors on a per-featured collection basis
class CollectionIndexerWorker
  include Sidekiq::Worker
  attr_writer :set_klass, :indexer_klass
  def perform(set)
    indexer_klass.new(collection: collection(set)).index!
  end

  def set_klass
    @set_klass ||= Umedia::OaiSet
  end

  def indexer_klass
    @indexer_klass ||= Umedia::CollectionIndexer
  end

  private

  def collection(set)
    set_klass.new(set: set).to_collection
  end
end
