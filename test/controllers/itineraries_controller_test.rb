require 'test_helper'

class ItinerariesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get itineraries_index_url
    assert_response :success
  end

  test "should get show" do
    get itineraries_show_url
    assert_response :success
  end

  test "should get favorites" do
    get itineraries_favorites_url
    assert_response :success
  end

end
