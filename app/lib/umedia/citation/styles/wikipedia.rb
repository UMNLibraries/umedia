# frozen_string_literal: true
require_dependency "#{Rails.root}/app/lib/umedia/citation/formatters"

module Umedia
  module Citation
    module Styles
      class Wikipedia
        def self.mappings
          [
            {name: 'id', value: '<ref name="University of Minnesota"> {{', formatters: [] },
            {name: 'url', prefix: 'cite web | url=', suffix: '', formatters: [] },
            {name: 'type', prefix: ' | title= (', suffix: ') ', formatters: [] },
            {name: 'title', prefix: '', suffix: ',', formatters: [] },
            {name: 'creation_date', prefix: '(', suffix: ')', formatters: [] },
            {name: 'creator', prefix: ' | author=', suffix: '', formatters: [CommaJoinFormatter] },
            {name: 'current_date', prefix: ' | accessdate=', suffix: '', formatters: [] },
            {name: 'contributing_organization', prefix: ' | publisher=', suffix: '}} </ref>', formatters: [] }
          ]
        end
      end
    end
  end
end