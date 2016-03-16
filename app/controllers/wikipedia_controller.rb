class WikipediaController < ApplicationController
  def index
    render :index
  end

  def create
    wiki_service = WikipediaService.new params[:article_title], params[:word_count]
    frequency_data = wiki_service.get_page_data
    render json: frequency_data.to_json
  end
end
