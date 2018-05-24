# frozen_string_literal: true

module Parhelion
  # A light wrapper around search params, removes empty items
  class Query
    attr_accessor :params
    def initialize(params: {})
      @params = params.delete_if { |k, v| v.empty? }
    end

    def except(field)
      params.except field
    end

    def merge(field)
      params.merge field
    end

    # /via Rails::Hash
    def deep_merge(field)
      params.deep_merge field
    end

    def fetch(field, default = {})
      params.fetch(field, default)
    end

    def active?
      !params.empty?
    end
  end
end
