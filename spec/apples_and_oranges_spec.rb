require 'apples_and_oranges'

RSpec.describe ApplesAndOranges do

  Struct.new('Example', :location)

  describe '#determine_screenshot_path' do
    it 'constructs the screenshot path from the example object' do
      fruit = ApplesAndOranges.new
      example = Struct::Example.new('./spec/mozart/die_zauberflote_spec.rb:7')
      expect(fruit.determine_screenshot_path(example)).to eq 'spec/fixtures/ao_screenshots/mozart/die_zauberflote_spec_ao_screenshot_7.jpg'
    end
  end

  describe '#do_comparison' do
    it 'confirms that two identical images are the same' do
      fruit = ApplesAndOranges.new
      example_screenshot = 'spec/fixtures/mozart-left-1.png'
      baseline_screenshot = 'spec/fixtures/mozart-left.png'
      expect(fruit.do_comparison(example_screenshot, baseline_screenshot)).to eq true
    end

    it 'acknowledges when two images are different' do
      fruit = ApplesAndOranges.new
      example_screenshot = 'spec/fixtures/mozart-right.png'
      baseline_screenshot = 'spec/fixtures/mozart-left.png'
      expect(fruit.do_comparison(example_screenshot, baseline_screenshot)).to eq false
    end
  end

  describe '#screenshot_exists?' do
    it 'confirms that the screenshot exists' do
      fruit = ApplesAndOranges.new
      example = Struct::Example.new('./spec/mozart/mozart_spec.rb:9')
      expect(fruit.screenshot_exists?(example)).to eq true
    end

    it 'acknowledges when a screenshot does not exist' do
      fruit = ApplesAndOranges.new
      example = Struct::Example.new('./spec/mozart/mozart_spec.rb:15')
      expect(fruit.screenshot_exists?(example)).to eq false
    end
  end

  describe '#screenshot_driver' do
    it 'returns the default symbol unless another driver has been set' do
      expect(ApplesAndOranges.screenshot_driver).to eq :default
    end

    it 'returns a different symbol if the driver has changed' do
      ApplesAndOranges.screenshot_driver = :poltergeist
      expect(ApplesAndOranges.screenshot_driver).to eq :poltergeist
    end
  end
end
