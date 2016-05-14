require 'apples_and_oranges'
require 'capybara'
require 'capybara-screenshot'
require 'capybara/rspec'

Capybara.configure do |config|
  config.default_driver = :selenium
end

RSpec.describe ApplesAndOranges do
  include Capybara::DSL

  Struct.new('Example', :location)

  before(:all) do
    @grocer = ApplesAndOranges.new
  end

  describe '#determine_screenshot_path' do
    it 'constructs the screenshot path from the example object' do
      example = Struct::Example.new('./spec/mozart/die_zauberflote_spec.rb:7')
      expect(@grocer.determine_screenshot_path(example)).to eq 'spec/fixtures/ao_screenshots/mozart/die_zauberflote_spec_ao_screenshot_7.jpg'
    end
  end

  describe '#do_comparison' do
    it 'confirms that two identical images are the same' do
      example_screenshot_path = 'spec/fixtures/mozart-left-1.png'
      baseline_screenshot_path = 'spec/fixtures/mozart-left.png'
      expect(@grocer.do_comparison(baseline_screenshot_path, example_screenshot_path)).to eq true
    end

    it 'acknowledges when two images are different' do
      example_screenshot_path = 'spec/fixtures/mozart-right.png'
      baseline_screenshot_path = 'spec/fixtures/mozart-left.png'
      expect(@grocer.do_comparison(baseline_screenshot_path, example_screenshot_path)).to eq false
    end
  end

  describe '#screenshot_exists?' do
    it 'confirms that the screenshot exists' do
      example = Struct::Example.new('./spec/mozart/mozart_spec.rb:9')
      expect(@grocer.screenshot_exists?(example)).to eq true
    end

    it 'acknowledges when a screenshot does not exist' do
      example = Struct::Example.new('./spec/mozart/mozart_spec.rb:15')
      expect(@grocer.screenshot_exists?(example)).to eq false
    end
  end

  describe '#generate_screenshot' do
    it 'generates a screenshot' do
      example = Struct::Example.new('./spec/mozart/mozart_spec.rb:15')
      test_page = File.absolute_path("spec/fixtures/pages/index.html")
      visit('file://' + test_page)
      path = 'spec/fixtures/screenshots/test.jpg'
      @grocer.generate_screenshot(page, path)
      expect(File.exist?('spec/fixtures/screenshots/test.jpg')).to eq true
      File.delete('spec/fixtures/screenshots/test.jpg')
    end
  end

  describe '#folder_exists?' do
    it 'checks if a folder exists' do
      example = Struct::Example.new('./spec/mozart/die_zauberflote_spec.rb:10')
      expect(@grocer.folder_exists?(example)).to eq true
    end

    it 'checks if a folder exists' do
      example = Struct::Example.new('./spec/wolfgang/die_zauberflote_spec.rb:15')
      expect(@grocer.folder_exists?(example)).to eq false
    end
  end

  describe '#create_folder' do
    it 'does nothing if the folder already exists' do
      example = Struct::Example.new('./spec/mozart/die_zauberflote_spec.rb:10')
      expect(@grocer.create_folder(example)).to eq false
    end

    it 'creates a folder if it does not exist' do
      example = Struct::Example.new('./spec/da_ponte/cosi_fan_tutte_spec.rb:10')
      expect(@grocer.create_folder(example)).to eq true
      Dir.rmdir('spec/fixtures/ao_screenshots/da_ponte')
    end
  end

  describe '#check_screenshot' do
    it 'creates a screenshot if none exists and returns false' do |example|
      test_page = File.absolute_path("spec/fixtures/pages/index-no-screenshot.html")
      visit('file://' + test_page)
      expect(@grocer.check_screenshot(page, example)).to eq false
      File.delete('spec/fixtures/ao_screenshots/apples_and_oranges_spec_ao_screenshot_90.jpg')
    end

    it 'compares a screenshot if it exists and returns true when they match' do |example|
      test_page = File.absolute_path("spec/fixtures/pages/index-no-screenshot.html")
      visit('file://' + test_page)
      expect(@grocer.check_screenshot(page, example)).to eq true
    end

    it 'compares a screenshot if it exists and returns false when they do not match' do |example|
      test_page = File.absolute_path("spec/fixtures/pages/index-screenshot.html")
      visit('file://' + test_page)
      expect(@grocer.check_screenshot(page, example)).to eq false
      expect(File.exist?('spec/fixtures/ao_screenshots/apples_and_oranges_spec_ao_screenshot_103.jpg')).to eq true
    end
  end
end
