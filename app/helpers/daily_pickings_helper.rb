module DailyPickingsHelper
  def dp_qty(value)
    number_with_precision(value, precision: 2, strip_insignificant_zeros: true, delimiter: ",")
  end

  def dp_field_error(record, attr)
    msg = record.errors[attr].first
    tag.span(msg, class: "dp-error") if msg
  end
end