Syllabify
=========

A Ruby port of the [Penn Phonetic Toolkit](http://www.ling.upenn.edu/phonetics/p2tk/) (P2TK) [syllabifier](https://p2tk.svn.sourceforge.net/svnroot/p2tk/python/syllabify/). Unlike the P2TK syllabifier, this version operates on [IPA](http://en.wikipedia.org/wiki/International_Phonetic_Alphabet) transcriptions rather than [Arpabet](http://en.wikipedia.org/wiki/Arpabet) transcriptions. Given a pohemic transcription of an utterance in IPA, it automatically segments the phonemes into [syllables](http://en.wikipedia.org/wiki/Syllable).

Like the P2TK syllabifier, a [phoneme](http://en.wikipedia.org/wiki/Phoneme) inventory containing the legal [consonants](http://en.wikipedia.org/wiki/Consonant), [nuclei](http://en.wikipedia.org/wiki/Syllable#Nucleus) (typically the language’s vowels), and [onsets](http://en.wikipedia.org/wiki/Syllable#Onset) in the target language must be created. This inventory is specified in plain text in a YAML file, and a default phoneme inventory for English is provided. If you create inventories for other languages, please create a pull request (or simply email it to me if you’re a linguist and don’t get GitHub) and I will include it in the gem.

Full documentation is at [RubyDoc.info](http://rubydoc.info/gems/syllabify).

Transcription pitfalls
----------------------

Any phonemes represented by [digraphs](http://en.wikipedia.org/wiki/Digraph_\(orthography\)) (such as [affricates](http://en.wikipedia.org/wiki/Affricate_consonant) and [doubly-articulated consonants](http://en.wikipedia.org/wiki/Doubly_articulated_consonant)) must be transcribed using a [tie](http://en.wikipedia.org/wiki/Tie_\(typography\)), otherwise there is no way to distinguish them from their individual components and syllabification will be incorrect. For example, in English transcriptions the voiceless postalveolar affricate /tʃ/ is customarily transcribed without the tiebar. For the purposes of syllabification, however, this is problematic because in English /t͡ʃ/ si a legal onset but /tʃ/ is not. If /tʃ/ without the tiebar is used to transcribe the English voiceless postalveolar affricate, then it must be included in the list of onsets for the syllabifier, and

Without the tie, transcriptions where /tʃ/ represents two different phonemes, such as in *nutshell* /nʌtʃɛl/, will be incorrectly syllabified as /nʌ.tʃɛl/ rather than /nʌt.ʃɛl/.

### How to enter ties

For the purposes of entering transcriptions with a tie, the tie is represented in Unicode by [Combining Double Inverted Breve (U+0361)](http://www.unicode.org/charts/PDF/U0300.pdf). This character is entered between the two characters to be tied.

These phonemes can alternatively be transcribed using their respective ligatures, but this is no longer official IPA usage and ligatures are not available for all phonemes.

Example
-------

    transcription = CodyRobbins::Syllabify.new(:en, 'dɪˌsɔrgənəˈzeɪʃən')

    transcription.to_s      #=> 'dɪ.ˌsɔr.gə.nə.ˈzeɪ.ʃən'
    transcription.syllables #=> [{:stress  => nil,
                                  :onset   => 'd',
                                  :nucleus => 'ɪ',
                                  :coda    => nil}]

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