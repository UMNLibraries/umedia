# frozen_string_literal: true

module Parhelion
  # One place to store the cdm connection info
  class CdmapiImageInfo
    attr_reader :id, :collection, :endpoint, :rest_client_klass
    def initialize(id: :MISSING_ID,
                   collection: :MISSING_COLLECTION,
                   endpoint: ENV['PARHELION_CDM_WEBSERVICES_ENDPOINT'],
                   rest_client_klass: RestClient )
      @id = id
      @collection = collection
      @endpoint = endpoint
      @rest_client_klass = rest_client_klass
    end

    def info
      @info ||= JSON.parse(rest_client_klass.get(info_url).body)
    rescue StandardError => e
      raise "Webservices Error for #{info_url}: #{e}"
    end

    def info_url
      "#{endpoint}?q=dmGetImageInfo/#{collection}/#{id}/json"
    end
  end
end
