# WordCounter

Counts words from either a file or a website, and prints a report to stdout.

[![Build Status](https://api.travis-ci.org/wulftone/word_counter.svg?branch=master)](http://travis-ci.org/wulftone/word_counter)
[![Gem Version](https://badge.fury.io/rb/word_counter.svg)](http://badge.fury.io/rb/word_counter)

## Installation

Add this line to your application's Gemfile:

    gem 'word_counter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install word_counter

## Usage

To count a website's words:

    $ word_counter www.example.com
    Results:
    2 Domain
    2 Example
    2 domain
    2 examples
    2 for
    2 in
    1 More
    1 This
    1 You
    1 asking
    1 be
    1 coordination
    1 documents
    1 established
    1 illustrative
    1 information
    1 is
    1 may
    1 or
    1 permission
    1 prior
    1 this
    1 to
    1 use
    1 used
    1 without

To count a file's words:

    $ word_counter ./path/to/my/file.txt

Use the `-s` switch to also report which lines contained the counted word (can result in lot of text output, so you might want to pipe it to `less`):

    $ word_counter www.example.com -s | less
    Results:
    2 Domain
        1: Example Domain
    2 Example
        1: Example Domain
    2 domain
        1: This domain is established to be used for illustrative examples in documents. You may use this
        2: domain in examples without prior coordination or asking for permission.
    2 examples
        1: This domain is established to be used for illustrative examples in documents. You may use this
        2: domain in examples without prior coordination or asking for permission.

## Roadmap

- Color
- More flexible options

## Contributing

1. Fork it ( http://github.com/wulftone/word_counter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
