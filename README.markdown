Syllabify
=========

A Ruby port of the [Penn Phonetic Toolkit](http://www.ling.upenn.edu/phonetics/p2tk/) (P2TK) [syllabifier](https://p2tk.svn.sourceforge.net/svnroot/p2tk/python/syllabify/). Unlike the P2TK syllabifier, this implementation works on transcriptions in [IPA](http://en.wikipedia.org/wiki/International_Phonetic_Alphabet) rather than [Arpabet](http://en.wikipedia.org/wiki/Arpabet). Given a phonemic transcription in IPA, it automatically segments the phonemes into [syllables](http://en.wikipedia.org/wiki/Syllable).

Like the P2TK syllabifier, a [phoneme](http://en.wikipedia.org/wiki/Phoneme) inventory containing the legal [consonants](http://en.wikipedia.org/wiki/Consonant), [nuclei](http://en.wikipedia.org/wiki/Syllable#Nucleus) (typically the language’s vowels), and [onsets](http://en.wikipedia.org/wiki/Syllable#Onset) in the transcribed language must be created. This inventory is specified as plain text in YAML and a default phoneme inventory for English from the P2TK syllabifier is included. If you create inventories for other languages, please submit a pull request (or simply email it to me if you’re not a techie) and I will include it in subsequent releases of the gem.

Full documentation is at [RubyDoc.info](http://rubydoc.info/gems/syllabify).

Transcription constraints
-------------------------

Any phonemes represented in IPA by [digraphs](http://en.wikipedia.org/wiki/Digraph_\(orthography\)) (such as [affricates](http://en.wikipedia.org/wiki/Affricate_consonant), [doubly-articulated consonants](http://en.wikipedia.org/wiki/Doubly_articulated_consonant), and [diphthongs](http://en.wikipedia.org/wiki/Diphthong)) must be transcribed using a [tie](http://en.wikipedia.org/wiki/Tie_\(typography\)), otherwise there is no way to distinguish them from the phonemes of their individual components and syllabification will be incorrect in some cases.

For example, in English transcriptions the [voiceless postalveolar affricate](http://en.wikipedia.org/wiki/Voiceless_postalveolar_affricate) is customarily transcribed without the tie. For the purposes of syllabification, however, this is problematic because in English /t͡ʃ/ is a legal onset but /tʃ/ is not. If the English voiceless postalveolar affricate were to be transcribed without the tie as /tʃ/ then it would have to be included in the inventory of onsets, but doing so would cause the phoneme sequence /t/ followed by /ʃ/ to also be interpreted as an onset—which it isn’t. In this case, without the tie transcriptions where /tʃ/ represents two different phonemes rather than one—such as in *nutshell* /nʌtʃɛl/—will be incorrectly syllabified as /nʌ.tʃɛl/ rather than /nʌt.ʃɛl/. Similarly, without a tie it’s not possible to determine whether the diphthong /ɔɪ/ in *clawing* /klɔɪŋ/ is one or two separate phonemes.

In other words, tie glyphs together if they represent the same phoneme. The only digraphs requiring ties in English are the voiced and voiceless postalveolar affricates /t͡ʃ, d͡ʒ/ and the diphthongs /a͡ʊ, a͡ɪ, e͡ɪ, o͡ʊ, ɔ͡ɪ/.

### How to enter ties

The tie is represented in Unicode by [Combining Double Inverted Breve (U+0361)](http://www.unicode.org/charts/PDF/U0300.pdf). This character is entered between the two characters to be tied.

### Ligatures

Phonemes that require transcription with ties could potentially be alternatively transcribed using their respective [ligatures](http://en.wikipedia.org/wiki/Typographic_ligature), but glyphs for all the potential ligatures aren’t defined in Unicode and use of the ligatures is no longer official IPA usage in any case.

Example
-------

    transcription = CodyRobbins::Syllabify.new(:en, 'dɪˌsɔrgənəˈze͡ɪʃən')

    transcription.to_s      #=> 'dɪ.ˌsɔr.gə.nə.ˈze͡ɪ.ʃən'
    transcription.syllables #=> [dɪ, ˌsɔr, gə, nə, ˈze͡ɪ, ʃən]

    syllable = transcription.syllables[4]
    syllable.stress  #=> 'ˈ'
    syllable.onset   #=> 'z'
    syllable.nucleus #=> 'e͡ɪ'
    syllable.coda    #=> ''

    syllable = transcription.syllables.last
    syllable.stress  #=> nil
    syllable.onset   #=> 'ʃ'
    syllable.nucleus #=> 'ə'
    syllable.coda    #=> 'n'

Colophon
--------

### See also

If you like this gem, you may also want to check out [transliterate](http://codyrobbins.com/software/transliterate).

### Tested with

* Ruby 1.9.2-p290 — 18 October 2011

### Contributing

* [Source](https://github.com/codyrobbins/syllabify)
* [Bug reports](https://github.com/codyrobbins/syllabify/issues)

To send patches, please fork on GitHub and submit a pull request.

### Credits

© 2011 [Cody Robbins](http://codyrobbins.com/). See LICENSE for details.

* [Homepage](http://codyrobbins.com/software/syllabify)
* [My other gems](http://codyrobbins.com/software#gems)
* [Follow me on Twitter](http://twitter.com/codyrobbins)