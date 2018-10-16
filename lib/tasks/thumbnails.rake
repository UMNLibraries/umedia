namespace :thumbnails do
  desc "cache all thumbnails"
  task populate: [:environment]  do
    thumbnails do |docs|
      Umedia::CacheThumbnailsWorker.perform_async(docs)
    end
  end
end



def thumbnails(page: 0, &block)
  search = Umedia::ThumbnailSearch.new(page: page)
    yield(search.docs)
    thumbnails(page: page + 1, &block) unless search.stop?
end
