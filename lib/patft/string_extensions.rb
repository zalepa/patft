module Patft
  module StringExtensions
    def scrub_html
      delete("\n").strip.gsub(/\s{2,}/, ' ')
    end
  end
end
