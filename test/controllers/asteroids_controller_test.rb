require "test_helper"

class AsteroidsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get asteroids_index_url
    assert_response :success
  end
end
