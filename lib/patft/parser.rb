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
      filing_date: '//th[contains(text(), "Filed:")]/../td/b/text()'
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
        serial:  extract(:serial, html),
        family_id:  extract(:family_id, html)
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
