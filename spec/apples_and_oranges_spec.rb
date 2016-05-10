require 'apples_and_oranges'

RSpec.describe ApplesAndOranges do
  describe '#determine_screenshot_path' do
    it 'constructs the screenshot path from the example object' do
      fruit = ApplesAndOranges.new
      Struct.new('Example', :location)
      example = Struct::Example.new('./spec/mozart/die_zauberflote_spec.rb:7')
      expect(fruit.determine_screenshot_path(example)).to eq '/spec/ao_screenshots/mozart/die_zauberflote_spec_ao_screenshot_7.jpg'
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
end
