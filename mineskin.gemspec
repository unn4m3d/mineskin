require_relative 'lib/mineskin/version'

Gem::Specification.new do |s|
  s.name = 'mineskin'
  s.version = MineSkin::VERSION
  s.licenses = ['MIT']
  s.summary = 'A tool to manipulate minecraft skins'
  s.description = 'A tool to manipulate minecraft skins'
  s.authors = ['Stepan Melnikov']
  s.email = 'smelnikov871@gmail.com'
  s.files = Dir.glob('lib/**/*.rb')
  s.homepage = 'https://github.com/unn4m3d/mineskin'
  s.add_runtime_dependency 'rmagick'
end
