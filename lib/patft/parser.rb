require 'date'
require 'nokogiri'

module Patft
  module Parser
    XPATH = {
      number: "//table[@width='100%'][2]/tr[1]/td[@align='right']/b/text()[1]",
      title: '//body/font[1]/text()',
      issue_date: "//table[@width='100%'][2]/tr[2]/td[@align='right']/b[1]/text()"
    }

    def self.parse(html)
      html = Nokogiri::HTML(html)
      parsed = {
        number: extract(:number, html),
        title:  extract(:title, html),
        issue_date:  extract(:issue_date, html)
      }
    end

    private

    # TODO: clean this mess up using #send
    def self.extract(key, html)
      extracted = nil
      if key == :number
        extracted = html.xpath(XPATH[:number]).text.delete(',')
      elsif key == :title
        extracted = html.xpath(XPATH[:title]).text.gsub(/^\s|\s$/, '').gsub(/\s{2,}/, ' ')
      elsif key == :issue_date
        raw_date = html.xpath(XPATH[:issue_date]).text.gsub(/\n|\s{2,}/, '')
        extracted = Date.parse(raw_date)
      end
      extracted
    end
  end
end
