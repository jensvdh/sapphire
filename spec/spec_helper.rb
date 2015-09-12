$: << '../'
Dir.glob('lib/**/*.rb').each {|f| require f}

# A link to some handy testing guidelines: http://betterspecs.org/
RSpec.configure do |config|
  # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter - I like fuubar, but feel free to change it
  config.formatter = 'Fuubar' # :documentation # :progress, :html, :textmate

  # Use expectation syntax: 
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
