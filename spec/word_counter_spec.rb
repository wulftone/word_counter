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
      :bark => {:count=>3, :lines=>["bark woof woof snort", "honk woof bark", "snort bark woof"]},
      :honk => {:count=>2, :lines=>["honk woof bark", "sniff sniff honk"]},
      :sniff => {:count=>2, :lines=>["sniff sniff honk"]},
      :snort => {:count=>2, :lines=>["bark woof woof snort", "snort bark woof"]},
      :woof => {:count=>4, :lines=>["bark woof woof snort", "honk woof bark", "snort bark woof"]}
    }
  }

  it '#report' do
    wc = WordCounter.new test_file, true

    printed = capture_stdout do
      wc.report
    end

    printed.should eq "4 woof
    bark woof woof snort
    honk woof bark
    snort bark woof
3 bark
    bark woof woof snort
    honk woof bark
    snort bark woof
2 honk
    honk woof bark
    sniff sniff honk
2 sniff
    sniff sniff honk
2 snort
    bark woof woof snort
    snort bark woof
"
  end


  it '#analyze_website' do
    wc = WordCounter.new 'www.example.com'

    printed = capture_stdout do
      wc.report
    end

    printed.should eq "2 Domain
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
"
  end


  it '.urlize' do
    url = WordCounter.urlize 'example.com'
    url.should eq 'http://example.com'
    url = WordCounter.urlize 'https://example.com'
    url.should eq 'https://example.com'
    url = WordCounter.urlize 'http://example.com'
    url.should eq 'http://example.com'
  end


  it 'should raise an error for an invalid website' do
    expect {
      wc = WordCounter.new 'invalid website'
    }.to raise NoWebsiteError
  end
end
