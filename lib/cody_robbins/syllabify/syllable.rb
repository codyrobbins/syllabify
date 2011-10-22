# encoding: UTF-8

module CodyRobbins
  class Syllabify
    class Syllable
      # Any [stress](http://en.wikipedia.org/wiki/Stress_\(linguistics\)) marks associated with the syllable as a whole.
      attr_reader(:stress)

      # The [onset](http://en.wikipedia.org/wiki/Syllable#Onset) (ω) of the syllable.
      attr_reader(:onset)

      # The [nucleus](http://en.wikipedia.org/wiki/Syllable#Nucleus) (ν) of the syllable.
      attr_reader(:nucleus)

      # The [coda](http://en.wikipedia.org/wiki/Syllable_coda) (κ) of the syllable.
      attr_reader(:coda)

      # @private
      def initialize(stress, onset, nucleus, coda = '')
        set_stress(stress)
        set_onset(onset)
        set_nucleus(nucleus)
        set_coda(coda)
      end

      # Joins the stress, onset, nucleus, and coda to form a single string representation of the [syllable](http://en.wikipedia.org/wiki/Syllable).
      #
      # @return [String]
      #
      # @example
      #    CodyRobbins::Syllabify.new(:en, 'dɪˌsɔrgənəˈze͡ɪʃən').syllables[4].to_s #=> 'ˈze͡ɪ'
      def to_s
        join(stress, onset, nucleus, coda)
      end

      # @private
      def append_coda(coda)
        @coda += coda
      end

      protected

      def set_stress(stress)
        @stress = stress
      end

      def set_onset(onset)
        @onset = onset
      end

      def set_nucleus(nucleus)
        @nucleus = nucleus
      end

      def set_coda(coda)
        @coda = coda
      end

      def join(*components)
        components.join('')
      end
    end
  end
end
