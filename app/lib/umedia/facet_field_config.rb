module Umedia
  class FacetFieldConfig
    def visible
      ENV['RAILS_ENV'] == 'development' ? prod.concat([:page_count]) : prod
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
        :date_added
      ]
    end

    def all
      visible.concat(hidden)
    end

    private

    def prod
      [
        :super_collection_name_ss,
        :contributing_organization_name_s,
        :collection_name_s,
        :types,
        :format_name,
        :date_created_ss,
        :subject_ss,
        :creator_ss,
        :publisher_s,
        :contributor_ss,
        :language
      ]
    end
  end
end
