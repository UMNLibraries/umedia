module SearchesHelper
  def facet_list(search: :MISSING_SEARCH,
                 field: :MISSING_FIELD,
                 search_params: :MISSING_SEARCH_PARAMS)
    search.facet(field).rows.map do |facet|
      [
        facet_query(field,
                    facet.value,
                    query(search_params)),
        facet.count
      ]
    end
  end

  def query(search_params)
    Parhelion::Query.new(params: search_params)
  end

  def facet_query(field, value, query)
    Parhelion::FacetQuery.new(field: field,
                              value: value,
                              query: query)
  end

  def field_query(path, query)
    Parhelion::FieldQuery.new(path: path, query: query)
  end

  def sort_query(asc, desc, search_params)
    Parhelion::SortQuery.new(asc: asc,
                             desc: desc,
                             query: query(search_params))
  end
end
