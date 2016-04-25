# PATFT: A USPTO PATFT Parsing Library

PATFT is a simple gem to extract relevant data from raw HTML provided by the
USPTO at http://patft.uspto.gov/. PATFT uses Nokogiri and XPath to scan HTML
files provided to it and returns a structure (e.g., Hash/JSON) representation
of the patent document.

**WARNING**: PATFT is under active development, refer to the roadmap below (and
the specs) to see what is and is not implemented.

# Usage

``` ruby
require 'patft'

local_html = File.read('patent.html')
patents = Parser.parse(local_html) # => { number: '1234567', title: '...', ... }
```

Note that PATFT::Parser#parse requires a String representation of the HTML, how
you get that is up to you. This was intentional given the USPTO's policy on
scraping (and generally to encourage being responsible).

# Output Format
Below are the keys output by `Parser#parse`:

## number
A `String` containing the patent number, without kind code. Note that this field
 may contain non-numeric characters for design, re-issue, etc. patents.

## title
A `String` containing the title.

# Roadmap

## Short Term

Extract the following fields:

- [x] Number
- [x] Title
- [x] Issue Date
- [x] Abstract
- [x] Inventors*+
- [x] Assignee*
- [x] Family ID
- [x] Serial Number
- [x] Filing Date
- [x] US Class*+
- [x] CPC Class*+
- [x] Int'l Class*+
- [x] Field of search
- [x] Primary Examiner
- [ ] Assistant Examiner
- [ ] Attorney/Agent
- [ ] Parent Case Text
- [ ] Claims*+
- [ ] Description (paragraphs)+
- [ ] Related Patents*+
- [ ] References Cited*+


Format notes:
* Asterisks denote structured data.
* Plusses denote arrays of data
* Asterisks and plusses are arrays of structured data

## Medium Term

- [ ] CLI
- [ ] Increase field support based on red book (e.g., PCT data)

## Long Term (rough ideas)

- [ ] Remote search interface
- [ ] Query tool ("Advanced Search")
- [ ] AppFT (probably a different gem)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
