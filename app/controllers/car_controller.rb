class CarsController < ApplicationController
  get '/cars' do
    erb :'/cars/cars'
  end
end
