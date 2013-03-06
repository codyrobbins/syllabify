# encoding: UTF-8

require('spec_helper')

describe CodyRobbins::Syllabify do
  def syllabify(string)
    described_class.new(:en, string)
  end

  def disorganization
    syllabify('dɪˌsɔrgənəˈze͡ɪʃən')
  end

  describe 'string representation' do
    it { disorganization.to_s.should == 'dɪ.ˌsɔr.gə.nə.ˈze͡ɪ.ʃən' }

    describe 'with' do
      describe 'untied consonant phonemes' do
        def nutshell
          syllabify('ˈnʌtʃɛl')
        end

        it { nutshell.to_s.should == 'ˈnʌt.ʃɛl' }
      end

      describe 'untied vowel phonemes' do
        def clawing
          syllabify('ˈklɔɪŋ')
        end

        it { clawing.to_s.should == 'ˈklɔ.ɪŋ' }
      end
    end
  end

  describe 'syllables' do
    def syllable(index, attribute)
      disorganization.syllables[index].send(attribute)
    end

    describe 'first' do
      describe 'stress' do
        it { syllable(0, :stress).should be_blank }
      end

      describe 'onset' do
        it { syllable(0, :onset).should == 'd' }
      end

      describe 'nucleus' do
        it { syllable(0, :nucleus).should == 'ɪ' }
      end

      describe 'coda' do
        it { syllable(0, :coda).should be_blank }
      end
    end

    describe 'second' do
      describe 'stress' do
        it { syllable(1, :stress).should == 'ˌ' }
      end

      describe 'onset' do
        it { syllable(1, :onset).should == 's' }
      end

      describe 'nucleus' do
        it { syllable(1, :nucleus).should == 'ɔ' }
      end

      describe 'coda' do
        it { syllable(1, :coda).should == 'r' }
      end
    end

    describe 'third' do
      describe 'stress' do
        it { syllable(2, :stress).should be_blank }
      end

      describe 'onset' do
        it { syllable(2, :onset).should == 'g' }
      end

      describe 'nucleus' do
        it { syllable(2, :nucleus).should == 'ə' }
      end

      describe 'coda' do
        it { syllable(2, :coda).should be_blank }
      end
    end

    describe 'fourth' do
      describe 'stress' do
        it { syllable(3, :stress).should be_blank }
      end

      describe 'onset' do
        it { syllable(3, :onset).should == 'n' }
      end

      describe 'nucleus' do
        it { syllable(3, :nucleus).should == 'ə' }
      end

      describe 'coda' do
        it { syllable(3, :coda).should be_blank }
      end
    end

    describe 'fifth' do
      describe 'stress' do
        it { syllable(4, :stress).should == 'ˈ' }
      end

      describe 'onset' do
        it { syllable(4, :onset).should == 'z' }
      end

      describe 'nucleus' do
        it { syllable(4, :nucleus).should == 'e͡ɪ' }
      end

      describe 'coda' do
        it { syllable(4, :coda).should be_blank }
      end
    end


    describe 'sixth' do
      describe 'stress' do
        it { syllable(5, :stress).should be_blank }
      end

      describe 'onset' do
        it { syllable(5, :onset).should == 'ʃ' }
      end

      describe 'nucleus' do
        it { syllable(5, :nucleus).should == 'ə' }
      end

      describe 'coda' do
        it { syllable(5, :coda).should == 'n' }
      end
    end
  end
end
