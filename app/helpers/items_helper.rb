module ItemsHelper
  def download_configs(docs)
    docs.map do |doc|
      download_config(doc)
    end
  end

  def download_config(item)
    Umedia::Download.new(item: item)
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
end
