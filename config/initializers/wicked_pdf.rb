# frozen_string_literal: true

WickedPdf.configure do |config|
  # Use wkhtmltopdf from wkhtmltopdf-binary gem
  config.exe_path = Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
end
