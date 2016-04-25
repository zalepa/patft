require_relative 'xpaths'
require_relative 'string_extensions'

#:nodoc:
module Patft
  include XPATHS
  String.include Patft::StringExtensions

  # Class for parsing PATFT html files
  class Parser
    def initialize(html)
      @html = Nokogiri::HTML(html)
    end

    def extract(key)
      method = "extract_#{key}".to_sym
      send(method) if private_methods(false).include?(method)
    end

    private

    def extract_number
      @html.xpath(xpath_number).text.delete(',')
    end

    def extract_title
      @html.xpath(xpath_title).text.scrub_html
    end

    def extract_issue_date
      raw_date = @html.xpath(xpath_issue_date).text.scrub_html
      Date.parse(raw_date)
    end

    def extract_filing_date
      raw_date = @html.xpath(xpath_filing_date).text.scrub_html
      Date.parse(raw_date)
    end

    def extract_abstract
      @html.xpath(xpath_abstract).text.scrub_html
    end

    def extract_family_id
      @html.xpath(xpath_family_id).text.scrub_html
    end

    def extract_serial
      @html.xpath(xpath_serial).text.scrub_html
    end

    def extract_primary_examiner
      @html.xpath(xpath_primary_examiner).text.scrub_html
    end

    def extract_us_classifications
      @html.xpath(xpath_us_classifications).text
           .scrub_html
           .split('; ')
    end

    def extract_cpc_classifications
      @html.xpath(xpath_cpc_classifications).text
           .scrub_html
           .split('; ')
           .collect { |c| c.gsub('&nbsp', ' ') }
    end

    def extract_international_classifications
      @html.xpath(xpath_international_classifications).text
           .scrub_html
           .split('; ')
           .collect { |c| c.gsub('&nbsp', ' ') }
    end

    def extract_field_of_search
      @html.xpath(xpath_field_of_search).text
           .gsub(/^\s*;/, '')
           .scrub_html
           .split(',')
    end

    def extract_assignee
      extracted = @html.xpath(xpath_assignee).text
                       .scrub_html
                       .split(/\s\(/)
                       .collect { |a| a.gsub(/\)$/, '') }
      {
        name: extracted[0],
        location: extracted[1]
      }
    end

    def extract_inventors
      raw_inventors = @html.xpath(xpath_inventors).inner_html

      # Hold on to your butts...
      raw_inventors.scrub_html
                   .gsub(/<b>/, '')
                   .split('),')
                   .collect do |i|
                     i = i.split(%r{<\/b>\s*})
                     { name: i[0], residence: i[1].gsub(/^\(/, '') }
                   end
    end
  end
end
