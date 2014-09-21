class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :reference_number
      t.string :url, null: false
      t.string :title, null: false
      t.timestamps
    end

    add_index :articles, :created_at
    add_index :articles, :reference_number
    add_index :articles, :title
  end
end
