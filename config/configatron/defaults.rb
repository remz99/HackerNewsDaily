configatron.urls.hacker_news = "https://news.ycombinator.com"
configatron.urls.hacker_news_item = configatron.urls.hacker_news + "/item?id="

configatron.emails.from = Rails.application.secrets[:emails][:from]
configatron.emails.to = Rails.application.secrets[:emails][:to]
