class FacetsController < ApplicationController
  def index
    response.headers["Content-Language"] = I18n.locale.to_s
    @browse = browse?
    render({
            locals: {
              facet: facet_list.first,
              facet_params: facet_params.to_h,
              facet_search: facet_search
              }
           }.merge(disable_layout))
  end

  # Disable layout when in modal mode only
  def disable_layout
    facet_params[:modal] == 'on' ? {layout: false} : {}
  end

  def facet_list
    Parhelion::FacetList.new(facet_hash: facet_search.results)
  end

  def facet_search
    Umedia::FacetSearch.new(q: facet_params.fetch('q', ''),
                            config: facet_config(offset),
                            next_config: facet_config(offset + 1))
  end

  def facet_config(offset)
    Umedia::FacetConfig.new(
      {
        params: facet_params.fetch(:facets, {}),
        prefix: facet_params.fetch(:letter, '')[0],
        offset: offset,
        limit:  facet_params.fetch(:facet_limit, 20).to_i,
        sort:   facet_params.fetch(:facet_sort, 'count'),
        fields: [legal_field]
      }
    )
  end

  def legal_field
    facet_fields_all.include?(facet_field.to_sym) ? facet_field : :subject_ss
  end

  def facet_field
    facet_params.fetch(:facet_field, :subject_ss)
  end

  def offset
    facet_params.fetch(:facet_offset, 0).to_i
  end

  def facet_fields
    [
      :types,
      :format_name,
      :date_created_ss,
      :subject_ss,
      :creator_ss,
      :publisher_s,
      :contributor_ss,
      :collection_name_s,
      :super_collection_names_ss,
      :page_count
    ]
  end

  def facet_fields_hidden
    [
      :format_name,
      :subject_fast_ss,
      :city,
      :state,
      :country,
      :region,
      :continent,
      :parent_collection_name,
      :contributing_organization_name
    ]
  end

  def browse?
    facet_params.fetch(:browse, false)
  end

  def facet_fields_all
    facet_fields.concat(facet_fields_hidden)
  end

  def facet_params
    params.permit(:facet_field,
                  :letter,
                  :facet_sort,
                  :facet_offset,
                  :facet_limit,
                  :facet_prefix,
                  :modal,
                  :q,
                  :rows,
                  :sort,
                  :browse,
                  facets: facet_fields_all.map { |facet| {facet => [] } })
  end
end
