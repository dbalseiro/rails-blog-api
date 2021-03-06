require 'rails_helper'

RSpec.describe ArticlesController, type: :request do
  let!(:articles) { create_list(:article, 10) }
  let(:article_id) { articles.first.id }

  before(:each) do
    @user = create :user
    login @user
    @auth_headers = get_auth_headers
  end

  describe 'GET /search' do
    context 'when it matches all values' do
      before { get '/articles/search?location=Manhattan', headers: @auth_headers }

      it 'returns all articles' do
        expect(json).not_to be_empty
      end
    end

    context 'when it not matches all values' do
      before { get '/articles/search?search=Manhattan', headers: @auth_headers}

      it 'returns all articles' do
        expect(json).to be_empty
      end
    end
  end

  describe 'GET /articles' do
    before { get '/articles', headers: @auth_headers }

    it 'returns all articles' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /articles/:id' do
    before { get "/articles/#{article_id}", headers: @auth_headers }

    context 'when the record exists' do
      it 'returns the article' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(article_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exists' do
      let(:article_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns an error message' do
        expect(response.body).to match(/Couldn't find Article with 'id'=100/)
      end
    end
  end

  describe 'POST /articles' do
    let(:valid_article) { attributes_for :article }
    let(:invalid_article) { attributes_for :invalid_article }

    context 'when the record is valid' do
      before do
        post '/articles',
             params: { article: valid_article },
             headers: @auth_headers
      end

      it 'creates an article' do
        expect(Article.all.size).to eq(11)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the record is invalid' do
      before do
        post '/articles',
             params: { article: invalid_article },
             headers: @auth_headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation error message' do
        expect(response.body).to match(/Title is too short/)
      end
    end
  end

  describe 'PUT /articles/:id' do
    let(:valid_update) { attributes_for :article, title: '123456' }
    let(:invalid_update) { attributes_for :article, title: '123' }

    context 'when the record is valid' do
      before do
        put "/articles/#{article_id}",
            params: { article: valid_update },
            headers: @auth_headers
      end

      it 'updates an article' do
        expect(Article.find(article_id).title).to eq('123456')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record is invalid' do
      before do
        put "/articles/#{article_id}",
            params: { article: invalid_update },
            headers: @auth_headers
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation error message' do
        expect(response.body).to match(/Title is too short/)
      end
    end
  end

  describe 'DELETE /articles/:id' do
    before { delete "/articles/#{article_id}", headers: @auth_headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'deletes the record' do
      expect(Article.all.size).to eq(9)
    end
  end
end
