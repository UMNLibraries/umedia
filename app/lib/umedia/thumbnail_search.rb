# frozen_string_literal: true

module Umedia
  # Bootstrap thumbnail cache
  class ThumbnailSearch
    attr_reader :page, :client, :thumb_klass
    def initialize(page: 1,
                   client: SolrClient)
      @page        = page
      @client      = client
      @thumb_klass = thumb_klass
    end

    def stop?
      response['numFound'] < 100
    end

    def docs
      response['docs']
    end

    private

    def response
      @response ||=
        (client.new.solr.get 'select',
          params: {
            q: '*:*',
            fl: 'id, object, viewer_type, kaltura_video'
          }
        )['response']
    end
  end
end