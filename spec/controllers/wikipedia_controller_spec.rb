require 'rails_helper'

describe WikipediaController do
  describe 'GET #index' do
    it 'should render the index view' do
      get :index

      expect(response.status).to eq(200)
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    context 'the article is found' do
      before do
        WikipediaService.any_instance.stub(:get_page_data).and_return([
          { "text" => "a", "weight" => 1},
          { "text" => "b", "weight" => 2},
          { "text" => "c", "weight" => 3}
        ])
      end

      it 'returns the page data' do
        post :create, wikipedia: {
          article_title: "words",
          word_count: 50,
          random_page: false
        }

        expect(response.status).to be(200)
        expect(response.body).to eq("[{\"text\":\"a\",\"weight\":1},{\"text\":\"b\",\"weight\":2},{\"text\":\"c\",\"weight\":3}]")
      end
    end

    context "the article is not found" do
      before do
        WikipediaService.any_instance.stub(:get_page_data).and_return(false)
      end

      it 'returns 404 not found' do
        post :create, wikipedia: {
          article_title: "",
          word_count: 50,
          random_page: false
        }

        expect(response.status).to eq(404)
      end
    end
  end
end
