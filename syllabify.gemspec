Gem::Specification.new do |s|
  s.name     = 'syllabify'
  s.version  = '1.0.1'
  s.summary  = 'A Ruby port of the Penn Phonetics Toolkit (P2TK) syllabifier.'
  s.homepage = 'http://codyrobbins.com/software/syllabify'
  s.author   = 'Cody Robbins'
  s.email    = 'cody@codyrobbins.com'

  s.post_install_message = '
-------------------------------------------------------------
Follow me on Twitter! http://twitter.com/codyrobbins
-------------------------------------------------------------

'

  s.files = `git ls-files`.split

  s.add_dependency('activesupport')
end