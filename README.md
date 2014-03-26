# WordCounter

Counts words from either a file or a website, and prints a report to stdout.

[![Build Status](https://api.travis-ci.org/wulftone/word_counter.svg?branch=master)](http://travis-ci.org/wulftone/word_counter)

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

To count a file's words:

    $ word_counter ./path/to/my/file.txt

Use the `-s` switch to also report which lines contained the counted word (can result in lot of text output, so you might want to pipe it to `less`):

    $ word_counter www.example.com -s | less

## Roadmap

- Color
- More flexible options

## Contributing

1. Fork it ( http://github.com/wulftone/word_counter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
