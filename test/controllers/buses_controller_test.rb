require 'test_helper'

class BusesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get buses_show_url
    assert_response :success
  end

end
