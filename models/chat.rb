class Chat
  include DataMapper::Resource 
  property  :id,  Integer, :serial => true
  has n,    :messages
  has n,    :users
end
