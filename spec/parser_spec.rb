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

    # it 'extracts an Abstract'
    # it 'extracts an Inventors'
    # it 'extracts an Assignee*'
    # it 'extracts an Family ID'
    # it 'extracts an Serial Number'
    # it 'extracts an Filing Date'
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
