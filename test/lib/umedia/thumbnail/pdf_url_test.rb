require 'test_helper'

module Umedia
  module Thumbnail
    class PdfUrlTest < ActiveSupport::TestCase
      it 'generates an kaltura audio thumb url' do
        url = PdfUrl.new
        _(url.to_s).must_equal 'http://d1rxd8nozvj6aj.cloudfront.net/umedia-pdf-icon.png'
      end
    end
  end
end
