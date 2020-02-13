# frozen_string_literal: true

module CollectionsHelper
  def collection_path(collection)
    if collection['is_super_collection']
      searches_path(facet_link('super_collection_name_ss', collection['collection_name'], {}).link_params)
    else
      searches_path(facet_link('collection_name_s', collection['collection_name'], {}).link_params)
    end
  end

  def fallback_thum_url(url)
    url ? url['cdn'] : ENV['UMEDIA_NAILER_THUMB_FALLBACK_URL']
  end
end
