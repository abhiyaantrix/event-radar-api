# frozen_string_literal: true

if Rails.env.test?
  require 'simplecov'
  require 'simplecov-console'
  require 'simplecov-cobertura'

  SimpleCov.start 'rails' do
    add_filter '/spec/'
    add_filter '/db/'
    add_filter '/config/'
    add_filter '/vendor/'
    add_filter '/app/channels/'
    add_filter '/lib/'
    add_filter '/bin/'

    track_files '**/*.rb'

    SimpleCov::Formatter::Console.max_rows = 5
    SimpleCov::Formatter::Console.output_style = 'block'

    formatter SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::Console,
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::CoberturaFormatter
    ])
  end
end
