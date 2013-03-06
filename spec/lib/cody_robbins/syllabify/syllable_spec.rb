# encoding: UTF-8

require('spec_helper')

describe CodyRobbins::Syllabify::Syllable do
  def syllable
    described_class.new('a', 'b', 'c', 'd')
  end

  describe 'string representation' do
    it { syllable.to_s.should == 'abcd' }
  end

  describe 'stress' do
    it { syllable.stress.should == 'a' }
  end

  describe 'onset' do
    it { syllable.onset.should == 'b' }
  end

  describe 'nucleus' do
    it { syllable.nucleus.should == 'c' }
  end

  describe 'coda' do
    it { syllable.coda.should == 'd' }
  end

  describe 'appends coda' do
    def syllable_with_coda
      syllable.tap do |syllable|
        syllable.append_coda('e')
      end
    end

    it { syllable_with_coda.coda.should == 'de' }
  end
end
