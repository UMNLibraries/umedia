require 'sidekiq/testing'
Sidekiq::Testing.inline!

require 'test_helper'
  class ThumbDeleterWorkerTest < ActiveSupport::TestCase
    it 'recursively deletes batchs of thumbnails' do
      worker = ThumbDeleterWorker.new
      deleter = Minitest::Mock.new
      deleter.expect :delete!, '', []
      deleter.expect :last_batch?, false, []
      worker_klass = Minitest::Mock.new
      worker_klass.expect :perform_async, false, ['bucket', 'search_url', 2]
      worker.deleter = deleter
      worker.worker_klass = worker_klass
      worker.perform('bucket', 'search_url', 1)
      deleter.verify
      worker_klass.verify
    end
  end
