require "test_helper"

class CropTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crop_type = crop_types(:one)
  end

  test "should get index" do
    get crop_types_url
    assert_response :success
  end

  test "should get new" do
    get new_crop_type_url
    assert_response :success
  end

  test "should create crop_type" do
    assert_difference("CropType.count") do
      post crop_types_url, params: { crop_type: { description: @crop_type.description, name: @crop_type.name } }
    end

    assert_redirected_to crop_type_url(CropType.last)
  end

  test "should show crop_type" do
    get crop_type_url(@crop_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_crop_type_url(@crop_type)
    assert_response :success
  end

  test "should update crop_type" do
    patch crop_type_url(@crop_type), params: { crop_type: { description: @crop_type.description, name: @crop_type.name } }
    assert_redirected_to crop_type_url(@crop_type)
  end

  test "should destroy crop_type" do
    assert_difference("CropType.count", -1) do
      delete crop_type_url(@crop_type)
    end

    assert_redirected_to crop_types_url
  end
end
