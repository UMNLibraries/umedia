module SearchesHelper

  def facet_params
    params.permit(facets: @facet_fields_all.map { |facet| {facet => []} })[:facets]
  end

  def hidden_facet_values
    facet_params.to_h.map do |name, values|
      values.map do |value|
        hidden_field_tag "facets[#{name}][]", value
      end
    end.join("\n")
  end

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

  def facet_crumbs(facet_list, search_params)
    facet_list.map do |facet|
      facet.map do |facet_row|
        {
          link: facet_link(facet.name, facet_row.value, search_params),
          row: facet_row,
          name: facet.name,
          search_params: search_params
        }
      end.select { |facet| facet[:link].active? }
    end.flatten
  end

  def truncate_field(value, truncate_it)
    truncate_it ? truncate(value, length: 350) : value
  end
end
