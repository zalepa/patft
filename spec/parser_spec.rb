require 'spec_helper'
require 'date'
require 'yaml'

include Patft

describe Parser do

  describe 'Exemplary Patent (U.S. Pat. No. 6000000)' do
    let(:html) { File.read(File.dirname(__FILE__) + '/fixtures/6000000.html') }
    let(:parsed) { Parser.parse(html) }
    let(:expected) { YAML.load_file(File.dirname(__FILE__) + '/fixtures/6000000.yaml')}

    it 'extracts a patent number' do
      expect(parsed).to have_key(:number)
      expect(parsed[:number]).to eq(expected['number'])
    end

    it 'extracts a title' do
      expect(parsed).to have_key(:title)
      expect(parsed[:title]).to eq(expected['title'])
    end

    it 'extracts an issue date' do
      expect(parsed).to have_key(:issue_date)
      expect(parsed[:issue_date]).to be_a(Date)
      expect(parsed[:issue_date]).to eq(Date.parse(expected['issue_date']))
    end

    it 'extracts an abstract' do
      expect(parsed).to have_key(:abstract)
      expect(parsed[:abstract]).to be_a(String)
      expect(parsed[:abstract]).to eq(expected['abstract'])
    end

    # TODO: serious clean up
    it 'extracts inventors' do
      expect(parsed).to have_key(:inventors)
      expect(parsed[:inventors]).to be_an(Array)
      expect(parsed[:inventors].length).to eq(2)
      expect(parsed[:inventors][0]).to have_key(:name)
      expect(parsed[:inventors][0]).to have_key(:residence)
    end

    it 'extracts a filing date' do
      expect(parsed).to have_key(:filing_date)
      expect(parsed[:filing_date]).to be_a(Date)
      expect(parsed[:filing_date]).to eq(Date.parse(expected['filing_date']))
    end

    it 'extracts an assignee' do
      expect(parsed).to have_key(:assignee)
      expect(parsed[:assignee]).to be_a(Hash)
      expect(parsed[:assignee]).to have_key(:name)
      expect(parsed[:assignee]).to have_key(:location)
      expect(parsed[:assignee][:name]).to eq(expected['assignee']['name'])
      expect(parsed[:assignee][:location]).to eq(expected['assignee']['location'])
    end

    it 'extracts a family ID' do
      expect(parsed).to have_key(:family_id)
      expect(parsed[:family_id]).to be_a(String)
      expect(parsed[:family_id]).to eq(expected['family_id'])
    end

    it 'extracts a serial number' do
      expect(parsed).to have_key(:serial)
      expect(parsed[:serial]).to be_a(String)
      expect(parsed[:serial]).to eq(expected['serial'])
    end

    it 'extracts US Classifications' do
      expect(parsed).to have_key(:us_classifications)
      expect(parsed[:us_classifications]).to be_an(Array)
      expect(parsed[:us_classifications]).to eq(expected['us_classifications'])
    end

    it 'extracts CPC classes' do
      expect(parsed).to have_key(:cpc_classifications)
      expect(parsed[:cpc_classifications]).to be_an(Array)
      expect(parsed[:cpc_classifications]).to eq(expected['cpc_classifications'])
    end

    it 'extracts international classifications' do
      expect(parsed).to have_key(:international_classifications)
      expect(parsed[:international_classifications]).to be_an(Array)
      expect(parsed[:international_classifications]).to eq(expected['international_classifications'])
    end

    it 'extracts a Field of search' do
      expect(parsed).to have_key(:field_of_search)
      expect(parsed[:field_of_search]).to be_an(Array)
      expect(parsed[:field_of_search]).to eq(expected['field_of_search'])
    end

    # it 'extracts an Primary Examiner'
    # it 'extracts an Attorney/Agent'
    # it 'extracts an Parent Case Text'
    # it 'extracts an Claims'
    # it 'extracts an Description'
    # it 'extracts an References Cited'
    # it 'extracts an Related Patents'
  end
end
