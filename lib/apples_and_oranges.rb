require 'rmagick'
require 'fileutils'

class ApplesAndOranges
  PATH_REGEX = Regexp.new('/spec/(.*).rb')
  LINE_REGEX = Regexp.new(':(.+):')
  FOLDER_REGEX = Regexp.new('^.*\/\s*')

  FUZZY_THRESHOLD = 0.001

  def check_screenshot(page)
    call_location = caller_locations[0].to_s
    screenshot_path = determine_screenshot_path(call_location)
    if screenshot_exists?(screenshot_path)
      temp_screenshot_path = determine_screenshot_path(call_location, temp: true)
      generate_screenshot(page, temp_screenshot_path)
      result = do_comparison(screenshot_path, temp_screenshot_path)
      FileUtils.rm(temp_screenshot_path)
      puts "\nscreenshots did not match\n" if !result
      result
    else
      puts "\nno screenshot found - generating...\n"
      generate_screenshot(page, screenshot_path)
      false
    end
  end

  def screenshot_exists?(example_path)
    File.exist? example_path
  end

  def generate_screenshot(page, path)
    page.save_screenshot(path, full: false)
  end

  def do_comparison(baseline_screenshot_path, example_screenshot_path, strict_comparison: false)
    return compare_using_hexdigest(baseline_screenshot_path, example_screenshot_path) if strict_comparison
    compare_using_channels(baseline_screenshot_path, example_screenshot_path)
  end

  def compare_using_hexdigest(baseline_screenshot_path, example_screenshot_path)
    apple = Magick::Image.read(example_screenshot_path).first.export_pixels.join
    orange = Magick::Image.read(baseline_screenshot_path).first.export_pixels.join
    Digest::MD5.hexdigest(apple) == Digest::MD5.hexdigest(orange)
  end

  def compare_using_channels(baseline_screenshot_path, example_screenshot_path)
    apple = Magick::Image.read(example_screenshot_path).first
    orange = Magick::Image.read(baseline_screenshot_path).first
    diff_img, diff_metric = apple.compare_channel( orange, Magick::MeanSquaredErrorMetric )
    return true if diff_metric < FUZZY_THRESHOLD
    false
  end

  def determine_screenshot_path(call_path, app_path: nil, temp: false)
    app_path = Dir.pwd if app_path.nil?
    call_path.slice!(app_path)
    screenshot_path = 'spec/fixtures/ao_screenshots/' + call_path.match(PATH_REGEX)[1] + '_ao_screenshot_' +
      call_path.match(LINE_REGEX)[1]
    screenshot_path += '-temp' if temp
    screenshot_path += '.jpg'
  end

  def create_folder(folder_path)
    return false if folder_exists?(folder_path)
    FileUtils.mkdir_p folder_path
    true
  end

  def folder_exists?(folder_path)
    File.exist? folder_path
  end
end
