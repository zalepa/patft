require 'spec_helper'
require 'date'
require 'yaml'

include Patft

describe Parser do
  describe 'extracting single values' do
    let(:html) do
      File.read(File.dirname(__FILE__) + '/fixtures/6000000.html')
    end

    let(:expected) do
      YAML.load_file(File.dirname(__FILE__) + '/fixtures/6000000.yaml')
    end

    let(:parser) { Parser.new(html) }

    it 'returns nil if attribute is unknown' do
      unknown = parser.extract(:initialize)
      expect(unknown).to be_nil
    end

    it 'extracts a patent number' do
      title = parser.extract(:title)
      expect(title).to eq(expected['title'])
    end

    it 'extracts a patent number' do
      number = parser.extract(:number)
      expect(number).to eq(expected['number'])
    end

    it 'extracts a title' do
      title = parser.extract(:title)
      expect(title).to eq(expected['title'])
    end

    it 'extracts an issue date' do
      issue_date = parser.extract(:issue_date)
      expect(issue_date).to eq(Date.parse(expected['issue_date']))
    end

    it 'extracts an abstract' do
      abstract = parser.extract(:abstract)
      expect(abstract).to eq(expected['abstract'])
    end

    # TODO: serious clean up
    it 'extracts inventors' do
      inventors = parser.extract(:inventors)
      expect(inventors).to be_an(Array)
      expect(inventors.length).to eq(2)
      expect(inventors[0]).to have_key(:name)
      expect(inventors[0]).to have_key(:residence)
    end

    it 'extracts a filing date' do
      filing_date = parser.extract(:filing_date)
      expect(filing_date).to eq(Date.parse(expected['filing_date']))
    end

    it 'extracts an assignee' do
      assignee = parser.extract(:assignee)
      expect(assignee).to be_a(Hash)
      expect(assignee).to have_key(:name)
      expect(assignee).to have_key(:location)
      expect(assignee[:name]).to eq(expected['assignee']['name'])
      expect(assignee[:location]).to eq(expected['assignee']['location'])
    end

    it 'extracts a family ID' do
      family_id = parser.extract(:family_id)
      expect(family_id).to be_a(String)
      expect(family_id).to eq(expected['family_id'])
    end

    it 'extracts a serial number' do
      serial = parser.extract(:serial)
      expect(serial).to be_a(String)
      expect(serial).to eq(expected['serial'])
    end

    it 'extracts US Classifications' do
      us_classifications = parser.extract(:us_classifications)
      expect(us_classifications).to be_an(Array)
      expect(us_classifications).to eq(expected['us_classifications'])
    end

    it 'extracts CPC classes' do
      cpc_classifications = parser.extract(:cpc_classifications)
      expect(cpc_classifications).to be_an(Array)
      expect(cpc_classifications).to eq(expected['cpc_classifications'])
    end

    it 'extracts international classifications' do
      intl_classes = parser.extract(:international_classifications)
      expect(intl_classes).to be_an(Array)
      expect(intl_classes).to eq(expected['international_classifications'])
    end

    it 'extracts a Field of search' do
      field_of_search = parser.extract(:field_of_search)
      expect(field_of_search).to be_an(Array)
      expect(field_of_search).to eq(expected['field_of_search'])
    end

    it 'extracts a primary examiner' do
      primary_examiner = parser.extract(:primary_examiner)
      expect(primary_examiner).to be_a(String)
      expect(primary_examiner).to eq(expected['primary_examiner'])
    end

    it 'extracts an attorney/agent'
    it 'extracts parent case text'
    it 'extracts claims'
    it 'extracts description'
    it 'extracts references cited'
    it 'extracts related patents'
  end
end
