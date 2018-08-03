module Parhelion
  module Viewers
    class PDF
      extend Forwardable
      def_delegators :@item, :[], :id, :parent_id, :collection

      attr_reader :item, :uri
      def initialize(item: Parhelion::Item.new,
                     uri: 'https://cdm16022.contentdm.oclc.org')
        @item = item
        @uri = uri
      end

      def partial_name
        'pdf'
      end

      def title
        item.field_title.value
      end

      def src
        if is_primary?
          "#{uri}/utils/getfile/collection/#{collection}/id/#{id}/filename"
        else
          "#{uri}/utils/getfile/collection/#{collection}/id/#{parent_id}/filename/#{id}"
        end
      end

      def is_primary?
        item.field_record_type.value == 'primary'
      end
    end
  end
end
