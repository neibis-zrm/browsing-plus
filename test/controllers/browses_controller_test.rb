require 'test_helper'

class BrowsesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get browses_index_url
    assert_response :success
  end

end
