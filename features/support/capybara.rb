# frozen_string_literal: true

require 'webdrivers'
# Webdrivers.logger.level = :debug

# Specific version can be forced when needed
# Webdrivers::Chromedriver.required_version = '74.0.3729.6'
# Webdrivers::Chromedriver.required_version = '73.0.3683.68'
# Webdrivers.install_dir = File.expand_path('~/.webdrivers/' + ENV['TEST_ENV_NUMBER'].to_s)

Capybara.asset_host = 'http://localhost:3000'
Capybara.default_max_wait_time = 5

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(loggingPrefs: { browser: 'ALL' })
  opts = Selenium::WebDriver::Chrome::Options.new

  chrome_args = %w[--headless --window-size=1920,1080 --no-sandbox --disable-dev-shm-usage]
  chrome_args.each { |arg| opts.add_argument(arg) }
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: opts, desired_capabilities: caps)
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

# Webdrivers::Chromedriver.update
# Webdrivers::Geckodriver.update

webdriver_version_files = Dir.entries(Webdrivers.install_dir).select { |entry| entry.include?('.version') }
versions = webdriver_version_files.collect do |version_filename|
  version = File.read(File.join(Webdrivers.install_dir, version_filename))
  "#{version_filename}: #{version}"
end
Rails.logger.debug("\nDownloaded webdrivers [in #{Webdrivers.install_dir}]: #{versions.join(' ; ')}")
