module Umedia
  class FacetSearch
    attr_reader :q, :offset, :config, :next_config, :search_klass
    def initialize(q: '',
                   config: FacetConfig.new,
                   next_config: FacetConfig.new(offset: 1),
                   search_klass: Search)
      @q = q
      @offset = config.offset
      @config = config.config
      @next_config = next_config.config
      @search_klass = search_klass
    end

    def results
      @results ||= search config
    end

    def next_page
      return offset if !next_page?
      offset + 1
    end

    def prev_page
      return 0 if offset.zero?
      (offset - 1)
    end

    def next_class
      next_page? ? '' : 'disabled'
    end

    def prev_class
      offset != 0 ? '' : 'disabled'
    end

    private

    def next_page?
      next_results.values[0].length.positive?
    end

    # We have no way of getting a facet result count, so we look ahead to the
    # next offset to see if there are any results. This method is used by the
    # FacetPager class
    def next_results
      @next_results ||= search next_config
    end

    def search(conf)
      search_klass.new(
        q: q,
        fl: 'id',
        facet_config: conf
      ).response.fetch('facet_counts', {}).fetch('facet_fields', {})
    end
  end
end