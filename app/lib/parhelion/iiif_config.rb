# frozen_string_literal: true

module Parhelion
  # One place to store the cdm connection info
  class IiifConfig
    attr_reader :id, :collection, :endpoint, :rest_client_klass
    def initialize(id: :MISSING_ID,
                   collection: :MISSING_COLLECTION,
                   endpoint: ENV['PARHELION_CDM_ENDPOINT'],
                   rest_client_klass: RestClient )
      @id = id
      @collection = collection
      @endpoint = endpoint
      @rest_client_klass = rest_client_klass
    end

    def info
      @info ||= JSON.parse(rest_client_klass.get(info_url).body)
    end

    def iiif_url
      "#{endpoint}/digital/iiif/#{collection}/#{id}"
    end

    private

    def info_url
      "#{iiif_url}/info.json"
    end
  end
end
