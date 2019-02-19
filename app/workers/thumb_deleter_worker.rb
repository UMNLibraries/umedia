require 'sidekiq'
# frozen_string_literal: true
require 'sidekiq/testing'
Sidekiq::Testing.inline!

# Delete a batch of thumbnails
class ThumbDeleterWorker
  include Sidekiq::Worker
  attr_reader :bucket, :search_params_string, :page
  attr_writer :deleter, :worker_klass
  def perform(bucket, search_params_string, page)
    @bucket = bucket
    @search_params_string = search_params_string
    @page = page
    deleter.delete!
    return if deleter.last_batch?
    worker_klass.perform_async(bucket, search_params_string, page + 1)
  end

  def deleter
    @deleter ||= DeleteThumbnails.new(bucket: bucket,
                                      param_string: search_params_string,
                                      page: page)
  end

  def worker_klass
    @worker_klass ||= ThumbDeleterWorker
  end
end
