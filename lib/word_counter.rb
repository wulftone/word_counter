require "word_counter/version"
require 'curb'
require 'nokogiri'

class NoFileError < StandardError; end

class WordCounter


  ##
  # @param filename [String] The path and filename of the file to analyze
  def initialize arg, show_sentences = false
    @show_sentences = true if show_sentences

    begin
      # try to open it as a file
      analyze_file arg
    rescue NoFileError => e
      # try to analyze it as a website, so curl it
      analyze_website arg
    end
  end


  def analyze_website url
    http = Curl.get url
    html = Nokogiri::HTML http.body_str

    html.search('script').remove
    html.search('meta').remove
    html.search('style').remove
    text = html.text
    @hashified_words = WordCounter.hashify_words text
  end



  def analyze_file filename
    raise NoFileError, "File does not exist!" unless File.exist? filename

    @file = File.open filename do |file|
      @hashified_words = WordCounter.hashify_words file
    end
  end

  ##
  # Builds the data structures we use for our analysis.
  #
  # @param file [File] The file we're analyzing
  def self.hashify_words file
    hash = {}

    file.each_line do |line|
      # words = line.split
      words = line.split(/\W+/)

      words.reject! { |w| w.empty? }

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


  def show_sentences?
    @show_sentences
  end


  ##
  # Prints a report to stdout
  def report
    hashified_words_with_sorted_lines = @hashified_words.each do |word, data|
      data[:lines].sort
    end

    sorted_hash = hashified_words_with_sorted_lines.sort_by { |word, data|
      [-data[:count], word]
    }

    sorted_hash.each do |word, data|
      puts "#{data[:count]} #{word}"
      puts "    #{data[:lines].join("\n    ")}" if show_sentences?
    end
  end
end
