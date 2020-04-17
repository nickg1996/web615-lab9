class AddSlugUuidToCommentsArticles < ActiveRecord::Migration[5.2]
  def change
    #Add uuid and slug columns to comments table
    add_column :comments, :slug, :string
    add_column :comments, :uuid, :string
    add_index :comments, :slug, unique: true
    add_index :comments, :uuid, unique: true

    #Add uuid and slug columns to articles table
    add_column :articles, :slug, :string
    add_column :articles, :uuid, :string
    add_index :articles, :slug, unique: true
    add_index :articles, :uuid, unique: true


    #==================The following iterate to call Comment and Article model create uuid and slug
    # ++++++++++++++++But i create a new Container and Image separately, It will call Seed
    # +++++++++++in Seed it will call models to create slug and uuid, So i comment following:
    # Comment.find_each do |comment|
    #   comment.uuid=SecureRandom.uuid
    #   comment.slug=comment.uuid
    #   comment.save
    # end
    #
    #
    # Article.find_each do |article|
    #   article.uuid=SecureRandom.uuid
    #   article.slug=comment.uuid
    #   article.save
    # end
  end
end
