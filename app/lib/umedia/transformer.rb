# frozen_string_literal: true

module Umedia
  # Field transformation mappings and related code for CDMDEXER
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
      def self.format(record)
        first_page = record['first_page']
        if first_page
          ViewerMap.new(record: first_page).viewer
        else
          ViewerMap.new(record: record).viewer
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
        collection, id = value.split(':')
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
        !order.blank? ? order : 999
      end
    end

    class LetterSortFormatter
      def self.format(value)
        value.gsub(/([^a-z|0-9]*)/i, '').downcase
      end
    end

    class NumberSortFormatter
      def self.format(val)
        # Ah, library metadata; strip off the fake ranges
        val = val.gsub(/^- /, '')
        val = val.split('-').first.gsub(/([^0-9|\s]*)/i, '')
      end
    end

    class SubjectFormatter
      def self.format(subjects)
        # Try to rip out periods from non-names
        # e.g.
        # African Americans. -> African Americans
        # Newton, W. H. -> Newton, W. H.
        # Only mace if we have more than one letter prior to a trailing period
        subjects.map do |subject|
          if subject =~ /[a-z]{2,}\.$/i
            subject.gsub(/\./,'')
          else
            subject
          end
        end
      end
    end

    class ToSolrDateFormatter
      def self.format(date)
        "#{date}T00:00:00Z"
      end
    end

    def self.field_mappings
      [
        {dest_path: 'id', origin_path: 'id', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'object', origin_path: 'id', formatters: [ObjectFormatter]},
        {dest_path: 'set_spec', origin_path: '/', formatters: [CDMDEXER::AddSetSpecFormatter, CDMDEXER::SetSpecFormatter]},
        {dest_path: 'collection_name', origin_path: '/', formatters: [CDMDEXER::AddSetSpecFormatter, UmediaCollectionNameFormatter]},
        {dest_path: 'collection_description', origin_path: '/', formatters: [CDMDEXER::AddSetSpecFormatter, CDMDEXER::CollectionDescriptionFormatter, CDMDEXER::FilterBadCollections]},
        {dest_path: 'super_collection_names', origin_path: '/', formatters: [CDMDEXER::AddSetSpecFormatter, SuperCollectionNamesFormatter]},
        {dest_path: 'super_collection_set_specs', origin_path: 'projea', formatters: [CDMDEXER::SplitFormatter, CDMDEXER::StripFormatter]},
        {dest_path: 'super_collection_descriptions', origin_path: '/', formatters: [CDMDEXER::AddSetSpecFormatter, SuperCollectionDescriptionsFormatter]},
      # Full Record View
        {dest_path: 'title', origin_path: 'title', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'title_search', origin_path: 'title', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'title_sort', origin_path: 'title', formatters: [CDMDEXER::StripFormatter, LetterSortFormatter]},
        {dest_path: 'title_alternative', origin_path: 'altern', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'description', origin_path: 'descri', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'date_created', origin_path: 'date', formatters: [CDMDEXER::SplitFormatter, CDMDEXER::StripFormatter]},
        {dest_path: 'date_created_sort', origin_path: 'date', formatters: [CDMDEXER::StripFormatter, NumberSortFormatter]},
        {dest_path: 'historical_era', origin_path: 'histor', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'creator', origin_path: 'creato', formatters: [CDMDEXER::SplitFormatter, CDMDEXER::StripFormatter]},
        {dest_path: 'creator_sort', origin_path: 'creato', formatters: [CDMDEXER::StripFormatter, CDMDEXER::JoinFormatter, LetterSortFormatter]},
        {dest_path: 'contributor', origin_path: 'contri', formatters: [CDMDEXER::SplitFormatter, CDMDEXER::StripFormatter]},
        {dest_path: 'publisher', origin_path: 'publis', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'caption', origin_path: 'captio', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'notes', origin_path: 'additi', formatters: [CDMDEXER::StripFormatter]},
      # Physical Description
        {dest_path: 'types', origin_path: 'type', formatters: [CDMDEXER::StripFormatter, CDMDEXER::Titlieze, CDMDEXER::SplitFormatter, CDMDEXER::UniqueFormatter]},
        {dest_path: 'format', origin_path: 'format', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'format_name', origin_path: 'format', formatters: [FormatNameFormatter,CDMDEXER::StripFormatter]},
        {dest_path: 'dimensions', origin_path: 'dimens', formatters: [CDMDEXER::StripFormatter]},
      # Topics
        {dest_path: 'subject', origin_path: 'subjec', formatters: [CDMDEXER::Titlieze, CDMDEXER::SplitFormatter, SubjectFormatter, CDMDEXER::StripFormatter]},
        {dest_path: 'subject_fast', origin_path: 'fast', formatters: [CDMDEXER::Titlieze, CDMDEXER::SplitFormatter, SubjectFormatter, CDMDEXER::StripFormatter]},
        {dest_path: 'language', origin_path: 'langua', formatters: [CDMDEXER::StripFormatter,CDMDEXER::SplitFormatter, CDMDEXER::StripFormatter]},
      # Geographic Details
        {dest_path: 'city', origin_path: 'city', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'state', origin_path: 'state', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'country', origin_path: 'countr', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'region', origin_path: 'region', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'continent', origin_path: 'contin', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'geonames', origin_path: 'geonam', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'projection', origin_path: 'projec', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'scale', origin_path: 'scale', formatters: [CDMDEXER::StripFormatter]},
      # Collection Information
        {dest_path: 'parent_collection', origin_path: 'a', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'parent_collection_name', origin_path: 'a', formatters: [SemiSplitFirstFormatter]},
        {dest_path: 'contributing_organization', origin_path: 'contra', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'contributing_organization_name', origin_path: 'contra', formatters: [SemiSplitFirstFormatter]},
        {dest_path: 'contact_information', origin_path: 'contac', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'fiscal_sponsor', origin_path: 'fiscal', formatters: [CDMDEXER::StripFormatter]},
      # Identifiers
        {dest_path: 'local_identifier', origin_path: 'identi', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'barcode', origin_path: 'barcod', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'system_identifier', origin_path: 'system', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'dls_identifier', origin_path: 'dls', formatters: [CDMDEXER::SplitFormatter, CDMDEXER::StripFormatter]},
        {dest_path: 'persistent_url', origin_path: 'persis', formatters: [CDMDEXER::StripFormatter]},
      # Rights
        {dest_path: 'local_rights', origin_path: 'local', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'standardized_rights', origin_path: 'standa', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'rights_statement_uri', origin_path: 'righta', formatters: [CDMDEXER::StripFormatter]},
      # Transcript
        {dest_path: 'transcription', origin_path: 'transc', formatters: [RemoveHashFormatter, CDMDEXER::StripFormatter]},
        {dest_path: 'translation', origin_path: 'transl', formatters: [CDMDEXER::StripFormatter]},
      # NON-DISPLAY FIELDS (not directly displayed)
        {dest_path: 'kaltura_audio', origin_path: 'kaltur', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'kaltura_audio_playlist', origin_path: 'kaltua', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'kaltura_video', origin_path: 'kaltub', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'kaltura_video_playlist', origin_path: 'kaltuc', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'kaltura_combo_playlist', origin_path: 'kaltud', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'page_count', origin_path: '/', formatters: [PageCountFormatter]},
        {dest_path: 'record_type', origin_path: 'record_type', formatters: []},
        {dest_path: 'parent_id', origin_path: 'parent_id', formatters: [CDMDEXER::StripFormatter]},
        {dest_path: 'first_viewer_type', origin_path: '/', formatters: [FirstViewerTypeFormatter]},
        {dest_path: 'viewer_type', origin_path: '/', formatters: [ViewerTypeFormatter]},
        # child_index is provided by CDMDEXER; children are assigned the order in
        # which they were received from the CDM API
        {dest_path: 'child_index', origin_path: 'child_index', formatters: []},
        # Attachments can appear below kaltura items or complex objects that
        # have an attachment specified in the parent item. Attachments offer
        # complimentary content for the featured item. A video about a paiting
        # might have a iiif image attachment that shows the painting, for example
        {dest_path: 'attachment', origin_path: 'find', formatters: []},
        # Attachment format is a "viewer" format (iiif, pdf, etc). If this
        # field is missing, the UI code will not display an attachment
        {dest_path: 'attachment_format', origin_path: '/', formatters: [AttachmentFormatter]},
        # We have both collection and item data in the index
        {dest_path: 'document_type', origin_path: 'id', formatters: [DocumentFormatter]},
        # Used in /collections displays to select which thumbs should display and
        # in which order - 1, 2, or 3. The default value is last: 3.
        {dest_path: 'featured_collection_order', origin_path: '/', formatters: [FeaturedCollectionOrderFormatter]},
        # Date added to CONTENTdm - useful to sort by recency
        {dest_path: 'date_added', origin_path: 'dmcreated', formatters: [ToSolrDateFormatter]},
        {dest_path: 'date_added_sort', origin_path: 'dmcreated', formatters: [ToSolrDateFormatter]}
      ]
    end
  end
end