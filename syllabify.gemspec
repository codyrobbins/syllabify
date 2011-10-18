Gem::Specification.new do |s|
  s.name     = 'syllabifier'
  s.version  = '1.0.0'
  s.summary  = 'A Ruby port of the Penn Phonetics Toolkit (P2TK) syllabifier.'
  s.homepage = 'http://codyrobbins.com/software/syllabifier'
  s.author   = 'Cody Robbins'
  s.email    = 'cody@codyrobbins.com'

  s.post_install_message = '
-------------------------------------------------------------
Follow me on Twitter! http://twitter.com/codyrobbins
-------------------------------------------------------------

'

  s.files = `git ls-files`.split
end