# frozen_string_literal: true

# Tasks to expose granular cache clearing
namespace :umedia_cache do
  desc 'clear all caches associated with record counts'
  task clear_counts: [:environment] do
    count_caches.each { |cache| Rails.cache.delete(cache) }
  end

  def count_caches
    %w[
      all_pages_count
      facet_count_format_name
      facet_count_collection_name_s
      record_count
    ]
  end

  desc 'clear redis cache'
  task clear: [:environment] do
    Rails.cache.clear
  end
end
