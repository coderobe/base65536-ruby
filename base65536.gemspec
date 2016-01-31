Gem::Specification.new do |s|
  s.name        = 'base65536'
  s.version     = '1.0.0'
  s.date        = '2016-01-31'
  s.summary     = "Successor of Base64 utilizing unicode"
  s.description = "Base65536 is used to encode arbitrary binary data as 'plain' text using a safe, hardcoded set of unicode characters"
  s.authors     = ["coderobe", "nilsding", "pixeldesu"]
  s.email       = 'team@nightb.ug'
  s.require_paths = ["lib"]
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage    = 'https://github.com/Nightbug/base65536-ruby'
  s.license     = 'AGPL-3.0'
end
