require 'open-uri'

module Cardy

  class Import
    attr_reader :url, :page

    def self.import_all!
      (0..56).map { |page| self.new(page: page).import!}
    end

    def self.import_sample!
      [0,10,15,20,35,40,55].map { |page| self.new(page: page).import!}
    end

    def initialize(url: 'https://databaser.lib.umn.edu/api/ocr', page: 20)
      @url = url
      @page = page
    end

    def import!
      response['nodes'].map { |card| create_card(card['node'].symbolize_keys) }
    end

    def create_card(params)
      filename = params[:file_name].gsub(/tif/, 'jpg')
      card = Card.new(ocr: sanitize_ocr_text(params[:ocr_text]),
                      file_name: filename,
                      year_range: params[:year_range],
                      publisher: params[:publisher])

      card.image.attach(io: image_buffer(filename),
                        filename: filename,
                        content_type: "image/jpg")
      card.save
    end

    def image_buffer(file_name)
      puts "Fetching Image at: #{image_base_url}/#{file_name}"
      open("#{image_base_url}/#{file_name}",
           {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE})
    end

    def sanitize_ocr_text(value)
      value.gsub(/([-+!\(\)\{\}\[\]^"~*?:\\]|&&|\|)/) { |e| " " }
           .tr("\u0000-\u001f\u007f\u2028",'')
           .gsub(/\{2,}|~/, '')
           .gsub(/\s{2,}/, ' ')
    end

    def image_base_url
      "https://databaser.lib.umn.edu/sites/default/files/images/"
    end

    def next_page
      page + 1
    end

    def response
      @response ||= JSON.parse(api_request)
    end

    def api_request
      get api_uri
    end

    def api_uri
      @uri ||= URI.parse("#{url}?page=#{page}")
    end

    def get(uri)
      puts "Fetching API at: #{uri}"
      open(uri, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}) do |data|
        data.read
      end
    end
  end
end