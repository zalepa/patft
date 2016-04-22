require 'spec_helper'
require 'date'

include Patft

describe Parser do

  let(:html) { File.read(File.dirname(__FILE__) + '/fixtures/6000000.html') }
  let(:parsed) { Parser.parse(html) }

  describe 'US Pat. 6000000' do
    it 'extracts a patent number' do
      expect(parsed).to have_key(:number)
      expect(parsed[:number]).to eq('6000000')
    end

    it 'extracts a title' do
      expect(parsed).to have_key(:title)
      expect(parsed[:title]).to eq('Extendible method and apparatus for synchronizing multiple files on two different computer systems')
    end

    it 'extracts an issue date' do
      expect(parsed).to have_key(:issue_date)
      expect(parsed[:issue_date]).to be_a(Date)
      expect(parsed[:issue_date]).to eq(Date.parse('December 7, 1999'))
    end

    it 'extracts an abstract' do
      expect(parsed).to have_key(:abstract)
      expect(parsed[:abstract]).to be_a(String)
      expect(parsed[:abstract]).to eq('Many users of handheld computer systems maintain databases on the handheld computer systems. To share the information, it is desirable to have a simple method of sharing the information with personal computer systems. An easy to use extendible file synchronization system is introduced for sharing information between a handheld computer system and a personal computer system. The synchronization system is activated by a single button press. The synchronization system proceeds to synchronize data for several different applications that run on the handheld computer system and the personal computer system. If the user gets a new application for the handheld computer system and the personal computer system, then a new library of code is added for synchronizing the databases associate with the new application. The synchronization system automatically recognizes the new library of code and uses it during the next synchronization.')
    end
    # it 'extracts an Inventors'
    # it 'extracts an Filing Date'
    # it 'extracts an Assignee*'
    # it 'extracts an Family ID'
    # it 'extracts an Serial Number'
    # it 'extracts an Related Patents'
    # it 'extracts an US Class'
    # it 'extracts an CPC Class'
    # it 'extracts an International Class'
    # it 'extracts an Field of search'
    # it 'extracts an References Cited'
    # it 'extracts an Primary Examiner'
    # it 'extracts an Attorney/Agent'
    # it 'extracts an Parent Case Text'
    # it 'extracts an Claims'
    # it 'extracts an Description'
  end
end
