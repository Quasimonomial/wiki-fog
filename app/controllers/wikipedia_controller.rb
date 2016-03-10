class WikipediaController < ApplicationController
  def index
    render :index
  end

  def create
    wiki_service = WikipediaService.new
    frequency_data = wiki_service.get_page_data params[:article_title]
    render json: frequency_data.to_json  
  end
end
