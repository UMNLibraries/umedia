# frozen_string_literal: true

module Umedia
  # Bootstrap thumbnail cache
  class ThumbnailSearch
    attr_reader :q, :page, :rows, :client, :thumb_klass
    def initialize(q: 'record_type:secondary',
                   page: 1,
                   rows: 100,
                   client: SolrClient)
      @q           = q
      @page        = page
      @rows        = rows
      @client      = client
      @thumb_klass = thumb_klass
    end

    def stop?
      (response['numFound'] - (page * rows)) < 0
    end

    def docs
      response['docs']
    end

    private

    def response
      @response ||=
        (client.new.solr.paginate page, rows, 'select',
          params: {
            q: q,
            fl: 'id, object, first_viewer_type, kaltura_video'
          }
        )['response']
    end
  end
end