# -*- encoding: utf-8 -*-
require File.expand_path('../lib/opendns-dnsdb/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Frank Denis"]
  gem.email         = ["frank@opendns.com"]
  gem.description   = "Client library for the OpenDNS Security Graph"
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/jedisct1/opendns-dnsdb-ruby"
  
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "opendns-dnsdb"
  gem.require_paths = ["lib"]
  gem.version       = OpenDNS::DNSDB::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '>= 2.14'
end
