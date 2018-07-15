class AddHumanToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :human, :boolean
  end
end
