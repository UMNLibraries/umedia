require 'test_helper'

module Umedia
  module Citation
    module Styles
      class ChicagoTest < ActiveSupport::TestCase
        it 'produces an MLA formatted citation' do
          citation = Chicago.mappings.map do |cite|
            Field.new(prefix: cite[:prefix],
                      suffix: cite[:suffix],
                      formatters: cite[:formatters],
                      value: cite[:name]).to_s
          end.join
          citation.must_equal "creator.  date_created.\"title.\"  contributing_organization, Accessed 11/13/2018. https://umedia.lib.umn.edu/item/id"
        end
      end
    end
  end
end
