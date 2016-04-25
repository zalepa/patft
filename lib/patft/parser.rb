require 'date'
require 'nokogiri'

XPATHS = {
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
}.freeze

# TODO: Documentation
module Patft
  #:nodoc:
  module StringExtensions
    def scrub_html
      delete("\n").strip.gsub(/\s{2,}/, ' ')
    end
  end

  # Documentation: TODO
  class Parser
    String.include StringExtensions

    def initialize(html)
      @html = Nokogiri::HTML(html)
    end

    def to_hash
      hash = {}
      %w(number title issue_date filing_date inventors abstract assignee
         us_classifications international_classifications cpc_classifications
         field_of_search serial family_id primary_examiner
      ).each { |f| hash[f.to_sym] = send(f.to_sym) }
      hash
    end

    def number
      @html.xpath(XPATHS[:number]).text.delete(',')
    end

    def title
      @html.xpath(XPATHS[:title]).text.scrub_html
    end

    def issue_date
      raw_date = @html.xpath(XPATHS[:issue_date]).text.scrub_html
      Date.parse(raw_date)
    end

    def filing_date
      raw_date = @html.xpath(XPATHS[:filing_date]).text.scrub_html
      Date.parse(raw_date)
    end

    def abstract
      @html.xpath(XPATHS[:abstract]).text.scrub_html
    end

    def family_id
      @html.xpath(XPATHS[:family_id]).text.scrub_html
    end

    def serial
      @html.xpath(XPATHS[:serial]).text.scrub_html
    end

    def primary_examiner
      @html.xpath(XPATHS[:primary_examiner]).text.scrub_html
    end

    def us_classifications
      @html.xpath(XPATHS[:us_classifications]).text
           .scrub_html
           .split('; ')
    end

    def cpc_classifications
      @html.xpath(XPATHS[:cpc_classifications]).text
           .scrub_html
           .split('; ')
           .collect { |c| c.gsub('&nbsp', ' ') }
    end

    def international_classifications
      @html.xpath(XPATHS[:international_classifications]).text
           .scrub_html
           .split('; ')
           .collect { |c| c.gsub('&nbsp', ' ') }
    end

    def field_of_search
      @html.xpath(XPATHS[:field_of_search]).text
           .gsub(/^\s*;/, '')
           .scrub_html
           .split(',')
    end

    def assignee
      extracted = @html.xpath(XPATHS[:assignee]).text
                       .scrub_html
                       .split(/\s\(/)
                       .collect { |a| a.gsub(/\)$/, '') }
      {
        name: extracted[0],
        location: extracted[1]
      }
    end

    def inventors
      raw_inventors = @html.xpath(XPATHS[:inventors]).inner_html

      # Hold on to your butts...
      raw_inventors.scrub_html
                   .gsub(/<b>/, '')
                   .split('),')
                   .collect do |i|
                     i = i.split(%r{<\/b>\s*})
                     { name: i[0], residence: i[1].gsub(/^\(/, '') }
                   end
    end

    def self.parse(html)
      parser = Parser.new(html)
      parser.to_hash
    end
  end
end
