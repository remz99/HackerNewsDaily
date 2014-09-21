class ArticleMailer < BaseMailer
  def list
    @articles = Article.all
    @date     = Date.today.strftime('%b %d')

    mail(subject: "Hacker News Articles for #{@date}")
  end
end
