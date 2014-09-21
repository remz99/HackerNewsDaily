#
# SideKiq worker which at 8am NZST emails the latest hacker news articles
#
class ArticleWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  schedule.start_time = ActiveSupport::TimeZone['Pacific/Auckland'].local 2010, 1, 1

  sidekiq_options :retry => 3

  recurrence { daily.hour_of_day(8) }

  def perform   
    ActiveRecord::Base.transaction do 
      Article.clean_up
      Scraper.scrap
      ArticleMailer.list.deliver
    end
  end
end