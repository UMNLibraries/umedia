require 'test_helper'

class ChildSearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get child_searches_index_url, params: {id: 'foo'}
    assert_response :success
  end

end
