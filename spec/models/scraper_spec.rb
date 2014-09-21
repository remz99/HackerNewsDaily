require "rails_helper"

describe Scraper do
  let(:scraper) { Scraper.new }

  before do
    stub_request(:get, "https://news.ycombinator.com/").
      with(:headers => {'Accept'=>'*/*', 'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7', 'Accept-Encoding'=>'gzip,deflate,identity', 'Accept-Language'=>'en-us,en;q=0.5', 'Connection'=>'keep-alive', 'Host'=>'news.ycombinator.com' }).
      to_return(:status => 200, :headers => {"Content-Type" => "text/html"}, :body => Rails.root.join('spec', 'files', 'hackernews.html'))
  end

  describe ".scrap" do
    it "creates new articles" do
      expect { Scraper.scrap }.to change(Article, :count).by(5)
    end
  end

  describe "agent" do
    subject { scraper.agent }
    it { should be_a(Mechanize) }
  end

  describe "page" do
    subject(:page) { scraper.page }
    it { should be_a(Mechanize::Page) }

    context "title" do
      subject { page.title }
      it { should eq("Hacker News") }
    end
  end

  describe "#article_rows" do
    subject(:rows) { scraper.article_rows }
    it { should be_a(Nokogiri::XML::NodeSet)}
    it { expect(subject.length).to eq(5) }
  end

  describe "#scrap" do
    it "creates new articles" do
      expect { scraper.scrap }.to change(Article, :count).by(5)
    end
  end
end
