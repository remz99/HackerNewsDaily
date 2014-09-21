class Article < ActiveRecord::Base
  validates :title, :url, presence: true
  
  class << self
    def clean_up
      Article.destroy_all
    end
  end

  def as_json(options = {})
    super(options.merge(only: [:reference_number, :title, :url, :comments_url], methods: :comments_url))
  end

  #
  # URL to comments in hacker news for example https://news.ycombinator.com/item?id=1
  #
  def comments_url
    configatron.urls.hacker_news_item + reference_number if reference_number
  end
end
