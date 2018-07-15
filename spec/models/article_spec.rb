# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |c|
  c.use_transactional_examples = true
end

RSpec.describe Article, type: :model do
  it 'is valid with valid attributes' do
    article = build :article
    expect(article).to be_valid
  end

  it 'is invalid without a title' do
    article = build :article, title: nil
    expect(article).not_to be_valid
  end

  it 'is invalid with a title less than 5 characters' do
    article = build :article, title: '123'
    expect(article).not_to be_valid
  end

  describe '.full_address' do
    let(:article) { Article.new }
    context 'when the article is empty' do
      it 'returns an empty address' do
        expect(article.full_address).to eq ', , '
      end
    end

    context 'when the article has data' do
      it 'returns the address' do
        article.city = 'ny'
        expect(article.full_address).to eq 'ny, , '
      end

      it 'returns the full address' do
        article.city = 'ny'
        article.state = 'new york'
        article.zipcode = '90210'
        expect(article.full_address).to eq 'ny, new york, 90210'
      end
    end
  end

  describe '.search' do
    context 'when there are no articles' do
      it 'returns an empty list' do
        articles = Article.search(nil, nil)
        expect(articles).to be_empty
      end
    end

    context 'when there are many articles' do
      before(:each) do
        create :article
      end

      context 'and the criteria is empty' do
        it 'returns all the articles' do
          articles = Article.search(nil, nil)
          expect(articles.count).to eq 1
        end
      end

      context 'and the criteria is location' do
        it 'returns the article with the nearest location' do
          articles = Article.search(nil, 'Manhattan')
          expect(articles.length).to eq 1
        end
      end

      context 'and the criteria is text' do
        it 'returns the article that matches the text' do
          articles = Article.search('TITLE', nil)
          expect(articles.length).to eq 1
        end

        it 'returns the article that matches the title' do
          articles = Article.search('desc', nil)
          expect(articles.length).to eq 1
        end
      end

      context 'and the criteria contains a tilde' do
        it 'returns the article that matches both criteria' do
          articles = Article.search("ti't", "Manhattan'")
          expect(articles.length).to eq 0
        end
      end

      context 'and the criteria is for both location and text' do
        it 'returns the article that matches both criteria' do
          articles = Article.search('tit', 'Manhattan')
          expect(articles.length).to eq 1
        end
      end

      context 'and the criteria does not match any article' do
        it 'returnd an empty list' do
          articles = Article.search('title', 'TX')
          expect(articles).to be_empty
        end
      end
    end
  end
end
