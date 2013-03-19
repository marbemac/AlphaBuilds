require 'compass'
require 'sinatra'
require 'sinatra/cache'
require 'slim'
require 'json'
require 'pony'
require "sinatra/reloader" if development?

set :root, File.dirname(__FILE__)
set :cache_output_dir, Proc.new { File.join(root, 'public', 'cache') }
set :cache_enabled, true

configure do
  set :scss, {:style => :expanded, :debug_info => true}
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.rb'))

  Pony.options = {
      :to => 'marbemac@gmail.com,matt.c.mccormick@gmail.com,siddiqi28@gmail.com',
      :via => :smtp,
      :via_options => {
          :address => "smtp.sendgrid.net",
          :port => '587',
          :authentication => :plain,
          :user_name => 'marbemac',
          :password => 'giants22',
          :domain => 'alphabuilds.com',
      }
  }
end

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss(:"stylesheets/#{params[:name]}" )
end

post '/inquiry' do
  content_type :json

  @name = params[:name]
  @email = params[:email]
  @phone_number = params[:phone_number]
  @budget = params[:budget]
  @timeframe = params[:timeframe]
  @description = params[:description]

  if @name && @name.strip.length > 0 && @email && @email.strip.length > 0 && @budget && @budget.strip.length > 0 && @timeframe && @timeframe.strip.length > 0 && @description && @description.strip.length > 0
    Pony.mail :from => @email,
              :reply_to => @email,
              :subject => 'New AlphaBuilds Inquiry!',
              :html_body => slim(:inquiry)

    {:status => :ok}.to_json
  else
    {:status => :error}.to_json
  end
end

get '/' do
  slim :home
end