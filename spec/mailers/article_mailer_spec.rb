require "rails_helper"

describe ArticleMailer do
  let(:time) { Time.parse("2014-01-01") }
  before     { Timecop.freeze(time) }

  describe "#list" do
    let(:mail) { ArticleMailer.list }

    context "subject" do
      subject { mail.subject }
      it { should eq("Hacker News Articles for Jan 01") }
    end

    context "from" do
      subject { mail.from }
      it { should contain_exactly(Rails.application.secrets[:emails][:from]) }
    end

    context "to" do
      subject { mail.to }
      it { should contain_exactly(Rails.application.secrets[:emails][:to]) }
    end

    context "contains articles" do
      let(:article) { articles(:article1) }
      subject { mail.body.encoded }
      
      it { should include(article.url) }
      it { should include(article.title) }
    end
  end
end
