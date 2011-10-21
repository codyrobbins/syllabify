module CodyRobbins
  class Syllabify
    class Syllable
      attr_reader(:stress,
                  :onset,
                  :nucleus,
                  :coda)

      def initialize(stress, onset, nucleus, coda = nil)
        set_stress(stress)
        set_onset(onset)
        set_nucleus(nucleus)
        set_coda(coda)
      end

      def to_s
        join(stress, onset, nucleus, coda)
      end

      def append_coda(coda)
        @coda ||= ''
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
