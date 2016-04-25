require 'date'
require 'nokogiri'

module Patft
  module Parser
    XPATH = {
      number: "//table[@width='100%'][2]/tr[1]/td[@align='right']/b/text()[1]",
      title: '//body/font[1]/text()',
      abstract: '/html/body/p[1]/text()',
      inventors: '//th[contains(text(), "Inventors:")]/../td',
      assignee: '//th[contains(text(), "Assignee:")]/../td',
      serial: '//th[contains(text(), "Appl. No.:")]/../td/b/text()',
      family_id: '//th[contains(text(), "Family ID:")]/../td/b/text()',
      issue_date: "//table[@width='100%'][2]/tr[2]/td[@align='right']/b[1]/text()",
      filing_date: '//th[contains(text(), "Filed:")]/../td/b/text()',
      us_classifications: '//td/b[contains(text(), "Current U.S. Class:")]/../../td[@align="right"]',
      cpc_classifications: '//td/b[contains(text(), "Current CPC Class:")]/../../td[@align="right"]',
      international_classifications: '//td/b[contains(text(), "Current International Class:")]/../../td[@align="right"]',
      field_of_search: '//td/b[contains(text(), "Field of Search:")]/../../td[@align="right"]',
      primary_examiner: '/html/body/text()'
    }

    def self.parse(html)
      html = Nokogiri::HTML(html)
      parsed = {
        number: extract(:number, html),
        title:  extract(:title, html),
        issue_date:  extract(:issue_date, html),
        filing_date:  extract(:filing_date, html),
        inventors:  extract(:inventors, html),
        abstract:  extract(:abstract, html),
        assignee:  extract(:assignee, html),
        us_classifications:  extract(:us_classifications, html),
        international_classifications:  extract(:international_classifications, html),
        cpc_classifications:  extract(:cpc_classifications, html),
        field_of_search:  extract(:field_of_search, html),
        serial:  extract(:serial, html),
        family_id:  extract(:family_id, html),
        primary_examiner:  extract(:primary_examiner, html)
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
      elsif key == :filing_date
        raw_date = html.xpath(XPATH[:filing_date]).text.gsub(/\n|\s{2,}/, '')
        extracted = Date.parse(raw_date)
      elsif key == :abstract
        extracted = html.xpath(XPATH[:abstract]).text.delete("\n").gsub(/\s{2,}/, ' ')
      elsif key == :family_id
        extracted = html.xpath(XPATH[:family_id]).text.delete("\n").gsub(/\s{2,}/, ' ')
      elsif key == :serial
        extracted = html.xpath(XPATH[:serial]).text.delete("\n").gsub(/^\s/, '')
      elsif key == :primary_examiner
        extracted = html.xpath(XPATH[:primary_examiner]).text.delete("\n").gsub(/^\s*|\s*$/, '')
      elsif key == :us_classifications
        extracted = html.xpath(XPATH[:us_classifications]).text
          .gsub(/^\s*|\s*$/, '')
          .split('; ')
      elsif key == :cpc_classifications
        extracted = html.xpath(XPATH[:cpc_classifications]).text
          .gsub(/^\s*|\s*$/, '')
          .split('; ')
          .collect { |c| c.gsub('&nbsp', ' ')}
      elsif key == :international_classifications
        extracted = html.xpath(XPATH[:international_classifications]).text
          .gsub(/^\s*|\s*$/, '')
          .split('; ')
          .collect { |c| c.gsub('&nbsp', ' ')}
      elsif key == :field_of_search
        extracted = html.xpath(XPATH[:field_of_search]).text
          .gsub(/^\s*;/, '')
          .gsub(/^\s*|\s*$/, '')
          .split(',')
      elsif key == :assignee
        extracted = html.xpath(XPATH[:assignee]).text
                        .delete("\n")
                        .split(/\s\(/)
                        .collect { |a| a.gsub(/\)$/, '') }
        extracted = {
          name: extracted[0],
          location: extracted[1]
        }

      elsif key == :inventors
        raw_inventors = html.xpath(XPATH[:inventors]).inner_html

        # Hold on to your butts...
        raw_inventors = raw_inventors
                        .delete("\n")
                        .gsub(/\s{2,}/, ' ')
                        .gsub(/^\s*|\s*$/, '')
                        .gsub(/<b>/, '')
                        .split('),')
                        .collect do |i|
                          i = i.split(%r{<\/b>\s*})
                          {
                            name: i[0],
                            residence: i[1].gsub(/^\(/, '')
                          }
                        end

        extracted = raw_inventors
      end
      extracted
    end
  end
end
