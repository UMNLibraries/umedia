module Umedia
  module Citation
    class CommaJoinFormatter
      def self.format(value)
        if respond_to?(:join)
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