# frozen_string_literal: true

module Umedia
  # Field transformation mappings and related code for CDMBL
  class Transformer
    class RemoveHashFormatter
      def self.format(values)
        values unless values.is_a?(Hash)
      end
    end

    class PageCountFormatter
      def self.format(values)
        if values['page'].respond_to?(:length)
          values['page'].length
        else
          1
        end
      end
    end

    class FirstViewerTypeFormatter
      def self.format(value)
        pages = value.fetch('page', [])
        if !pages.empty?
          ViewerMap.new(record: pages.first).viewer
        else
          ViewerMap.new(record: value).viewer
        end
      end
    end

    class ViewerTypeFormatter
      def self.format(value)
        ViewerMap.new(record: value).viewer
      end
    end

    class UmediaCollectionNameFormatter
      def self.format(value)
        value['oai_sets'].fetch(value['setSpec'], {})
                         .fetch(:name, '')
                         .gsub(/^ul_([a-zA-Z0-9])*\s-\s/, '')
      end
    end

    class SuperCollectionNamesFormatter
      def self.format(value)
        names = value.fetch('projea', '')
        if names.respond_to?(:split)
          names.split(';').map do |set_spec|
            value['oai_sets'].fetch(set_spec, {})
              .fetch(:name, '')
              .gsub(/^ul_([a-zA-Z0-9])*\s-\s/, '')
          end
        end
      end
    end

    class SuperCollectionDescriptionsFormatter
      def self.format(value)
        names = value.fetch('projea', '')
        if names.respond_to?(:split)
          names.split(';').map do |set_spec|
            value['oai_sets'].fetch(set_spec, {})
            .fetch(:description, '')
          end
        end
      end
    end

    class FormatNameFormatter
      def self.format(value)
        value.split(';').map { |val| val.split('|').first }
      end
    end

    class SemiSplitFirstFormatter
      def self.format(value)
        value.split(';').first
      end
    end

    class ObjectFormatter
      def self.format(value)
        collection, id = value.split('/')
        "https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/#{collection}/id/#{id}"
      end
    end

    class AttachmentFormatter
      def self.format(record)
        Umedia::EtlFormatters::Attachment.new(record: record).format
      end
    end

    class DocumentFormatter
      def self.format(id)
        'item'
      end
    end

    class FeaturedCollectionOrderFormatter
      def self.format(doc)
        order = doc.fetch('featur', false)
        !order.blank? ? order : 3
      end
    end

    class LetterSortFormatter
      def self.format(value)
        value.gsub(/([^a-z]*)/i, '').downcase
      end
    end

    class NumberSortFormatter
      def self.format(val)
        # Ah, library metadata; strip off the fake ranges
        val = val.gsub(/^- /, '')
        val = val.split('-').first.gsub(/([^0-9|\s]*)/i, '')
      end
    end

    def self.field_mappings
      [
        {dest_path: 'id', origin_path: 'id', formatters: [CDMBL::StripFormatter, CDMBL::IDFormatter]},
        {dest_path: 'object', origin_path: 'id', formatters: [ObjectFormatter]},
        {dest_path: 'set_spec', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, CDMBL::SetSpecFormatter]},
        {dest_path: 'collection_name', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, UmediaCollectionNameFormatter]},
        {dest_path: 'collection_description', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, CDMBL::CollectionDescriptionFormatter, CDMBL::FilterBadCollections]},
        {dest_path: 'super_collection_names', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, SuperCollectionNamesFormatter]},
        {dest_path: 'super_collection_set_specs', origin_path: 'projea', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'super_collection_descriptions', origin_path: '/', formatters: [CDMBL::AddSetSpecFormatter, SuperCollectionDescriptionsFormatter]},
      # Full Record View
        {dest_path: 'title', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'title_sort', origin_path: 'title', formatters: [CDMBL::StripFormatter, LetterSortFormatter]},
        {dest_path: 'title_alternative', origin_path: 'title', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'description', origin_path: 'descri', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'date_created', origin_path: 'date', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'date_created_sort', origin_path: 'date', formatters: [CDMBL::StripFormatter, NumberSortFormatter]},
        {dest_path: 'historical_era', origin_path: 'histor', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'creator', origin_path: 'creato', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'creator_sort', origin_path: 'creato', formatters: [CDMBL::StripFormatter, CDMBL::JoinFormatter, LetterSortFormatter]},
        {dest_path: 'contributor', origin_path: 'contri', formatters: [CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'publisher', origin_path: 'publis', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'caption', origin_path: 'captio', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'notes', origin_path: 'additi', formatters: [CDMBL::StripFormatter]},
      # Physical Description
        {dest_path: 'types', origin_path: 'type', formatters: [CDMBL::StripFormatter, CDMBL::Titlieze, CDMBL::SplitFormatter, CDMBL::UniqueFormatter]},
        {dest_path: 'format', origin_path: 'format', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'format_name', origin_path: 'format', formatters: [FormatNameFormatter]},
        {dest_path: 'dimensions', origin_path: 'dimens', formatters: [CDMBL::StripFormatter]},
      # Topics
        {dest_path: 'subject', origin_path: 'subjec', formatters: [CDMBL::Titlieze, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'subject_fast', origin_path: 'fast', formatters: [CDMBL::Titlieze, CDMBL::SplitFormatter, CDMBL::StripFormatter]},
        {dest_path: 'language', origin_path: 'langua', formatters: [CDMBL::StripFormatter,CDMBL::SplitFormatter, CDMBL::StripFormatter]},
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
        {dest_path: 'parent_collection_name', origin_path: 'a', formatters: [SemiSplitFirstFormatter]},
        {dest_path: 'contributing_organization', origin_path: 'contra', formatters: [CDMBL::StripFormatter]},
        {dest_path: 'contributing_organization_name', origin_path: 'contra', formatters: [SemiSplitFirstFormatter]},
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
        {dest_path: 'page_count', origin_path: '/', formatters: [PageCountFormatter]},
        {dest_path: 'record_type', origin_path: 'record_type', formatters: []},
        {dest_path: 'parent_id', origin_path: 'parent_id', formatters: [CDMBL::StripFormatter, CDMBL::IDFormatter]},
        {dest_path: 'first_viewer_type', origin_path: '/', formatters: [FirstViewerTypeFormatter]},
        {dest_path: 'viewer_type', origin_path: '/', formatters: [ViewerTypeFormatter]},
        # child_index is provided by CDMBL; children are assigned the order in
        # which they were received from the CDM API
        {dest_path: 'child_index', origin_path: 'child_index', formatters: []},
        # Attachments can appear below kaltura items or complex objects that
        # have an attachment specified in the parent item. Attachments offer
        # complimentary content for the featured item. A video about a paiting
        # might have a iiif image attachment that shows the paintg, for example
        {dest_path: 'attachment', origin_path: 'find', formatters: []},
        # Attachment format is a "viewer" format (iiif, pdf, etc). If this
        # field is missing, the UI code will not display an attachment
        {dest_path: 'attachment_format', origin_path: '/', formatters: [AttachmentFormatter]},
        # We have both collection and item data in the index
        {dest_path: 'document_type', origin_path: 'id', formatters: [DocumentFormatter]},
        # Used in /collections displays to select which thumbs should display and
        # in which order - 1, 2, or 3. The default value is last: 3.
        {dest_path: 'featured_collection_order', origin_path: '/', formatters: [FeaturedCollectionOrderFormatter]}
      ]
    end
  end
end