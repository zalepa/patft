require_relative 'xpaths'
require_relative 'string_extensions'

# TODO: Documentation
module Patft
  include XPATHS
  String.include Patft::StringExtensions

  # TODO: Documentation
  class Parser
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

    def extract(key)
      send(key) if private_methods(false).include?(key)
    end

    # def self.parse(html)
    #   parser = Parser.new(html)
    #   parser.to_hash
    # end

    private

    def number
      @html.xpath(xpath_number).text.delete(',')
    end

    def title
      @html.xpath(xpath_title).text.scrub_html
    end

    def issue_date
      raw_date = @html.xpath(xpath_issue_date).text.scrub_html
      Date.parse(raw_date)
    end

    def filing_date
      raw_date = @html.xpath(xpath_filing_date).text.scrub_html
      Date.parse(raw_date)
    end

    def abstract
      @html.xpath(xpath_abstract).text.scrub_html
    end

    def family_id
      @html.xpath(xpath_family_id).text.scrub_html
    end

    def serial
      @html.xpath(xpath_serial).text.scrub_html
    end

    def primary_examiner
      @html.xpath(xpath_primary_examiner).text.scrub_html
    end

    def us_classifications
      @html.xpath(xpath_us_classifications).text
           .scrub_html
           .split('; ')
    end

    def cpc_classifications
      @html.xpath(xpath_cpc_classifications).text
           .scrub_html
           .split('; ')
           .collect { |c| c.gsub('&nbsp', ' ') }
    end

    def international_classifications
      @html.xpath(xpath_international_classifications).text
           .scrub_html
           .split('; ')
           .collect { |c| c.gsub('&nbsp', ' ') }
    end

    def field_of_search
      @html.xpath(xpath_field_of_search).text
           .gsub(/^\s*;/, '')
           .scrub_html
           .split(',')
    end

    def assignee
      extracted = @html.xpath(xpath_assignee).text
                       .scrub_html
                       .split(/\s\(/)
                       .collect { |a| a.gsub(/\)$/, '') }
      {
        name: extracted[0],
        location: extracted[1]
      }
    end

    def inventors
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
