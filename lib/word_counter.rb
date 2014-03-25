require "word_counter/version"

class NoFileError < StandardError; end

class WordCounter


  ##
  # @param filename [String] The path and filename of the file to analyze
  def initialize filename
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
      words = line.split

      words.each do |word|
        sym = word.to_sym
        hash[sym] = hash[sym] == nil ? 1 : hash[sym] + 1
      end
    end

    hash
  end


  ##
  # Prints a report to stdout
  def report
    @hashified_words.each do |word, count|
      print "#{count} #{word}\n"
    end
  end
end
