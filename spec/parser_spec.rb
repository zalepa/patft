require 'spec_helper'

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
  end
end
