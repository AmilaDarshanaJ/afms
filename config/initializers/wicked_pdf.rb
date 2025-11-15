# frozen_string_literal: true

WickedPdf.config = {
  # This is the key part:
  # It tells wicked_pdf to use the executable from the 'wkhtmltopdf-binary' gem
  exe_path: Gem.bin_path('wkhtmltopdf-binary', 'wkhtmltopdf')
}