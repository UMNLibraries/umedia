require 'sidekiq/testing'
Sidekiq::Testing.inline!

require 'test_helper'
  class TranscriptsIndexerWorkerTest < ActiveSupport::TestCase
      it 'recursively indexes batchs of transcripts of a collection' do
        worker = TranscriptsIndexerWorker.new
        indexer_klass = Minitest::Mock.new
        indexer_obj = Minitest::Mock.new
        worker.indexer_klass = indexer_klass
        indexer_klass.expect :new, indexer_obj, [{:set_spec=>"coll123", :page=>1}]
        indexer_obj.expect :index!, [], []
        indexer_obj.expect :empty?, false, []
        indexer_obj.expect :next_page, 2, []
        worker.perform(1, 'coll123')
        indexer_klass.verify
        indexer_obj.verify
      end
  end
