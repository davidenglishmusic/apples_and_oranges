Gem::Specification.new do |s|
  s.name        = 'apples_and_oranges'
  s.version     = '0.0.0'
  s.date        = '2016-05-08'
  s.summary     = 'Screenshot comparison testing'
  s.authors     = ['David English']
  s.email       = 'contactdavidenglish@gmail.com'
  s.files       = ['lib/apples_and_oranges.rb']
  s.homepage    = 'https://github.com/davidenglishmusic/apples_and_oranges'
  s.license     = 'MIT'

  s.add_dependency 'rmagick', '~> 2.15.4'
  s.add_dependency 'capybara-screenshot', '~> 1.0.12'
  s.add_dependency 'poltergeist', '~> 1.9.0'

  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'capybara', '~> 2.7.1'
end
