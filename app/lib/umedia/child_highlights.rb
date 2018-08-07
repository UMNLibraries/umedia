# frozen_string_literal: true

module Umedia
  # When you want all child records along with highlights of a search phrase
  #
  # Runs two child searches: one that gets all children and one that searches
  # children for a query phrase. The former is used for the items list
  # and the latter for highlights.
  class ChildHighlights
    attr_reader :q, :parent_id, :child_search_klass
    def initialize(q: '',
                   parent_id: :MISSING_PARENT_ID,
                   child_search_klass: ChildSearch)
      @q = q
      @parent_id = parent_id
      @child_search_klass = child_search_klass
    end

    def empty?
      items.empty?
    end

    def items
      child_search_klass.new(parent_id: parent_id).items
    end

    def highlighting
      child_search_klass.new(q: q, parent_id: parent_id).highlighting
    end
  end
end
