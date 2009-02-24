#Dir[File.join(File.dirname(__FILE__),"/vendor/*")].each do |l|
#$:.unshift "#{File.expand_path(l)}/lib"
#end 

require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'models/chat'
require 'models/message'
require 'models/user'
require 'sinatra'

#DataMapper.setup(:default, "sqlite3::memory:") 
#DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/chat.sqlite3") 
DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
DataMapper.auto_upgrade!

enable :sessions

unless defined?EventMachine
  Thread.new do
    while true
      clean_chat_rooms
      sleep(60)
    end
  end
else
  EventMachine::add_periodic_timer(60) do
    clean_chat_rooms
  end
end

def clean_chat_rooms
  Chat.all.each do |chat|
    if chat.users.count > 0
      chat.users.each do |user|
        if Time.now - user.last_poll.to_time > 60
          user.destroy
        end
      end
    else 
      chat.messages.destroy!
      chat.destroy
    end
  end
end

get '/' do
  erb :index
end

post '/' do
  @user = User.new(:name => params[:username])
  @user.last_poll = Time.now
  if @user.save 
    session[:user_id] = @user.id
    redirect "/chat/#{params[:room]}"
  else
    erb :index
  end
end

get '/chat/' do
  if @user = User.get(session[:user_id])
    @chat = Chat.new :name => (rand*100000).to_i.to_s
    @chat.users << @user
    @chat.save
    redirect "/chat/#{@chat.name}"
  else 
    redirect '/'
  end
end

get '/chat/:name' do
  if @user = User.get(session[:user_id])
    unless @chat = Chat.first(:name => params[:name])
      @chat = Chat.create(:name => params[:name])
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

get '/chat/:name/messages/:message_id' do
  @from_message = params[:message_id] || 0
  @chat = Chat.first(:name => params[:name])
  @messages = @chat.messages.all(:id.gt => @from_message)
  erb :messages, :layout => false
end

post '/chat/:name/messages/new' do
  @chat = Chat.first(:name => params[:name])
  @message_body = params[:message_body]
  @message = @chat.messages.create(:body => @message_body, :user_id => session[:user_id])
end

get '/chat/:name/users' do
  @chat = Chat.first(:name => params[:name])
  @users = @chat.users
  @user = User.get(session[:user_id])
  @user.update_attributes(:last_poll => Time.now)
  erb :users, :layout => false
end

post '/chat/logout' do
  @user = User.get(session[:user_id])
  @user.destroy
end
