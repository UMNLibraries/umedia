require 'sidekiq'

module Umedia
  class CacheThumbnailsWorker
    include Sidekiq::Worker

    attr_reader :docs
    def perform(docs)
      @docs = docs
      check_and_upload
    end

    def check_and_upload
      thumbs.map do |thumb|
        if !valid?(thumb.cdn_url)
          Thumbnailer.new(doc_hash: thumb.hash, thumb_url: thumb.url).upload!
        end
      end
    end

    def thumbs
      @thumbs ||=
        docs.map do |doc|
          Umedia::Thumbnail.new(object_url: doc['object'],
                                viewer_type: doc['viewer_type'],
                                entry_id: doc['kaltura_video'])
        end
    end


    def valid?(cdn_url)
      Net::HTTP.get_response(URI(cdn_url)).code == 200
    end

    def upload!(thumb)
      Thumbnailer.new(doc_hash: thumb.hash,
                      thumb_url: thumb.url).upload!
    end
  end
end