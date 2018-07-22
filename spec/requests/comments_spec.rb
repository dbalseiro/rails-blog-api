require 'rails_helper'

RSpec.describe CommentsController, type: :request do
  let!(:article) { create :article }
  let!(:comments) { create_list(:comment, 10, article_id: article.id) }
  let(:article_id) { article.id }
  let(:comment_id) { comments.first.id }

  describe 'GET /articles/:article_id/comments' do
    before { get "/articles/#{article_id}/comments" }

    it 'returns all comments' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /articles/:article_id/comments/:id' do
    before { get "/articles/#{article_id}/comments/#{comment_id}" }

    context 'when the record exists' do
      it 'returns the comment' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(comment_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exists' do
      let(:comment_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns an error message' do
        expect(response.body).to match(/Couldn't find Comment with 'id'=100/)
      end
    end
  end

  describe 'POST /articles/:article_id/comments' do
    let(:valid_comment) { attributes_for :comment }
    let(:invalid_comment) { attributes_for :unaccepted_comment }

    context 'when the record is valid' do
      before do
        post "/articles/#{article_id}/comments",
             params: { comment: valid_comment }
      end

      it 'creates a comment' do
        expect(Comment.all.size).to eq(11)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the record is invalid' do
      before do
        post "/articles/#{article_id}/comments",
             params: { comment: invalid_comment }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation error message' do
        expect(response.body).to match(/Human must be accepted/)
      end
    end
  end

  describe 'PUT /articles/:article_id/comments/:id' do
    let(:valid_update) { attributes_for :comment, body: '123456' }
    let(:invalid_update) { attributes_for :comment, human: nil }

    context 'when the record is valid' do
      before do
        put "/articles/#{article_id}/comments/#{comment_id}",
            params: { comment: valid_update }
      end

      it 'updates an article' do
        expect(Comment.find(comment_id).body).to eq('123456')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record is invalid' do
      before do
        put "/articles/#{article_id}/comments/#{comment_id}",
            params: { comment: invalid_update }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation error message' do
        expect(response.body).to match(/Human must be accepted/)
      end
    end
  end

  describe 'DELETE /articles/:article_id/comments/:id' do
    before { delete "/articles/#{article_id}/comments/#{comment_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'deletes the record' do
      expect(Comment.all.size).to eq(9)
    end
  end
end
