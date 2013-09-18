Gem::Specification.new do |s|
  s.name        = 'ulg'
  s.version     = '0.2.6'
  s.date        = '2013-09-18'
  s.summary     = "Ultra Light Graphs"
  s.description = "Ultra Light Graphs - Text editor friendly markup language for creating simple graphs."
  s.authors     = ["Fraser Scott"]
  s.email       = 'fraser.scott@gmail.com'
  s.files       = ["lib/ulg.rb"]
  s.executables << 'ulg'
  s.homepage    = 'https://github.com/zeroXten/ulg'
  s.license     = 'MIT'
  s.requirements << 'ruby-graphviz'
  s.requirements << 'getopt/std'
  s.add_dependency('ruby-graphviz', ">= 1.0.9")
  s.add_dependency('getopt')
end
