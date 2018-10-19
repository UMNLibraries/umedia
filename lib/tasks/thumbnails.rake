namespace :thumbnails do
  desc "cache all thumbnails"
  task :populate, [:query] => [:environment] do |task, args|
    q = (args[:query]) ? args[:query] : '*:*'
    puts "Thumbnail Query: #{q}"
    thumbnails(q: q) do |docs|
      Umedia::CacheThumbnailsWorker.perform_async(docs)
    end
  end
end

def thumbnails(q: '*:*', page: 0, &block)
  search = Umedia::ThumbnailSearch.new(q: q, page: page)
  yield(search.docs)
  thumbnails(q: q, page: page + 1, &block) unless search.stop?
end
