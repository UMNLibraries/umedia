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

  def pager(search_params, result_count)
    rows = search_params.fetch('rows', 50).to_i
    page = search_params.fetch('page', 1).to_i
    Parhelion::Pager.new(current_page: page,
                         rows: rows,
                         result_count: result_count)
  end
end
