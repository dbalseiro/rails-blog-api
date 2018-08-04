# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :fetch_article, only: [:show , :update, :destroy]
  before_action :authenticate_user!

  def index
    render json: Article.all
  end

  def search
    @articles = Article.search(*search_params)
    render json: @articles
  end

  def show
    render json: @article # How to include the comments of an article
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      render json: @article, status: :created
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
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
