# frozen_string_literal: true
require_dependency "#{Rails.root}/app/lib/umedia/citation/formatters"

module Umedia
  module Citation
    module Styles
      class Wikipedia
        class WikiDateFormatter
          def self.format(value)
            Time.now.strftime('%d %b %Y')
          end
        end
        def self.mappings
          [
            {name: 'id', value: '<ref name="University of Minnesota"> {{', formatters: [] },
            {name: 'id', prefix: 'cite web | url=', suffix: ' |', formatters: [ItemUrlFormatter] },
            {name: 'types', prefix: ' | title= (', suffix: ') ', formatters: [CommaJoinFormatter] },
            {name: 'title', prefix: ' ', suffix: ',', formatters: [] },
            {name: 'creation_date', prefix: '(', suffix: ')', formatters: [] },
            {name: 'creator', prefix: ' | author=', suffix: '', formatters: [CommaJoinFormatter] },
            {name: 'id', prefix: ' | accessdate=', suffix: '', formatters: [WikiDateFormatter] },
            {name: 'contributing_organization', prefix: ' | publisher=', suffix: '}} </ref>', formatters: [] }
          ]
        end
      end
    end
  end
end