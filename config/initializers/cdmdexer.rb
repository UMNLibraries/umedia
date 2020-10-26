module CDMDEXER
  class CompletedCallback
    def self.call!(config)
      ::SolrClient.new.commit
      Rails.logger.info "Processing last batch for: #{config['set_spec']}"
    end
  end

  class OaiNotification
    def self.call!(location)
      Rails.logger.info "CDMDEXER: Requesting: #{location}"
    end
  end

  class CdmNotification
    def self.call!(collection, id, endpoint)
      Rails.logger.info "CDMDEXER: Requesting: #{collection}:#{id}"
      clear_item_cache("#{collection}:#{id}")
    end

    def self.clear_item_cache(id)
      item_cache = "item/#{id}"
      Rails.logger.info "CDMDEXER: Clearing Item Cache: #{item_cache}"
      Rails.cache.delete(item_cache)
    end
  end

  class LoaderNotification
    def self.call!(ingestables, deletables)
      Rails.logger.info "CDMDEXER: Loading #{ingestables.length} records and deleting #{deletables.length}"
    end
  end

  class CdmError
    def self.call!(error)
      message = "CDMDEXER Error: #{error}"
      Rails.logger.info message
      NotifySlack.new(message: "CDM Error on Host #{ENV['HOSTNAME']}/sidekiq \n ```#{message}```").post
    end
  end
end