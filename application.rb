Dir[File.join(File.dirname(__FILE__),"/vendor/*")].each do |l|
  $:.unshift "#{File.expand_path(l)}/lib"
end 

#require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'models/chat'
require 'models/message'
require 'models/user'
require 'sinatra'

DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/db/chat.sqlite3") 
#DataMapper.setup(:default, 'postgres://localhost/dm_chat')
#DataMapper.auto_upgrade!

enable :sessions

get '/' do
  erb :index
end

post '/' do
  @user = User.new(:name => params[:username])
  if @user.save 
    session[:user_id] = @user.id
    redirect "/chat/#{params[:room]}"
  else
    erb :index
  end
end

get '/chat/' do
  if @user = User.get(session[:user_id])
    @chat = Chat.new
    @chat.users << @user
    @chat.save
    erb :chat
  else 
    redirect '/'
  end
end

get '/chat/:id' do
  if @user = User.get(session[:user_id])
    unless @chat = Chat.get(params[:id])
      @chat = Chat.create
    end
    unless @chat.users.member? @user
      @chat.users << @user
      @chat.save
    end
    erb :chat
  else 
    redirect '/'
  end
end

get '/chat/:id/messages/:message_id' do
  @from_message = params[:message_id] || 0
  @chat = Chat.get(params[:id])
  @messages = @chat.messages.all(:id.gt => @from_message)
  erb :messages, :layout => false
end

post '/chat/:id/messages/new' do
  @chat = Chat.get(params[:id])
  @message_body = params[:message_body]
  @message = @chat.messages.create(:body => @message_body, :user_id => session[:user_id])
end

get '/chat/:id/users' do
  @chat = Chat.get(params[:id])
  @users = @chat.users
  erb :users, :layout => false
end
