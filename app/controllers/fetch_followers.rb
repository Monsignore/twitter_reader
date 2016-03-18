class FetchFollowersController < ApplicationController
  #questa classe ha l'unico scopo di leggere i follower, avrei potuto mettere il metodo perform nel pages_controller, ma mi sembrava un po'
  #fuoriluogo
  def perform(main_user)    
    cursor = -1    
    while cursor!=0 do      
      begin
        $twitter.followers(main_user.twitter_id,:cursor=>cursor,:count=>200).each do |follower|          
          if TwitterUser.where(twitter_id: follower.id,twitter_user_id: main_user.id).take==nil #se il follower non è già presente lo creo
            main_user.followers.create(twitter_id: follower.id ,name: follower.name ,screen_name: follower.screen_name ,profile_image_url: follower.profile_image_url , followers_count: follower.followers_count)
          end
        end        
      rescue Twitter::Error::TooManyRequests => error      
        sleep error.rate_limit.reset_in + 1 #metto in attesa fino a quando le api non saranno di nuovo disponibili
        retry    
      end        
    end
  end
  
  handle_asynchronously :perform #il metodo perform verrà eseguito in modo asincrono tramite delayed_job  
end
