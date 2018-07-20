# frozen_string_literal: true

module Umedia
  # Full record itation formatters
  module Citation
    require_dependency "#{Rails.root}/app/lib/umedia/citation/formatters"
    module Styles
      class URIEncodeFormatter
        def self.format(value)
          CGI.escape value
        end
      end
      class ClosingSpanFormatter
        def self.format(value)
          '></span>'
        end
      end
      class Coins
        def self.mappings
          [
            { name: 'title', prefix: '<span className="Z3988" title=', suffix: '', formatters: [URIEncodeFormatter] },
            { name: 'creator', prefix: '&amp;rft.creator', suffix: '', formatters: [CommaJoinFormatter, URIEncodeFormatter] },
            { name: 'creation_date', prefix: ' ', suffix: '.', formatters: [URIEncodeFormatter] },
            { name: 'title', prefix: '&amp;rft.title=', suffix: '', formatters: [URIEncodeFormatter] },
            { name: 'description', prefix: '&amp;rft.description=', suffix: '', formatters: [URIEncodeFormatter] },
            { name: 'subject', prefix: '&amp;rft.subject=', suffix: '', formatters: [CommaJoinFormatter, URIEncodeFormatter] },
            { name: 'description', prefix: '&amp;rft.description=', suffix: '', formatters: [URIEncodeFormatter] },
            { name: 'contributing_organization', prefix: 'publisher', suffix: '', formatters: [URIEncodeFormatter] },
            { name: 'format', prefix: '&amp;rft.format=', suffix: '', formatters: [Umedia::Citation::CommaJoinFormatter] },
            { name: 'rights', prefix: '&amp;rft.rights=', suffix: '', formatters: [URIEncodeFormatter] },
            { name: 'url', prefix: '&amp;rft.identifier=', suffix: '', formatters: [URIEncodeFormatter]},
            { name: 'id', prefix: '', suffix: '', formatters: [ClosingSpanFormatter] }
          ]
        end
      end
    end
  end
end