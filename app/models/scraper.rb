#
# This class handles the scraping of hacker news
#
class Scraper
  #
  # XPATH to select the article table rows
  #
  ROW_XPATH = "//tr[td/@class='title'][not(td/a/@rel='nofollow')]"

  #
  # XPATH to select the url for an article row
  #
  LINK_XPATH = "td[@class=title]/a"

  #
  # XPATH to select a reference number for an article row
  #
  REFERENCE_NUMBER_XPATH = "td/center/a[contains(value,'up_')]"
  
  class << self
    def scrap
      new.scrap
    end
  end

  def agent
    @agent ||= Mechanize.new
  end

  def page
    @page ||= agent.get(configatron.urls.hacker_news)
  end

  def article_rows
    @article_rows ||= page.search(ROW_XPATH)
  end

  #
  # Scrap the top articles on hacker news and create article records for them.
  #
  def scrap
    article_rows.each do |row|
      link = row.search(LINK_XPATH).first
      reference_number = row.search(REFERENCE_NUMBER_XPATH).first      


      url   = link["href"]
      title = link.text

      if reference_number
        reference_number = reference_number["id"].match(/^up_(\d+)$/)[1]
      end

      Article.create(title: title, reference_number: reference_number, url: url)
    end
  end
end