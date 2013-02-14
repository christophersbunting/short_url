require 'sinatra'
require 'redis'
require 'pry'

helpers do
	def shortlink_token
		(Time.now.to_i + rand(36**8)).to_s(36)
	end
end

get '/' do
	erb :index
end

post '/' do
  unless (params[:url] =~ URI::regexp).nil?
    @token = shortlink_token
    @redis = Redis.new
    @redis.set("links:#{@token}", params[:url])
    erb :shortened
  else
    @error = "Please enter a valid URL."
    erb :index
  end
end

get '/:token/?' do
  @redis = Redis.new
  url = @redis.get("links:#{params[:token]}")
  unless url.nil?
      redirect(url)
  end
  erb :expired
end