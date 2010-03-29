require 'rubygems'
require 'hoe'

Hoe.plugin :doofus, :git

Hoe.spec 'kuler' do
  developer 'Ben Bleything', 'ben@bleything.net'

  self.extra_rdoc_files = Dir['*.rdoc'] + ['LICENSE']
  self.history_file     = 'CHANGELOG.rdoc'
  self.readme_file      = 'README.rdoc'

  self.extra_deps << [ "nokogiri", "~> 1.4.1" ]
  self.extra_dev_deps << [ "mocha", "~> 0.9.8" ]
end
