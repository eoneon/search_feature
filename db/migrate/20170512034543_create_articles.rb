class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.integer :status
      t.string :author
      t.string :website
      t.string :meta_title
      t.text :meta_description

      t.timestamps null: false
    end
  end
end
