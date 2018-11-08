# frozen_string_literal: true
require_dependency "#{Rails.root}/app/lib/umedia/citation/formatters"

module Umedia
  module Citation
    module Styles
      class MLAURLFormatter
        def self.format(value)
          "umedia.lib.umn.edu/item/#{value}"
        end
      end

      class MLADateFormatter
        def self.format(value)
          Time.now.strftime('%d %b %Y')
        end
      end

      class MLA
        def self.mappings
          [
            { name: 'creator', prefix: '', suffix: '.', formatters: [Umedia::Citation::CommaJoinFormatter]},
            { name: 'title', prefix: ' ', suffix: '.', formatters: [ItalicizeFormatter]},
            { name: 'date_created', prefix: ' ', suffix: '.', formatters: [CommaJoinFormatter]},
            { name: 'contributing_organization', prefix: ' ', suffix: ', ', formatters: [] },
            { name: 'id', prefix: '', suffix: '', formatters: [MLAURLFormatter] },
            { name: 'id', prefix: ' Accessed ', suffix: '.', formatters: [MLADateFormatter] }
          ]
        end
      end
    end
  end
end