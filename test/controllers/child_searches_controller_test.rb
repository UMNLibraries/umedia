require 'test_helper'

class ChildSearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get child_searches_index_url, params: {id: 'p16022coll209:88'}
    assert_response :success
  end

end
