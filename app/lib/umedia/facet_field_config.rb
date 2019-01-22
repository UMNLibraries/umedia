module Umedia
  class FacetFieldConfig
    def visible
      [
        :super_collection_name_ss,
        :collection_name_s,
        :types,
        :format_name,
        :date_created_ss,
        :subject_ss,
        :creator_ss,
        :publisher_s,
        :contributor_ss,
        :page_count,
        :language
      ]
    end

    def hidden
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

    def all
      visible.concat(hidden)
    end
  end
end