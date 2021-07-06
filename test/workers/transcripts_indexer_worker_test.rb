require 'sidekiq/testing'
Sidekiq::Testing.inline!

require 'test_helper'
  class TranscriptsIndexerWorkerTest < ActiveSupport::TestCase
      it 'recursively indexes batchs of transcripts of a collection' do
        worker = TranscriptsIndexerWorker.new
        indexer_klass = mock()
        indexer_obj = mock()
        worker.indexer_klass = indexer_klass
	indexer_klass.expects(:new).with({:set_spec=>"coll123", :page=>1, :after_date=>false}).returns(indexer_obj)
        indexer_obj.expects(:index!).returns([])
        indexer_obj.expects(:empty?).returns(false)
        indexer_obj.expects(:next_page).returns(2)
        worker.perform(1, 'coll123')
      end
  end
