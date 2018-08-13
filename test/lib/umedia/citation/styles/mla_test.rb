require 'test_helper'

module Umedia
  module Citation
    module Styles
      class MLATest < ActiveSupport::TestCase
        it 'produces an MLA formatted citation' do
          mla = MLA.new
          citation = MLA.mappings.map do |cite|
            Field.new(prefix: cite[:prefix],
                      suffix: cite[:suffix],
                      formatters: cite[:formatters],
                      value: cite[:name]).to_s
          end.join
          citation.must_equal "creator. <i>title</i>. date_created. contributing_organization, umedia.lib.umn.edu/item/id Accessed 13 Aug 2018."
        end
      end
    end
  end
end
