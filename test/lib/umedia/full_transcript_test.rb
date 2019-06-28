require 'test_helper'

module Umedia
  class FullTranscriptTest < ActiveSupport::TestCase
    describe 'when an item has one or more transcripts' do
      describe 'and is a compound' do
        let(:compound_item) { Umedia::ItemSearch.new(id: 'p16022coll95:33').item }
        it 'gathers page transcripts' do
          ft = FullTranscript.new(item: compound_item)
          ft.to_s.must_equal(File.read('test/fixtures/p16022coll95:33.txt'))
        end
      end

      describe 'and item is not compound' do
        let(:item) { Umedia::ItemSearch.new(id: 'p16022coll289:3').item }
        it 'gathers page transcripts' do
          ft = FullTranscript.new(item: item)
          ft.to_s.must_equal("North America/United States/Minnesota")
        end
      end
    end

    describe 'when an item has  transcripts' do
      describe 'and is a compound' do
        let(:compound_item) { Umedia::ItemSearch.new(id: 'p16022coll272:6').item }
        it 'gathers page transcripts' do
          ft = FullTranscript.new(item: compound_item)
          File.open('p16022coll272:6.txt', 'w') { |file| file.write(ft.to_s) }
          ft.to_s.must_equal(File.read('test/fixtures/p16022coll272:6.txt'))
        end
      end

      describe 'and item is not compound' do
        let(:item) { Umedia::ItemSearch.new(id: 'p16022coll135:0').item }
        it 'gathers page transcripts' do
          ft = FullTranscript.new(item: item)
          ft.to_s.must_equal('')
        end
      end
    end
  end
end
