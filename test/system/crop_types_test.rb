require "application_system_test_case"

class CropTypesTest < ApplicationSystemTestCase
  setup do
    @crop_type = crop_types(:one)
  end

  test "visiting the index" do
    visit crop_types_url
    assert_selector "h1", text: "Crop types"
  end

  test "should create crop type" do
    visit crop_types_url
    click_on "New crop type"

    fill_in "Description", with: @crop_type.description
    fill_in "Name", with: @crop_type.name
    click_on "Create Crop type"

    assert_text "Crop type was successfully created"
    click_on "Back"
  end

  test "should update Crop type" do
    visit crop_type_url(@crop_type)
    click_on "Edit this crop type", match: :first

    fill_in "Description", with: @crop_type.description
    fill_in "Name", with: @crop_type.name
    click_on "Update Crop type"

    assert_text "Crop type was successfully updated"
    click_on "Back"
  end

  test "should destroy Crop type" do
    visit crop_type_url(@crop_type)
    click_on "Destroy this crop type", match: :first

    assert_text "Crop type was successfully destroyed"
  end
end
