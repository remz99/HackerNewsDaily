require "rails_helper"

describe ArticlesController do
  describe "#index" do
    before  { get :index }
    subject { response }
    
    it      { should be_success }

    context "renders json" do
      let(:article) { articles(:article1) }
      subject { JSON.parse(response.body) }
      it { should contain_exactly(article.as_json) }
    end
  end
end
