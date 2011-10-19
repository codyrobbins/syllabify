# encoding: UTF-8

require('yaml')

module CodyRobbins
  module Syllabify
    def initialize(language, transcription)
      directory = File.dirname(__FILE__)
      inventory_file = "#{directory}/../languages/#{language}.yml"

      inventory = YAML.load_file(inventory_file)
      inventory = HashWithIndifferentAccess.new(inventory)
      inventory = inventory[:en]

      tokens = inventory[:consonants] + inventory[:nuclei]

      regex = tokens.join('|')
      regex = Regexp.new("[ˈˌ]?(?:#{regex})")

      phonemes = transcription.scan(regex)

      syllables = []
      coda_and_onset = []

      phonemes.each do |phoneme|

#puts("Phoneme: #{phoneme}")

        phoneme.strip!

        next if phoneme.blank?

        @stress = nil

        if ['ˈ', 'ˌ'].include?(phoneme[0])
          @stress = phoneme[0]
          phoneme = phoneme[1..-1]
        end

if @stress
#puts("  Phoneme: #{phoneme}")
#puts("  Stress: #{@stress}")
end

        if inventory[:nuclei].include?(phoneme)

#puts("  It's a vowel--splitting coda and onset...")
#puts("    Coda and onset: #{coda_and_onset}")

          if coda_and_onset.include?('.')
            midpoint = coda_and_onset.index('.')

#puts("    Splitting: #{coda_and_onset}")
#puts("           At: #{midpoint}")

            coda = coda_and_onset[0, midpoint]
            onset = coda_and_onset[midpoint, coda_and_onset.length]

#puts("      Provisional coda: #{coda}")
#puts("      Provisional onset: #{onset}")

          else
            coda_and_onset.each_with_index do |character, midpoint|
#puts("    Splitting: #{coda_and_onset}")
#puts("           At: #{midpoint}")

              coda = coda_and_onset[0, midpoint]
              onset = coda_and_onset[midpoint, coda_and_onset.length]

#puts("      Provisional coda: #{coda}")
#puts("      Provisional onset: #{onset}")

              if inventory[:onsets].include?(onset.join('')) || syllables.empty? || onset.empty?
#puts("      Works!!!")
                break
              end
            end
          end

          unless syllables.empty?
            syllables.last[:coda] += coda.try(:join, '').to_s
          end

          syllables << {:stress  => @stress,
                        :onset   => onset.try(:join, '').to_s,
                        :nucleus => phoneme,
                        :coda    => ''}

          coda_and_onset = []
        elsif !inventory[:consonants].include?(phoneme) && phoneme != '.'
          raise("Invalid phoneme #{phoneme}")
        else
          coda_and_onset << phoneme
#puts("  It's a consonant--appending to coda and onset...")
#puts("    Coda and onset: #{coda_and_onset}")
        end
      end

      unless coda_and_onset.empty?
        if syllables.empty?
          syllables << {:onset => coda_and_onset.join('')}
        else
          syllables.last[:coda] += coda_and_onset.join('')
        end
      end

#puts syllables.inspect

      syllables
    end

    def to_s
      syllables.collect do |syllable|
        stress  = syllable[:stress]
        onset   = syllable[:onset]
        nucleus = syllable[:nucleus]
        coda    = syllable[:coda]

        "#{stress}#{onset}#{nucleus}#{coda}"
      end.join('.')
    end
  end
end

#puts CodyRobbins::Syllabify.new(:en, 'kˈɔrt͡ʃˌɪp').inspect
#puts
#
#puts CodyRobbins::Syllabify.new(:en, 'blˈæstfˌɚnəs').inspect
#puts
#
#puts CodyRobbins::Syllabify.new(:en, 'nˈʌtʃˌɛl').inspect
#puts
#
#puts CodyRobbins::Syllabify.new(:en, 'dɪsˌɔrgənəzˈeɪʃən').inspect
#puts
