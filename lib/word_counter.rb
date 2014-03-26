require "word_counter/version"
require "net/http"
require 'nokogiri'

class NoFileError < StandardError; end
class NoWebsiteError < StandardError; end

class WordCounter


  ##
  # WordCounter!
  #
  # @param filename [String] The path and filename of the file to analyze
  # @param show_sentences [Boolean] (default: false) If true, WordCounter will print out the sentences which contain the counted word in question
  def initialize arg, show_sentences = false
    raise ArgumentError, "Please supply a URL or file path." unless arg
    @show_sentences = true if show_sentences

    begin
      # try to open it as a file
      @hashified_words = WordCounter.analyze_file arg
    rescue NoFileError => e
      # try to analyze it as a website, so curl it
      @hashified_words = WordCounter.analyze_website arg
    end
  end


  ##
  # Helper method
  def show_sentences?
    @show_sentences
  end


  ##
  # Prints a report to stdout
  def report
    hashified_words_with_sorted_lines = @hashified_words.each do |word, data|
      # data[:lines].sort
    end

    sorted_hash = hashified_words_with_sorted_lines.sort_by { |word, data|
      [-data[:count], word]
    }

    sorted_hash.each do |word, data|
      puts "#{data[:count]} #{word}"
      puts "    #{data[:lines].join("\n    ")}" if show_sentences?
    end
  end


  ##
  # Fetch a url
  #
  # @param uri_str [String] A URI
  def self.fetch(uri_str, limit = 10)
    raise ArgumentError, 'too many HTTP redirects' if limit == 0

    uri = URI uri_str
    response = Net::HTTP.get_response uri

    case response
    when Net::HTTPSuccess then
      response
    when Net::HTTPRedirection then
      location = response['location']
      warn "redirected to #{location}"
      fetch(location, limit - 1)
    else
      response.value
    end
  end


  ##
  # Prepends an http:// if there isn't one.
  #
  # @param arg [String]
  def self.urlize arg
    if arg =~ /^(http:\/\/|https:\/\/)/
      arg
    else
      "http://#{arg}"
    end
  end


  ##
  # Vists a website and analyzes it
  #
  # @param arg [String] A website URL
  def self.analyze_website arg
    url = WordCounter.urlize arg
    res = WordCounter.fetch url
    raise NoWebsiteError unless res.code == '200'

    doc = Nokogiri::HTML res.body
    doc.search('script').remove
    doc.search('meta').remove
    doc.search('style').remove
    text = doc.text
    hashify_words text
  end



  ##
  # Opens a file and analyzes it
  #
  # @param file [String] A path to a file
  def self.analyze_file file
    raise NoFileError, "File does not exist!" unless File.exist? file

    hashified_words = nil

    @file = File.open file do |file|
      hashified_words = hashify_words file
    end

    hashified_words
  end

  ##
  # Builds the data structures we use for our analysis.
  #
  # @param string [File] The string we're analyzing (notice: can also be a File object, because `each_line` also works with Files.)
  def self.hashify_words string
    hash = {}

    string.each_line do |line|
      words = line.split(/\W+/).reject { |w| w.empty? }

      words.each do |word|
        sym = word.to_sym

        if hash[sym] == nil
          hash[sym] = {
            count: 1,
            lines: [line.strip]
          }
        else
          hash[sym][:count] += 1
          hash[sym][:lines].push(line.strip).uniq!
          hash[sym][:lines].sort!
        end
      end
    end

    hash
  end
end
