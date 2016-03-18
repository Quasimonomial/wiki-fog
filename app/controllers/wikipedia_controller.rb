class WikipediaController < ApplicationController
  def index
    render :index
  end

  def create
    wiki_service = WikipediaService.new wikipedia_params
    frequency_data = wiki_service.get_page_data
    if frequency_data
      render json: frequency_data.to_json
    else
      render nothing: true, status: 404;
    end
  end

  private

  def wikipedia_params
    params.require(:wikipedia).permit(:article_title, :word_count)
  end
end
