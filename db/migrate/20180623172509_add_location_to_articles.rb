class AddLocationToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :city, :string
    add_column :articles, :state, :string
    add_column :articles, :zipcode, :string
  end
end
