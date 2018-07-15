# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :fetch_article
  before_action :fetch_comment, only: [:show, :update, :destroy]

  def index
    json_response(@article.comments)
  end

  def show
    json_response(@comment)
  end

  def create
    @comment = @article.comments.create! comment_params
    json_response(@comment, :created)
  end

  def update
    @comment.update! comment_params
    head :no_content
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def fetch_article
    @article = Article.find(params[:article_id])
  end

  def fetch_comment
    @comment = @article.comments.find(params[:id]) if @article
  end

  def comment_params
    params.require(:comment).permit(*Comment::ATTRIBUTE_WHITELIST)
  end
end
