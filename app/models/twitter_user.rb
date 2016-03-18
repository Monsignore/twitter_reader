class TwitterUser < ActiveRecord::Base
  has_many :followers, class_name: "TwitterUser", foreign_key: "twitter_user_id", :dependent => :delete_all
  belongs_to :parent, class_name: "TwitterUser", foreign_key: "twitter_user_id"                                                  
end
