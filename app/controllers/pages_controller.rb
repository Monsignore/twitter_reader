require 'fetch_followers.rb'
class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:search,:get_followers]
  def index
    
  end
  
  def search        
    @results = nil
    @message = ''
    if params[:search_name]!=""            
      begin
        @result = $twitter.user(params[:search_name])
        
        rescue Twitter::Error::NotFound
        @message = 'User not found.'      
      end
    end
    render 'pages/search-results'
  end
  
  def followers
    @users = TwitterUser.where(twitter_user_id: nil)
    @error_message = ''
    render 'pages/followers'
  end
  
  def getfollowers    
    @error_message = ''
    begin
      @twitter_user = $twitter.user(params[:follow_name])    
      
      rescue Twitter::Error::NotFound
      @error_message = 'An error occurred: user not found.'
      render 'pages/followers'
    end
    
    
    
    #uso twitter_user_id=nil per indicare che questo utente è uno di quelli che ho cercato e di cui sto scaricando i follower
    main_user = TwitterUser.where(twitter_id: @twitter_user.id,twitter_user_id: nil).take
    if main_user==nil #se l'utene non è presente vuol dire che non ho iniziato la lettura dei suoi follower
      #una volta creato l'utente posso avviare l'activejob per scaricare i dati in background
      main_user = TwitterUser.create(twitter_id: @twitter_user.id ,name: @twitter_user.name ,screen_name: @twitter_user.screen_name ,profile_image_url: @twitter_user.profile_image_url , followers_count: @twitter_user.followers_count)
      
      fetcher = FetchFollowersController.new
      fetcher.perform(main_user)
    end
    @users = TwitterUser.where(twitter_user_id: nil) #leggo la lista degli utenti padre e la passo alla pagina riepilogativa
    redirect_to action: "followers"
  end

end