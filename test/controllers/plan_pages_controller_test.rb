require "test_helper"

class PlanPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get plan_pages_index_url
    assert_response :success
  end

  test "should get new" do
    get plan_pages_new_url
    assert_response :success
  end

  test "should get create" do
    get plan_pages_create_url
    assert_response :success
  end

  test "should get show" do
    get plan_pages_show_url
    assert_response :success
  end
end
