require 'apples_and_oranges'

RSpec.describe ApplesAndOranges, '#determine_screenshot_path' do
  it 'constructs the screenshot path from the example object' do
    fruit = ApplesAndOranges.new
    Struct.new('Example', :location)
    example = Struct::Example.new('./spec/mozart/die_zauberflote_spec.rb:7')
    expect(fruit.determine_screenshot_path(example)).to eq '/spec/ao_screenshots/mozart/die_zauberflote_spec_ao_screenshot_7.jpg'
  end
end
