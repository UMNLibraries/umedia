require 'test_helper'

module Umedia
  class FacetFieldConfigTest < ActiveSupport::TestCase
    it 'produces a set of common facet fields to be used throughout the app' do
      config = FacetFieldConfig.new
      _(config.visible).must_equal([:super_collection_name_ss, :contributing_organization_name_s, :collection_name_s, :types, :format_name, :date_created_ss, :subject_ss, :creator_ss, :publisher_s, :contributor_ss, :language])
      _(config.hidden).must_equal([:format_name, :subject_fast_ss, :city, :state, :country, :region, :continent, :parent_collection_name, :date_added])
      _(config.all).must_equal([:super_collection_name_ss, :contributing_organization_name_s, :collection_name_s, :types, :format_name, :date_created_ss, :subject_ss, :creator_ss, :publisher_s, :contributor_ss, :language, :format_name, :subject_fast_ss, :city, :state, :country, :region, :continent, :parent_collection_name, :date_added])
    end
  end
end
