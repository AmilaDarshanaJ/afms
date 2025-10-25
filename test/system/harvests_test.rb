require "application_system_test_case"

class HarvestsTest < ApplicationSystemTestCase
  setup do
    @harvest = harvests(:one)
  end

  test "visiting the index" do
    visit harvests_url
    assert_selector "h1", text: "Harvests"
  end

  test "should create harvest" do
    visit harvests_url
    click_on "New harvest"

    fill_in "Actual date", with: @harvest.actual_date
    fill_in "Amount", with: @harvest.amount
    fill_in "Crop type", with: @harvest.crop_type
    fill_in "Land", with: @harvest.land_id
    fill_in "Planned date", with: @harvest.planned_date
    fill_in "Unit", with: @harvest.unit
    click_on "Create Harvest"

    assert_text "Harvest was successfully created"
    click_on "Back"
  end

  test "should update Harvest" do
    visit harvest_url(@harvest)
    click_on "Edit this harvest", match: :first

    fill_in "Actual date", with: @harvest.actual_date
    fill_in "Amount", with: @harvest.amount
    fill_in "Crop type", with: @harvest.crop_type
    fill_in "Land", with: @harvest.land_id
    fill_in "Planned date", with: @harvest.planned_date
    fill_in "Unit", with: @harvest.unit
    click_on "Update Harvest"

    assert_text "Harvest was successfully updated"
    click_on "Back"
  end

  test "should destroy Harvest" do
    visit harvest_url(@harvest)
    click_on "Destroy this harvest", match: :first

    assert_text "Harvest was successfully destroyed"
  end
end
