require "rails_helper"

describe Article do
  describe "validation" do
    let(:article) { Article.new }
    before { article.valid? }
    subject(:errors) { article.errors }

    context "title" do
      subject { errors[:title] }
      it { should contain_exactly("can't be blank") }
    end

    context "url" do 
      subject { errors[:url] }
      it { should contain_exactly("can't be blank") }
    end
  end

  describe "#as_json" do
    let(:article) { articles(:article1) }
    let(:expected) do
      { "reference_number" => article.reference_number, "title" => article.title, "url" => article.url, "comments_url" => article.comments_url }
    end
    
    subject { article.as_json }
    it { should eq(expected) }
  end

  describe "#comments_url" do
    let(:article) { articles(:article1)  }
    subject { article.comments_url }
    it { should eq("https://news.ycombinator.com/item?id=1") }
  end
end
