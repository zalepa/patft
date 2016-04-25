module Patft
  module XPATHS
    def xpath_primary_examiner
      '/html/body/text()'
    end

    def xpath_number
      "//table[@width='100%'][2]/tr[1]/td[@align='right']/b/text()[1]"
    end

    def xpath_title
      '//body/font[1]/text()'
    end

    def xpath_abstract
      '/html/body/p[1]/text()'
    end

    def xpath_inventors
      '//th[contains(text(), "Inventors:")]/../td'
    end

    def xpath_assignee
      '//th[contains(text(), "Assignee:")]/../td'
    end

    def xpath_serial
      '//th[contains(text(), "Appl. No.:")]/../td/b/text()'
    end

    def xpath_family_id
      '//th[contains(text(), "Family ID:")]/../td/b/text()'
    end

    def xpath_issue_date
      "//table[@width='100%'][2]/tr[2]/td[@align='right']/b[1]/text()"
    end

    def xpath_filing_date
      '//th[contains(text(), "Filed:")]/../td/b/text()'
    end

    def xpath_us_classifications
      xpath_value_by_table_header('Current U.S. Class:')
    end

    def xpath_cpc_classifications
      xpath_value_by_table_header('Current CPC Class:')
    end

    def xpath_international_classifications
      xpath_value_by_table_header('Current International Class:')
    end

    def xpath_field_of_search
      xpath_value_by_table_header('Field of Search:')
    end

    private

    def xpath_value_by_table_header(header)
      "//td/b[contains(text(), '#{header}')]/../../td[@align='right']"
    end
  end
end
