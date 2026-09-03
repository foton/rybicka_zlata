# frozen_string_literal: true

require 'selenium-webdriver'

Capybara.asset_host = 'http://localhost:3000'
Capybara.default_max_wait_time = 5

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options, service: chrome_service)
end

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options(headless: true), service: chrome_service)
end

Capybara.register_driver :firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.manager.showWhenStarting'] = false
  profile['browser.download.manager.showAlertOnComplete'] = false
  profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/csv,application/pdf'
  profile['browser.download.dir'] = Helpers::DownloadHelper::PATH.to_s
  profile['pdfjs.disabled'] = true # no displaying PDF "in-page"

  options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options).tap do |driver|
    driver.browser.manage.window.resize_to(1280, 800)
  end
end

# Capybara.javascript_driver = :firefox # (saving PDFs to our path is not working, all goes to ~/Downloads)
Capybara.javascript_driver = :chrome

Capybara.server = :puma, { Silent: true }

# Capybara::Screenshot.register_driver(:q_chrome) do |driver, path|
#   driver.browser.save_screenshot(path)
# end

# Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
#   filename = File.basename(example.file_path)
#   line_number = example.metadata[:line_number]

#   "screenshot-#{filename}-#{line_number}"
# end

# Capybara.add_selector(:spec) do
#   css { |v| "*[data-spec=#{v}]" }
# end

def chrome_options(headless: false)
  Selenium::WebDriver::Chrome::Options.new.tap do |options|
    options.binary = chrome_binary_path if chrome_binary_path
    options.add_option('goog:loggingPrefs', { browser: 'ALL' })
    chrome_arguments(headless: headless).each { |argument| options.add_argument(argument) }
  end
end

def chrome_binary_path
  ENV['CHROME_BINARY'].presence || executable_path(%w[
    /usr/bin/chromium-browser
    /snap/bin/chromium
    /usr/bin/chromium
    /usr/bin/google-chrome
  ])
end

def chrome_service
  Selenium::WebDriver::Chrome::Service.new(path: chromedriver_path)
end

def chromedriver_path
  ENV['CHROMEDRIVER_PATH'].presence || executable_path(%w[
    /usr/bin/chromedriver
    /snap/bin/chromium.chromedriver
  ])
end

def chrome_arguments(headless:)
  %w[--window-size=1920,1080 --no-sandbox --disable-dev-shm-usage].tap do |arguments|
    arguments.unshift('--headless') if headless
  end
end

def executable_path(paths)
  paths.detect { |path| File.executable?(path) }
end
