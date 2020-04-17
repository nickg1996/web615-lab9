class AddUuidSlugToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :uuid, :string, unique: true
    add_column :comments, :slug, :string, unique: true
  end
end
