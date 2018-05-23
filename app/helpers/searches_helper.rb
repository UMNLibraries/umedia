module SearchesHelper
  def query(search_params)
    Parhelion::Query.new(params: search_params)
  end

  def facet_link(field, value, search_params)
    Parhelion::FacetQuery.new(field: field,
                              value: value,
                              query: query(search_params))
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
