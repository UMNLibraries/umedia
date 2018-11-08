# frozen_string_literal: true
require_dependency "#{Rails.root}/app/lib/umedia/citation/formatters"

module Umedia
  module Citation
    module Styles
      class ChicagoDateFormatter
        def self.format(value)
          Time.now.strftime('%m/%d/%Y')
        end
      end

      class Chicago
        def self.mappings
          [
            { name: 'creator', prefix: '', suffix: '. ', formatters: [CommaJoinFormatter] },
            { name: 'date_created', prefix: ' ', suffix: '.', formatters: [CommaJoinFormatter]},
            { name: 'title', prefix: '"', suffix: '." ', formatters: [] },
            { name: 'contributing_organization', prefix: ' ', suffix: ', ', formatters: [] },
            { name: 'current_date', prefix: 'Accessed ', suffix: '. ', formatters: [ChicagoDateFormatter]},
            { name: 'id', prefix: '', suffix: '', formatters: [URLFormatter] }
          ]
        end
      end
    end
  end
end