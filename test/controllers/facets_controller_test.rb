require 'test_helper'

class FacetsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get facets_show_url
    assert_response :success
  end

end
