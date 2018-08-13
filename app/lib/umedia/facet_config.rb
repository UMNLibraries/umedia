# frozen_string_literal: true

module Umedia
  # Add facet serch configs for use in Umedia::Search
  class FacetConfig
    attr_reader :params, :prefix, :sort, :offset, :limit, :fields
    def initialize(params: {},
                   prefix: '',
                   sort: 'count',
                   offset: 0,
                   limit: 15,
                   fields: :MISSING_FACET_FIELDS)

      @params = params
      @prefix = prefix
      @sort   = sort
      @offset = offset.to_i
      @limit  = limit.to_i
      @fields = fields
    end

    def config
      {
        'facet.field'  => fields,
        'facet.limit'  => limit,
        'facet.prefix' => prefix,
        'facet.sort'   => sort,
        'facet.offset' => page,
        fq: ['record_type:primary'].concat(fq)
      }
    end

    private

    def page
      offset * limit
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
