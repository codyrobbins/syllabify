# encoding: UTF-8

module CodyRobbins
  class Syllabify
    def initialize(language, transcription)
      set_language(language)
      set_transcription(transcription)
      initialize_coda_and_onset
    end

    def to_s
      syllables_as_strings.join(SYLLABLE_DELIMETER)
    end

    protected

    attr_reader(:language,
                :transcription,
                :coda_and_onset,
                :phoneme,
                :stress,
                :coda,
                :onset)

    SYLLABLE_DELIMETER = '.'

    def set_language(language)
      @language = language
    end

    def set_transcription(transcription)
      @transcription = transcription
    end

    def initialize_coda_and_onset
      @coda_and_onset = []
    end

    def syllables_as_strings
      syllables.collect(&:to_s)
    end

    def join(array)
      array.join('')
    end

    def phonemes
      transcription.scan(transcription_tokenizing_regex)
    end

    def transcription_tokenizing_regex
      Regexp.new("[ˈˌ]?(?:#{all_phonemes_disjunction})")
    end

    def all_phonemes_disjunction
      all_phonemes.join('|')
    end

    def all_phonemes
      phoneme_inventory[:consonants] + phoneme_inventory[:nuclei]
    end

    def phoneme_inventory
      HashWithIndifferentAccess.new(phoneme_inventory_yaml)
    end

    def phoneme_inventory_yaml
      YAML.load_file(phoneme_inventory_file)
    end

    def phoneme_inventory_file
      "#{this_directory}/../../languages/#{language}.yml"
    end

    def this_directory
      File.dirname(this_file)
    end

    def this_file
      __FILE__
    end

    def syllables
      @syllables ||= build_syllables
    end

    def build_syllables
      initialize_syllables
      process_each_phoneme
      process_remaining_coda_and_onset_if_present
      return_syllables
    end

    def initialize_syllables
      @syllables = []
    end

    def process_each_phoneme
      phonemes.each do |phoneme|
        set_phoneme(phoneme)
        strip_phoneme_and_process
      end
    end

    def strip_phoneme_and_process
      strip_phoneme
      process_phoneme_unless_blank
    end

    def set_phoneme(phoneme)
      @phoneme = phoneme
    end

    def strip_phoneme
      @phoneme.strip!
    end

    def process_phoneme_unless_blank
      process_phoneme unless phoneme_blank?
    end

    def phoneme_blank?
      phoneme.blank?
    end

    def process_phoneme
      initialize_stress
      remove_stress_from_phoneme_if_stressed
      categorize_phoneme
    end

    def initialize_stress
      set_stress(nil)
    end

    def set_stress(stress)
      @stress = stress
    end

    def remove_stress_from_phoneme_if_stressed
      remove_stress_from_phoneme if phoneme_has_stress?
    end

    def phoneme_has_stress?
      phoneme_has_primary_stress? || phoneme_has_secondary_stress?
    end

    def phoneme_has_primary_stress?
      first_character_of_phoneme == PRIMARY_STRESS_MARKER
    end

    def phoneme_has_secondary_stress?
      first_character_of_phoneme == SECONDARY_STRESS_MARKER
    end

    PRIMARY_STRESS_MARKER = 'ˈ'
    SECONDARY_STRESS_MARKER = 'ˌ'

    def first_character_of_phoneme
      phoneme[0]
    end

    def remove_stress_from_phoneme
      set_stress_to_first_character_of_phoneme
      set_phoneme_to_remaining_characters_of_phoneme
    end

    def set_stress_to_first_character_of_phoneme
      set_stress(first_character_of_phoneme)
    end

    def set_phoneme_to_remaining_characters_of_phoneme
      set_phoneme(remaining_characters_of_phoneme)
    end

    def remaining_characters_of_phoneme
      phoneme[1..-1]
    end

    def categorize_phoneme
      if nucleus?
        assemble_syllable
      elsif not_consonant_or_syllable_delimeter?
        raise_invalid_phoneme_exception
      else
        add_phoneme_to_coda_and_onset
      end
    end

    def nucleus?
      nuclei.include?(phoneme)
    end

    def nuclei
      phoneme_inventory[:nuclei]
    end

    def assemble_syllable
      split_coda_and_onset
      append_coda_to_last_syllable_unless_no_syllables?
      append_new_syllable
      initialize_coda_and_onset
    end

    def split_coda_and_onset
      if coda_and_onset_include_syllable_delimeter?
        split_coda_and_onset_at_syllable_delimeter
      else
        split_coda_and_onset_at_largest_valid_onset
      end
    end

    def coda_and_onset_include_syllable_delimeter?
      coda_and_onset.include?(SYLLABLE_DELIMETER)
    end

    def split_coda_and_onset_at_syllable_delimeter
      split_coda_and_onset_at(coda_and_onset_syllable_delimiter_position)
    end

    def coda_and_onset_syllable_delimiter_position
      coda_and_onset.index(SYLLABLE_DELIMETER)
    end

    def split_coda_and_onset_at(midpoint)
      split_coda(midpoint)
      split_onset(midpoint)
    end

    def split_coda(midpoint)
      set_coda(join(coda_from_coda_and_onset(midpoint)))
    end

    def set_coda(coda)
      @coda = coda
    end

    def coda_from_coda_and_onset(midpoint)
      coda_and_onset[0, midpoint]
    end

    def split_onset(midpoint)
      set_onset(join(onset_from_coda_and_onset(midpoint)))
    end

    def set_onset(onset)
      @onset = onset
    end

    def onset_from_coda_and_onset(midpoint)
      coda_and_onset[midpoint, coda_and_onset.length]
    end

    def split_coda_and_onset_at_largest_valid_onset
      coda_and_onset.each_with_index do |character, midpoint|
        split_coda_and_onset_at(midpoint)
        break if onset_or_start_of_word?(onset)
      end
    end

    def onset_or_start_of_word?(onset)
      onset?(onset) || start_of_word?
    end

    def onset?(string)
      onsets.include?(string)
    end

    def onsets
      phoneme_inventory[:onsets]
    end

    def no_syllables?
      syllables.empty?
    end
    alias :start_of_word? :no_syllables?

    def append_coda_to_last_syllable_unless_no_syllables?
      append_coda_to_last_syllable unless no_syllables?
    end

    def append_coda_to_last_syllable
      last_syllable.append_coda(coda)
    end

    def last_syllable
      @syllables.last
    end

    def append_new_syllable
      create_syllable(onset, phoneme)
    end

    def create_syllable(onset, nucleus = nil)
      @syllables << new_syllable(onset, nucleus)
    end

    def new_syllable(onset, nucleus)
      Syllable.new(@stress,
                   onset,
                   nucleus)
    end

    def not_consonant_or_syllable_delimeter?
      !consonant_or_syllable_delimeter?
    end

    def consonant_or_syllable_delimeter?
      consonant? || syllable_delimeter?
    end

    def consonant?
      consonants.include?(phoneme)
    end

    def consonants
      phoneme_inventory[:consonants]
    end

    def syllable_delimeter?
      phoneme == SYLLABLE_DELIMETER
    end

    def raise_invalid_phoneme_exception
      raise(invalid_phoneme_error)
    end

    def invalid_phoneme_error
      "Invalid phoneme: #{phoneme}"
    end

    def add_phoneme_to_coda_and_onset
      @coda_and_onset << phoneme
    end

    def coda_and_onset_empty?
      coda_and_onset.empty?
    end

    def create_syllable_from_coda_and_onset
      create_syllable(coda_and_onset_joined)
    end

    def append_coda_and_onset_to_last_syllable
      last_syllable.append_coda(coda_and_onset_joined)
    end

    def coda_and_onset_joined
      join(coda_and_onset)
    end

    def process_remaining_coda_and_onset_if_present
      process_remaining_coda_and_onset unless coda_and_onset_empty?
    end

    def process_remaining_coda_and_onset
      if no_syllables?
        create_syllable_from_coda_and_onset
      else
        append_coda_and_onset_to_last_syllable
      end
    end

    def return_syllables
      @syllables
    end
  end
end
