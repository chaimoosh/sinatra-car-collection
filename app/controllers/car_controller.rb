class CarsController < ApplicationController
  get '/cars' do
    if logged_in?
      @cars = Car.find_by(:user_id => session[:user_id])
      erb :'/cars/cars'
    else
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
      redirect to "/cars"
    else
      @car.update(params)
      @car.save
    end
  end

  post '/cars' do
    @car = Car.new(params)
    if @car.make.empty? || @car.model.empty?
      redirect to "/cars/new"
    else
      @car.user_id = session[:user_id]
      @car.save
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
