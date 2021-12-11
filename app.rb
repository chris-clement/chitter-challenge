require 'sinatra'
require 'sinatra/reloader'
require './lib/peep'
require './lib/sign_up'
require './database_connection_setup'

class Chitter < Sinatra::Base

  configure :development do 
    register Sinatra::Reloader
  end

  get '/' do 
    @peeps = Peep.all
    erb :index
  end

  post '/peep' do
    Peep.create(text: params[:text], user_name: params[:user_name], handle: params[:handle], time_posted: Time.new)
    redirect '/'
  end

  get '/sign_up' do
    erb :sign_up
  end

  post '/confirm_sign_up' do
    @user_sign_up = SignUp.create(email: params[:email], password: params[:password], user_name: params[:user_name], handle: params[:handle])
    erb :confirm_sign_up
  end

  get '/log_in' do
    erb :log_in
  end

  post '/confirm_log_in' do
    if SignUp.log_in_verified?(email: params[:email], password: params[:password])
      @user_name = SignUp.find_user_name(email: params[:email])
      erb :confirm_log_in
    else
      erb :bad_log_in
    end
  end

end
