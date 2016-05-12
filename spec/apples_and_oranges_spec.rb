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
    @fruit = ApplesAndOranges.new
  end

  describe '#determine_screenshot_path' do
    it 'constructs the screenshot path from the example object' do

      example = Struct::Example.new('./spec/mozart/die_zauberflote_spec.rb:7')
      expect(@fruit.determine_screenshot_path(example)).to eq 'spec/fixtures/ao_screenshots/mozart/die_zauberflote_spec_ao_screenshot_7.jpg'
    end
  end

  describe '#do_comparison' do
    it 'confirms that two identical images are the same' do
      example_screenshot = 'spec/fixtures/mozart-left-1.png'
      baseline_screenshot = 'spec/fixtures/mozart-left.png'
      expect(@fruit.do_comparison(example_screenshot, baseline_screenshot)).to eq true
    end

    it 'acknowledges when two images are different' do
      example_screenshot = 'spec/fixtures/mozart-right.png'
      baseline_screenshot = 'spec/fixtures/mozart-left.png'
      expect(@fruit.do_comparison(example_screenshot, baseline_screenshot)).to eq false
    end
  end

  describe '#screenshot_exists?' do
    it 'confirms that the screenshot exists' do
      example = Struct::Example.new('./spec/mozart/mozart_spec.rb:9')
      expect(@fruit.screenshot_exists?(example)).to eq true
    end

    it 'acknowledges when a screenshot does not exist' do
      example = Struct::Example.new('./spec/mozart/mozart_spec.rb:15')
      expect(@fruit.screenshot_exists?(example)).to eq false
    end
  end

  describe '#generate_screenshot' do
    it 'generates a screenshot' do
      example = Struct::Example.new('./spec/mozart/mozart_spec.rb:15')
      test_page = File.absolute_path("spec/fixtures/pages/index.html")
      visit('file://' + test_page)
      path = 'spec/fixtures/screenshots/test.jpg'
      @fruit.generate_screenshot(page, path)
      expect(File.exist?('spec/fixtures/screenshots/test.jpg')).to eq true
      File.delete('spec/fixtures/screenshots/test.jpg')
    end
  end
end
