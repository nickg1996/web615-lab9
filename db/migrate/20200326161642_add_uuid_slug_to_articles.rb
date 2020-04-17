class AddUuidSlugToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :uuid, :string, unique: true
    add_column :articles, :slug, :string, unique: true
  end
end
