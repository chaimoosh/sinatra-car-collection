require 'sinatra/flash'
class UsersController < ApplicationController
  get '/signup' do
    if logged_in?
      redirect to "/cars"
    else
      erb :'/users/signup'
    end
  end

  post '/signup' do
    @user = User.new(:username => params["username"], :name => params["name"], :password => params["password"])
    @car = Car.new(:year => params["year"], :make => params["make"], :model => params["model"], :description => params["description"])
    if @user.username.empty? || @user.name.empty? || @user.password_digest == nil || @car.make.empty? || @car.model.empty?
      flash[:notice] = "Please fill out all fields to continue"
      redirect to "/signup"
    else
      @user.save
      @car.user_id = @user.id
      @car.save
      session[:user_id] = @user.id
      flash[:notice] = "You are now logged in as #{@user.name}"
      redirect to "/cars"
    end
  end

  get '/login' do
    if logged_in?
      redirect to "/cars"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params["username"])
    if @user == nil || !@user.authenticate(params[:password])
      flash[:notice] = "Please fill out all fields to continue"
      redirect to "/signup"
    else
      session[:user_id] = @user.id
      flash[:notice] = "You are now logged in as #{@user.name}"
      redirect to "/cars"
    end
  end

  get '/logout' do
    session.clear
    flash[:notice] = "You are now logged out"
    redirect to "/login"
  end

  get '/users/:user_slug' do
    erb :'/users/show'
  end
end
