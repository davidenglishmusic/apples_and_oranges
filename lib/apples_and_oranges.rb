require 'rmagick'
require 'fileutils'

class ApplesAndOranges
  PATH_REGEX = Regexp.new('/spec/(.*).rb')
  LINE_REGEX = Regexp.new(':(.+)')
  FOLDER_REGEX = Regexp.new('^.*\/\s*')

  def compare_screenshots(example)
    if screenshot_exists?(example)
      do_comparison(example)
    else
      puts 'no screenshot found - generating...'
      generate_screenshot(example)
      false
    end
  end

  def screenshot_exists?(example)
    File.exist? determine_screenshot_path(example)
  end

  def generate_screenshot(page, path)
    Capybara::Screenshot.registered_drivers.fetch(Capybara.default_driver).call(page.driver, path)
  end

  def do_comparison(example_screenshot, baseline_screenshot)
    apple = Magick::Image.read(example_screenshot).first.export_pixels.join
    orange = Magick::Image.read(baseline_screenshot).first.export_pixels.join
    Digest::MD5.hexdigest(apple) == Digest::MD5.hexdigest(orange)
  end

  def determine_screenshot_path(example)
    'spec/fixtures/ao_screenshots/' + example.location.match(PATH_REGEX)[1] + '_ao_screenshot_' +
      example.location.match(LINE_REGEX)[1] + '.jpg'
  end

  def create_folder(example)
    return false if folder_exists?(example)
    FileUtils.mkdir_p determine_screenshot_path(example).match(FOLDER_REGEX)[0]
    true
  end

  def folder_exists?(example)
    File.exist? determine_screenshot_path(example).match(FOLDER_REGEX)[0]
  end
end
