class TweetsController < ApplicationController
 get '/tweets' do
   if logged_in?
     @tweets = Tweet.all
     erb :'/tweets/tweets'
   else
     redirect to "/login"
   end
 end

 get '/tweets/new' do
   if logged_in?
     @user = User.find_by_id(session[:user_id])
     erb :'/tweets/create_tweet'
   else
     redirect to "/login"
   end
 end

 get '/tweets/:id' do
   if logged_in?
     @tweet = Tweet.find_by_id(params[:id])
     erb :'/tweets/show_tweet'
   else
     redirect to "/login"
   end
 end

 post '/tweets' do
   if params["content"].empty?
     redirect to "/tweets/new"
   else
     @tweet = Tweet.create(:content => params["content"], :user_id => session[:user_id])
     redirect to "/tweets"
   end
 end

 get '/tweets/:id/edit' do
   if logged_in?
     @tweet = Tweet.find_by_id(params[:id])
     erb :'/tweets/edit_tweet'
   else
     redirect to "/login"
   end
 end

 patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
   if params["content"].empty?
     redirect to "/tweets/#{@tweet.id}/edit"
   else
     @tweet.update(content: params[:content])
     @tweet.save
     redirect to "/tweets/#{@tweet.id}"
   end
end

 delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    #binding.pry
    if session[:user_id] == @tweet.user_id
      @tweet.destroy
      redirect to "/tweets"
    else
      redirect to "/tweets/#{@tweet.id}"
    end
 end
end
