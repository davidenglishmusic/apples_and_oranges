require 'rmagick'

class ApplesAndOranges
  PATH_REGEX = Regexp.new('/spec/(.*).rb')
  LINE_REGEX = Regexp.new(':(.+)')

  def self.compare_screenshots(example)
    p
    if screenshot_exists?(example)
      do_comparison(example)
    else
      p 'no screenshot found - generating...'
      generate_screenshot(example)
      false
    end
  end

  def screenshot_exists?(example)
  end

  def generate_screenshot(example)
  end

  def do_comparison(example_screenshot, baseline_screenshot)
    apple = Magick::Image.read(example_screenshot).first.export_pixels.join
    orange = Magick::Image.read(baseline_screenshot).first.export_pixels.join
    Digest::MD5.hexdigest(apple) == Digest::MD5.hexdigest(orange)
  end

  def determine_screenshot_path(example)
    '/spec/ao_screenshots/' + example.location.match(PATH_REGEX)[1] + '_ao_screenshot_' +
      example.location.match(LINE_REGEX)[1] + '.jpg'
  end
end