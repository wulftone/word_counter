require_relative '../lib/word_counter'

module CaptureStdout
  def capture_stdout(&blk)
    old = $stdout
    $stdout = fake = StringIO.new
    blk.call
    fake.string
  ensure
    $stdout = old
  end

  def capture_stderr(&blk)
    old = $stderr
    $stderr = fake = StringIO.new
    blk.call
    fake.string
  ensure
    $stderr = old
  end
end

describe WordCounter do
  include CaptureStdout
  let(:test_file) { './spec/test.txt' }
  let(:hash) {
    {
      woof: 5,
      bark: 3,
      snort: 2
    }
  }

  it 'should count words' do
    wc = WordCounter.new test_file

    printed = capture_stdout do
      wc.report
    end

    printed.should eq "5 woof\n3 bark\n2 snort\n"
  end


  it 'should hashify words' do
    File.open test_file do |file|
    result = WordCounter.hashify_words file
      result.should eq hash
    end
  end


  it 'should raise an error if no file' do
    expect {
      WordCounter.new 'non-existant-file.txt'
    }.to raise_error NoFileError
  end
end
