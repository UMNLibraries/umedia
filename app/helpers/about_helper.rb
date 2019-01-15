module AboutHelper
  def contributing_organization_count
    Rails.cache.fetch("contributing_organization_count", expires_in: 12.hours) do
      Umedia::FacetCountSearch.new(facet: 'contributing_organization_name').count
    end
  end

  def formats_count
    Rails.cache.fetch("formats_count", expires_in: 12.hours) do
      Umedia::FacetCountSearch.new(facet: 'format_name').count
    end
  end
end
