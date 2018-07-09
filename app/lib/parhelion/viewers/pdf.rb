module Parhelion
  module Viewers
    class PDF
      attr_reader :document, :uri
      def initialize(document: Parhelion::Document.new,
                     uri: 'https://cdm16022.contentdm.oclc.org')
        @document = document
        @uri = uri
      end

      def partial_name
        'pdf'
      end

      def title
        document.field_title.value
      end

      def src
        if is_primary?
          "#{uri}/utils/getfile/collection/#{collection}/id/#{id}/filename"
        else
          "#{uri}/utils/getfile/collection/#{collection}/id/#{parent_id}/filename/#{id}"
        end
      end

      def is_primary?
        document.field_record_type.value == 'primary'
      end

      private

      def id
        doc_ids.last
      end

      def parent_id
        document.field_parent_id.value
      end

      def collection
        doc_ids.first
      end

      def doc_ids
        document.id.split(':')
      end
    end
  end
end
