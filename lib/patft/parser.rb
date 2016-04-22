require 'nokogiri'

module Patft
  module Parser
    XPATH = {
      number: "//table[@width='100%'][2]/tr[1]/td[@align='right']/b/text()[1]",
      title: '//body/font[1]/text()'
    }

    def self.parse(html)
      html = Nokogiri::HTML(html)
      parsed = {
        number: extract(:number, html),
        title:  extract(:title, html)
      }
    end

    private

    def self.extract(key, html)
      if key == :number
        return html.xpath(XPATH[:number]).text.delete(',')
      elsif key == :title
        return html.xpath(XPATH[:title]).text.gsub(/^\s|\s$/, '').gsub(/\s{2,}/, ' ')
      end
    end
  end
end
