require 'sinatra/flash'
class CarsController < ApplicationController
  get '/cars' do
    if logged_in?
      @user = User.find_by_id(session[:user_id])
      @cars = @user.cars
      flash[:notice] = "Hello #{@user.name}"
      erb :'/cars/cars'
    else
      flash[:notice] = "You must login to view that page"
      redirect to "/"
    end
  end

  get '/cars/new' do
    if logged_in?
      erb :'/cars/create_cars'
    else
      redirect to "/"
    end
  end

  get '/cars/:slug' do
    if logged_in?
      @car = Car.find_by_slug(params[:slug])
      erb :'/cars/show_cars'
    else
      flash[:notice] = "You must login to view that page"
      redirect to "/"
    end
  end

  get '/cars/:slug/edit' do
    @car = Car.find_by_slug(params[:slug])
    if logged_in? && @car.user_id == session[:user_id]
      erb :'/cars/edit_cars'
    else
      redirect to "/"
    end
  end

  patch '/cars/:slug' do
    @car = Car.find_by_slug(params[:slug])
    if params["year"].empty? && params["make"].empty? && params["model"].empty? && params["description"].empty?
      flash[:notice] = "Please fill out all fields to edit your car"
      redirect to "/cars/#{@car.slug}/edit"
    else
      @car.update(:year => params["year"], :make => params["make"], :model => params["model"], :description => params["description"])
      @car.save
      flash[:notice] = "You have succesfully updated your car"
      redirect to "/cars/#{@car.slug}"
    end
  end

  post '/cars' do
    @car = Car.new(params)
    if @car.make.empty? || @car.model.empty?
        flash[:notice] = "Please fill out all fields to add your car"
      redirect to "/cars/new"
    else
      @car.user_id = session[:user_id]
      @car.save
      flash[:notice] = "You have succesfully added a car"
      redirect to "/cars/#{@car.slug}"
    end
  end

  delete '/cars/:slug/delete' do
   @car = Car.find_by_slug(params[:slug])
   if session[:user_id] == @car.user_id
     @car.destroy
     redirect to "/cars"
   else
     redirect to "/car/#{@car.slug}"
   end
end
end
