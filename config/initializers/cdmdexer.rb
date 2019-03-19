module CDMDEXER
  class CompletedCallback
    def self.call!(config)
      SolrClient.new.commit
      Rails.logger.info "Completed Ingest for Collection: #{config['set_spec']}"
      # Commit Changes
      # Enrich parent item with children transcripts
      ::TranscriptsIndexerWorker.perform_async(1, config['set_spec'])
    end
  end

  class OaiNotification
    def self.call!(location)
      Rails.logger.info "CDMDEXER: Requesting: #{location}"
    end
  end

  class CdmNotification
    def self.call!(collection, id, endpoint)
      Rails.logger.info "CDMDEXER: Requesting: #{collection}:#{id} from #{endpoint}"
    end
  end

  # An example callback
  class LoaderNotification
    def self.call!(ingestables, deletables)
      Rails.logger.info "CDMDEXER: Loading #{ingestables.length} records and deleting #{deletables.length}"
    end
  end
end