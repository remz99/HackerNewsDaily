require "rails_helper"

require 'sidekiq/testing'

Sidekiq::Testing.fake!

describe ArticleWorker do 
  describe "#perform" do
    let(:worker)  { ArticleWorker.new }
    let(:article) { articles(:article1) }

    let(:time) { Time.parse("2014-01-01") }
    before     { Timecop.freeze(time) }

    before do
      stub_request(:get, "https://news.ycombinator.com/").
        with(:headers => {'Accept'=>'*/*', 'Accept-Charset'=>'ISO-8859-1,utf-8;q=0.7,*;q=0.7', 'Accept-Encoding'=>'gzip,deflate,identity', 'Accept-Language'=>'en-us,en;q=0.5', 'Connection'=>'keep-alive', 'Host'=>'news.ycombinator.com' }).
        to_return(:status => 200, :headers => {"Content-Type" => "text/html"}, :body => Rails.root.join('spec', 'files', 'hackernews.html'))
    end

    it "places a job on the queue" do
      expect { ArticleWorker.perform_async }.to change(ArticleWorker.jobs, :size).by(1)
    end

    it "cleans up existing articles" do
      expect do
        worker.perform
        article.reload
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "creates five new articles" do
      expect { worker.perform }.to change(Article.where(created_at: time), :count).by(5)
    end

    it "delivers an email" do
      expect { worker.perform }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
