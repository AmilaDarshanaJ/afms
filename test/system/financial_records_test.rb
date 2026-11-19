require "application_system_test_case"

class FinancialRecordsTest < ApplicationSystemTestCase
  setup do
    @financial_record = financial_records(:one)
  end

  test "visiting the index" do
    visit financial_records_url
    assert_selector "h1", text: "Financial records"
  end

  test "should create financial record" do
    visit financial_records_url
    click_on "New financial record"

    fill_in "Amount", with: @financial_record.amount
    fill_in "Category", with: @financial_record.category
    fill_in "Description", with: @financial_record.description
    fill_in "Land", with: @financial_record.land_id
    fill_in "Transaction date", with: @financial_record.transaction_date
    fill_in "Transaction type", with: @financial_record.transaction_type
    click_on "Create Financial record"

    assert_text "Financial record was successfully created"
    click_on "Back"
  end

  test "should update Financial record" do
    visit financial_record_url(@financial_record)
    click_on "Edit this financial record", match: :first

    fill_in "Amount", with: @financial_record.amount
    fill_in "Category", with: @financial_record.category
    fill_in "Description", with: @financial_record.description
    fill_in "Land", with: @financial_record.land_id
    fill_in "Transaction date", with: @financial_record.transaction_date
    fill_in "Transaction type", with: @financial_record.transaction_type
    click_on "Update Financial record"

    assert_text "Financial record was successfully updated"
    click_on "Back"
  end

  test "should destroy Financial record" do
    visit financial_record_url(@financial_record)
    click_on "Destroy this financial record", match: :first

    assert_text "Financial record was successfully destroyed"
  end
end
