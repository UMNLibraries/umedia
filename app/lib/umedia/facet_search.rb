# frozen_string_literal: true

module Umedia
  # Add facet serch configs for use in Umedia::Search
  class FacetSearch
    attr_reader :params, :prefix, :sort, :offset, :limit, :fields
    def initialize(params: {},
                   prefix: '',
                   sort: 'count',
                   offset: 0,
                   limit: 15,
                   fields: [])

      @params = params
      @prefix = prefix
      @sort   = sort
      @offset = offset
      @limit  = limit
      @fields = fields
    end

    def config
      {
        'facet.field': fields,
        'facet.limit': limit,
        'facet.prefix': prefix,
        'facet.sort': sort,
        'facet.offset': offset,
        fq: ['record_type:primary'].concat(fq)
      }
    end

    def fq
      params.keys.map do |key|
        params[key].map do |param|
          "#{key}:\"#{param}\""
        end
      end.flatten
    end
  end
end
