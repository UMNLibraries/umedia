module Parhelion
  module Viewers
    class PDF
      extend Forwardable
      def_delegators :@item, :[], :id, :collection

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
        "#{uri}/utils/getfile/collection/#{collection}/id/#{id}"
      end
    end
  end
end
