module ItemsHelper
  def item
    @item
  end

  def sidebar
    @sidebar
  end

  def search_params
    @search_params
  end

  def child_page_num
    @child_page_num
  end

  def format_values(values, facet)
    if values.respond_to?(:join)
      values.map { |val| facet_item(facet, val) }.join('; ')
    else
      facet_item(facet, values)
    end
  end

  def facet_item(facet, value)
    if facet
      link_to value, searches_path(facet_link(facet, value, {}).link_params)
    else
      value
    end
  end

  def auto_links(value)
    if value.respond_to?(:map)
      value.map do |value|
        auto_link(value)
      end
    else
      auto_link(value)
    end
  end

  def auto_link(value)
    if value.is_a?(String)
      Rinku.auto_link value
    else
      value
    end
  end

  def sidebar_scroll_class
    !@show_sidebar_slider ? 'sidebar-scroll' : ''
  end

  def manifest
    @manifest ||= Umedia::IiifManifest.new(id: item.id,
                                           collection: item.collection,
                                           viewer_type: item.viewer_type)
  end

  def format_solr_date(field)
    date =  (field.value) ? field.value.split('T').first : field.value
    Parhelion::Field.new(name: field.name, value: date)
  end
end
