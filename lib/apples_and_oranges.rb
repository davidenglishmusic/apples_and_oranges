require 'rmagick'
require 'fileutils'

class ApplesAndOranges
  PATH_REGEX = Regexp.new('/spec/(.*).rb')
  LINE_REGEX = Regexp.new(':(.+)')
  FOLDER_REGEX = Regexp.new('^.*\/\s*')

  def check_screenshot(page, example)
    if screenshot_exists?(example)
      baseline_screenshot_path = determine_screenshot_path(example)
      example_screenshot_path = determine_screenshot_path(example, true)
      generate_screenshot(page, example_screenshot_path)
      result = do_comparison(baseline_screenshot_path, example_screenshot_path)
      FileUtils.rm(example_screenshot_path)
      result
    else
      puts 'no screenshot found - generating...'
      path = determine_screenshot_path(example)
      generate_screenshot(page, path)
      false
    end
  end

  def screenshot_exists?(example)
    File.exist? determine_screenshot_path(example)
  end

  def generate_screenshot(page, path)
    Capybara::Screenshot.registered_drivers.fetch(Capybara.default_driver).call(page.driver, path)
  end

  def do_comparison(baseline_screenshot_path, example_screenshot_path)
    apple = Magick::Image.read(example_screenshot_path).first.export_pixels.join
    orange = Magick::Image.read(baseline_screenshot_path).first.export_pixels.join
    Digest::MD5.hexdigest(apple) == Digest::MD5.hexdigest(orange)
  end

  def determine_screenshot_path(example, temp = false)
    path = 'spec/fixtures/ao_screenshots/' + example.location.match(PATH_REGEX)[1] + '_ao_screenshot_' +
      example.location.match(LINE_REGEX)[1]
    path += '-temp' if temp
    path += '.jpg'
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
