# frozen_string_literal: true

class ArticlesController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :fetch_article, only: [:show , :update, :destroy]
  before_action :authenticate_user!

  def index
    @articles = Article.all
    json_response(@articles)
  end

  def search
    @articles = Article.search(*search_params)
    json_response(@articles)
  end

  def show
    json_response(@article)
  end

  def create
    @article = Article.create! article_params
    json_response(@article, :created)
  end

  def update
    @article.update! article_params
    head :no_content
  end

  def destroy
    @article.destroy
    head :no_content
  end

  private

  def fetch_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(*Article::ATTRIBUTE_WHITELIST)
  end

  def search_params
    [params[:search], params[:location]]
  end
end
