module Umedia
  class ViewerMap
    attr_reader :record
    def initialize(record: {})
      @record = record
    end

    def viewer
      if kaltura_mapping
        kaltura_mapping
      else
        format_mapping
      end
    end

    private

    def kaltura_mapping
      @kaltura ||= kaltura_mappings.map do |mapping|
        mapping[:viewer] if record.fetch(mapping[:field], {}) != {}
      end.compact.first
    end

    def format_mapping
      case format
      when 'jp2'
        'image'
      when 'pdf'
        'pdf'
      when 'cpd'
        'NO_VIEWER'
      else
        raise "Unknown viewer format: #{format}"
      end
    end

    def format
      record.fetch('find', '').split('.').last
    end

    def mappings
      [
        { 'jp2' => 'image' },
        { 'pdf' => 'pdf' }
      ]
    end

    def kaltura_mappings
      [
        { field: 'kaltur', viewer: 'kaltura_audio' },
        { field: 'kaltura', viewer: 'kaltura_audio_playlist' },
        { field: 'kalturb', viewer: 'kaltura_video' },
        { field: 'kalturc', viewer: 'kaltura_video_playlist' },
        { field: 'kalturd', viewer: 'kaltura_combo_playlist' }
      ]
    end
  end
end