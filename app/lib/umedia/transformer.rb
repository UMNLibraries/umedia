# frozen_string_literal: true

module Umedia
  # Field transformation mappings and related code for CDMBL
  class Transformer
    class RemoveHashFormatter
      def self.format(values)
        values unless values.is_a?(Hash)
      end
    end

    class HasChildrenFormatter
      def self.format(values)
        if values['page'].respond_to?(:length)
          values['page'].length > 0 ? 1 : 0
        else
          0
        end
      end
    end

    class ViewerTypeFormatter
      def self.format(values)
        ViewerMap.new(record: values).viewer
      end
    end

    class UmediaCollectionNameFormatter
      def self.format(value)
        value['oai_sets'].fetch(value['setSpec'], {})
                         .fetch(:name, '').gsub(/^ul_([a-zA-Z0-9])*\s-\s/, '')
      end
    end

    class SplitPipeFormatter
      def self.format(values)
        values.split('|') if values.respond_to?(:split)
      end
    end

    class TakeFirstFormatter
      def self.format(values)
        values.first if values.respond_to?(:first)
      end
    end

    def self.field_mappings
      [
        {dest_path: 'id', origin_path: 'id', formatters: [CDMBL::StripFormatter, CDMBL::IDFormatter]},
        {dest_path: 'set_spec', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, CDMBL::SetSpecFormatter]},
        {dest_path: 'collection_name', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, UmediaCollectionNameFormatter]},
        {dest_path: 'collection_description', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, CDMBL::CollectionDescriptionFormatter, CDMBL::FilterBadCollections]},
        # Full Record View
        {dest_path: 'title', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'title_sort', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'title_alternative', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'description', origin_path: 'descri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'date_created', origin_path: 'date', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'historical_era', origin_path: 'histor', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'creator', origin_path: 'creato', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'creator_sort', origin_path: 'creato', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'contributor', origin_path: 'contri', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'publisher', origin_path: 'publis', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'caption', origin_path: 'captio', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'notes', origin_path: 'additi', formatters: [CDMBL::StripFormatter]},
        # Physical Description
        {dest_path: 'type', origin_path: 'type', formatters: [CDMBL::Titlieze, CDMBL::StripFormatter]},
        {dest_path: 'format', origin_path: 'format', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'format_facet', origin_path: 'format', formatters: [SplitPipeFormatter, TakeFirstFormatter, CDMBL::StripFormatter]},
        {dest_path: 'dimensions', origin_path: 'dimens', formatters: [CDMBL::StripFormatter]},
        # Topics
        {dest_path: 'subject', origin_path: 'subjec', formatters: [CDMBL::Titlieze, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'subject_fast', origin_path: 'fast', formatters: [CDMBL::Titlieze, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'language', origin_path: 'langua', formatters: [CDMBL::StripFormatter]},
        # Geographic Details
        {dest_path: 'city', origin_path: 'city', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'state', origin_path: 'state', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'country', origin_path: 'countr', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'region', origin_path: 'region', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'continent', origin_path: 'contin', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'geonames', origin_path: 'geonam', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'projection', origin_path: 'projec', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'scale', origin_path: 'scale', formatters: [CDMBL::StripFormatter]},
        # Collection Information
        {dest_path: 'parent_collection', origin_path: 'a', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contributing_organization', origin_path: 'contra', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contact_information', origin_path: 'contac', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'fiscal_sponsor', origin_path: 'fiscal', formatters: [CDMBL::StripFormatter]},
        # Identifiers
        {dest_path: 'local_identifier', origin_path: 'identi', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'barcode', origin_path: 'barcod', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'system_identifier', origin_path: 'system', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'dls_identifier', origin_path: 'dls', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'persistent_url', origin_path: 'persis', formatters: [CDMBL::StripFormatter]},
        # Rights
        {dest_path: 'local_rights', origin_path: 'local', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'standardized_rights', origin_path: 'standa', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'rights_statement_uri', origin_path: 'righta', formatters: [CDMBL::StripFormatter]},
        # Transcript
        {dest_path: 'transcription', origin_path: 'transc', formatters: [RemoveHashFormatter, CDMBL::StripFormatter]},
        {dest_path: 'translation', origin_path: 'transl', formatters: [CDMBL::StripFormatter]},
        # NON-DISPLAY FIELDS (not directly displayed)
        {dest_path: 'kaltura_audio', origin_path: 'kaltur', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'kaltura_audio_playlist', origin_path: 'kaltua', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'kaltura_video', origin_path: 'kaltub', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'kaltura_video_playlist', origin_path: 'kaltuc', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'kaltura_combo_playlist', origin_path: 'kaltud', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'compound_objects', origin_path: 'page', formatters: [CDMBL::ToJsonFormatter]},
        {dest_path: 'has_children', origin_path: '/', formatters: [HasChildrenFormatter]},
        {dest_path: 'record_type', origin_path: 'record_type', formatters: []},
        {dest_path: 'parent_id', origin_path: 'parent_id', formatters: []},
        {dest_path: 'viewer_type', origin_path: '/', formatters: [ViewerTypeFormatter]}
      ]
    end
  end
end