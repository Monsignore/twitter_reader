class CreateTwitterUsers < ActiveRecord::Migration
  def change
    create_table :twitter_users do |t|
      t.integer :twitter_id, :limit=>8
      t.string :name
      t.string :screen_name
      t.string :profile_image_url
      t.integer :followers_count      
      #t.boolean :searched, :default => false
      t.integer :twitter_user_id, :default => 0
      t.belongs_to :twitter_user, index:true
      t.timestamps
    end
  end
end
