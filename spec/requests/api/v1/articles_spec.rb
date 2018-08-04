require 'rails_helper'

RSpec.describe 'Articles API', type: :request do
  let(:user) { create(:user) }

  describe 'GET: /api/v1/articles' do
    let!(:article) { create(:article) }
    let!(:comment) { create(:comment, article: article) }

    it 'returns a list of articles' do
      get '/api/v1/articles',
        headers: auth_headers_for(user)

      expect(response).to be_json
      binding.pry
      expect(json_response).to match_array(
        [
          hash_including(
            id: article.id,
            title: article.title
          )
        ]
      )
    end
  end
end
