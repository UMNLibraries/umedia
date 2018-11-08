module Umedia
  module Citation
    class ItemUrlFormatter
      def self.format(id)
        "http://umedia.lib.umn.edu/item/#{id}"
      end
    end

    class CommaJoinFormatter
      def self.format(value)
        if value.respond_to?(:join)
          value.join(', ')
        else
          value
        end
      end
    end

    class ItalicizeFormatter
      def self.format(value)
        "<i>#{value}</i>"
      end
    end

    class URLFormatter
      def self.format(value)
        "https://umedia.lib.umn.edu/item/#{value}"
      end
    end

    class ExtractFormats
      def self.format(value)
        value.map { |format| format.split('|').first}.join(',')
      end
    end
  end
end