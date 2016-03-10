class WikipediaController < ApplicationController
  def index
    render :index
  end

  def create
    wiki_service = WikipediaService.new
    render json: wiki_service.get_page_data params[:article_title] 
  end
end
