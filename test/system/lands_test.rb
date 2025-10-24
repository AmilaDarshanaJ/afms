require "application_system_test_case"

class LandsTest < ApplicationSystemTestCase
  setup do
    @land = lands(:one)
  end

  test "visiting the index" do
    visit lands_url
    assert_selector "h1", text: "Lands"
  end

  test "should create land" do
    visit lands_url
    click_on "New land"

    fill_in "Address", with: @land.address
    fill_in "Boundary east", with: @land.boundary_east
    fill_in "Boundary north", with: @land.boundary_north
    fill_in "Boundary south", with: @land.boundary_south
    fill_in "Boundary west", with: @land.boundary_west
    fill_in "Crop type", with: @land.crop_type
    fill_in "Extent", with: @land.extent
    fill_in "Harvest frequency", with: @land.harvest_frequency
    fill_in "Latitude", with: @land.latitude
    fill_in "Longitude", with: @land.longitude
    fill_in "Name", with: @land.name
    fill_in "Owner manager name", with: @land.owner_manager_name
    click_on "Create Land"

    assert_text "Land was successfully created"
    click_on "Back"
  end

  test "should update Land" do
    visit land_url(@land)
    click_on "Edit this land", match: :first

    fill_in "Address", with: @land.address
    fill_in "Boundary east", with: @land.boundary_east
    fill_in "Boundary north", with: @land.boundary_north
    fill_in "Boundary south", with: @land.boundary_south
    fill_in "Boundary west", with: @land.boundary_west
    fill_in "Crop type", with: @land.crop_type
    fill_in "Extent", with: @land.extent
    fill_in "Harvest frequency", with: @land.harvest_frequency
    fill_in "Latitude", with: @land.latitude
    fill_in "Longitude", with: @land.longitude
    fill_in "Name", with: @land.name
    fill_in "Owner manager name", with: @land.owner_manager_name
    click_on "Update Land"

    assert_text "Land was successfully updated"
    click_on "Back"
  end

  test "should destroy Land" do
    visit land_url(@land)
    click_on "Destroy this land", match: :first

    assert_text "Land was successfully destroyed"
  end
end
