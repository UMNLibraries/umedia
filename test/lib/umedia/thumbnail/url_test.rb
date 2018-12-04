require 'test_helper'

module Umedia
  module Thumbnail
    class UrlTest < ActiveSupport::TestCase
      describe 'when an item is an image' do
        describe 'and we ask for the default CDM thumbnail' do
          it 'produces an cdm image thumbnail url' do
            # UmageUrl mocks
            item = Parhelion::Item.new(doc_hash: {'id' => 'foo123:999', 'viewer_type' => 'image', 'object' => 'http://example.com'})
            url = Url.new(item: item)
            url.to_s.must_equal 'http://example.com'
            url.to_cdn_s.must_equal 'https://d2y23onbq5rnfc.cloudfront.net/89dce6a446a69d6b9bdc01ac75251e4c322bcdff.png'
          end
        end
        describe 'and we ask for a IIIF thumbnail' do
          it 'produces an cdm image thumbnail url' do
            # UmageUrl mocks
            image_url_klass = Minitest::Mock.new
            image_url_klass_obj = Minitest::Mock.new
            image_url_klass.expect :new, image_url_klass_obj, [{ object_url: "http://example.com", collection: 'foo123', id: '999' }]
            image_url_klass_obj.expect :to_s, 'imageurlhere', []
            item = Parhelion::Item.new(doc_hash: {'id' => 'foo123:999', 'viewer_type' => 'image', 'object' => 'http://example.com'})
            url = Url.new(item: item, iiif_thumb: true, image_url_klass: image_url_klass)
            url.to_s.must_equal 'imageurlhere'
            url.to_cdn_s.must_equal 'https://d2y23onbq5rnfc.cloudfront.net/87b9bff439a69511f7e7e545478972916af0b257.png'
            image_url_klass.verify
            image_url_klass_obj.verify
          end
        end
      end

      describe 'when an item is an kaltura audio' do
        it 'produces a kaltura audio url' do
          # KalturaAudioUrl mocks
          kaltura_audio_url_klass = Minitest::Mock.new
          kaltura_audio_url_klass_obj = Minitest::Mock.new
          kaltura_audio_url_klass.expect :new, kaltura_audio_url_klass_obj, []
          kaltura_audio_url_klass_obj.expect :to_s, 'audiothumburlhere', []
          item = Parhelion::Item.new(doc_hash: {'id' => 'foo123:999', 'viewer_type' => 'kaltura_audio'})
          url = Url.new(item: item, kaltura_audio_url_klass: kaltura_audio_url_klass)
          url.to_s.must_equal 'audiothumburlhere'
          url.to_cdn_s.must_equal 'https://d2y23onbq5rnfc.cloudfront.net/f8f199197f33329f008e253414d520a70b5066ff.png'
          kaltura_audio_url_klass.verify
          kaltura_audio_url_klass_obj.verify
        end
      end

      describe 'when an item is an kaltura audio playlist' do
        it 'produces a kaltura audio url' do
          # KalturaAudioUrl mocks
          kaltura_audio_url_klass = Minitest::Mock.new
          kaltura_audio_url_klass_obj = Minitest::Mock.new
          kaltura_audio_url_klass.expect :new, kaltura_audio_url_klass_obj, []
          kaltura_audio_url_klass_obj.expect :to_s, 'audiothumburlhere', []
          item = Parhelion::Item.new(doc_hash: {'id' => 'foo123:999', 'viewer_type' => 'kaltura_audio_playlist'})
          url = Url.new(item: item, kaltura_audio_url_klass: kaltura_audio_url_klass)
          url.to_s.must_equal 'audiothumburlhere'
          url.to_cdn_s.must_equal 'https://d2y23onbq5rnfc.cloudfront.net/f8f199197f33329f008e253414d520a70b5066ff.png'
          kaltura_audio_url_klass.verify
          kaltura_audio_url_klass_obj.verify
        end
      end

      describe 'when an item is an kaltura video' do
        it 'produces a kaltura video url' do
          # KalturaVideoUrl mocks
          kaltura_video_url_klass = Minitest::Mock.new
          kaltura_video_url_klass_obj = Minitest::Mock.new
          kaltura_video_url_klass.expect :new, kaltura_video_url_klass_obj, [{ entry_id: '123blerg' }]
          kaltura_video_url_klass_obj.expect :to_s, 'videourlhere', []
          item = Parhelion::Item.new(doc_hash: {'id' => 'foo123:999', 'viewer_type' => 'kaltura_video', 'entry_id' => '123blerg'})
          url = Url.new(item: item, kaltura_video_url_klass: kaltura_video_url_klass)
          url.to_s.must_equal 'videourlhere'
          url.to_cdn_s.must_equal 'https://d2y23onbq5rnfc.cloudfront.net/d055b959ed1bcb485d02e042b695f2fd131bc0b7.png'
          kaltura_video_url_klass.verify
          kaltura_video_url_klass_obj.verify
        end
      end

      describe 'when an item is an kaltura video playlist' do
        it 'produces a kaltura video url' do
          # KalturaVideoUrl mocks
          kaltura_video_url_klass = Minitest::Mock.new
          kaltura_video_url_klass_obj = Minitest::Mock.new
          kaltura_video_url_klass.expect :new, kaltura_video_url_klass_obj, [{ entry_id: '123blerg' }]
          kaltura_video_url_klass_obj.expect :to_s, 'videourlhere', []
          item = Parhelion::Item.new(doc_hash: {'id' => 'foo123:999', 'viewer_type' => 'kaltura_video_playlist', 'entry_id' => '123blerg'})
          url = Url.new(item: item, kaltura_video_url_klass: kaltura_video_url_klass)
          url.to_s.must_equal 'videourlhere'
          url.to_cdn_s.must_equal 'https://d2y23onbq5rnfc.cloudfront.net/d055b959ed1bcb485d02e042b695f2fd131bc0b7.png'
          kaltura_video_url_klass.verify
          kaltura_video_url_klass_obj.verify
        end
      end

      describe 'when an item is an kaltura combo playlist' do
        it 'produces a kaltura video url' do
          # KalturaVideoUrl mocks
          kaltura_video_url_klass = Minitest::Mock.new
          kaltura_video_url_klass_obj = Minitest::Mock.new
          kaltura_video_url_klass.expect :new, kaltura_video_url_klass_obj, [{ entry_id: '123blerg' }]
          kaltura_video_url_klass_obj.expect :to_s, 'videourlhere', []
          item = Parhelion::Item.new(doc_hash: {'id' => 'foo123:999', 'viewer_type' => 'kaltura_combo_playlist', 'entry_id' => '123blerg'})
          url = Url.new(item: item, kaltura_video_url_klass: kaltura_video_url_klass)
          url.to_s.must_equal 'videourlhere'
          url.to_cdn_s.must_equal 'https://d2y23onbq5rnfc.cloudfront.net/d055b959ed1bcb485d02e042b695f2fd131bc0b7.png'
          kaltura_video_url_klass.verify
          kaltura_video_url_klass_obj.verify
        end
      end

      describe 'when an item is an pdf' do
        it 'produces a pdf url' do
          # KalturaVideoUrl mocks
          pdf_url_klass = Minitest::Mock.new
          pdf_url_klass_obj = Minitest::Mock.new
          pdf_url_klass.expect :new, pdf_url_klass_obj, []
          pdf_url_klass_obj.expect :to_s, 'pdfthumburlhere', []
          item = Parhelion::Item.new(doc_hash: {'id' => 'foo123:999', 'viewer_type' => 'pdf'})
          url = Url.new(item: item, pdf_url_klass: pdf_url_klass)
          url.to_s.must_equal 'pdfthumburlhere'
          url.to_cdn_s.must_equal 'https://d2y23onbq5rnfc.cloudfront.net/5580c0ddfaa02a0c3581a5e9888e39eff4a259c9.png'
          pdf_url_klass.verify
          pdf_url_klass_obj.verify
        end
      end
    end
  end
end