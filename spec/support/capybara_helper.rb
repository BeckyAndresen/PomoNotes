# copied from https://dev.to/fdoxyz/headless-chrome-dual-mode-tests-for-ruby-on-rails-4p6g

Capybara.asset_host = 'localhost:3000'
RSpec.configure do |config|
  config.include Capybara::DSL

  Capybara.server = :puma, { Silent: true }

  # Chrome non-headless driver
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  # Chrome headless driver
  Capybara.register_driver :headless_chrome do |app|
    caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
    opts = Selenium::WebDriver::Chrome::Options.new

    chrome_args = %w[--headless --no-sandbox --disable-gpu --window-size=1920,1080 --remote-debugging-port=9222]
    chrome_args.each { |arg| opts.add_argument(arg) }
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts, desired_capabilities: caps)
  end
  # The default behavior is Headless. The usual clean, quick, and simple.
  # $ bundle exec rspec
  # Set the HEADLESS environment variable to something falsy to open a Chrome window for interactive debugging
  # $ HEADLESS=0 bundle exec rspec
  case ENV['HEADLESS']
  when 'true', 1, nil
    Capybara.javascript_driver = :headless_chrome
  else
    Capybara.javascript_driver = :chrome
  end
end
