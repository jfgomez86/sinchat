class Chat
  include DataMapper::Resource 
  property  :id,  Integer, :serial => true
  property  :name, String
  has n,    :messages
  has n,    :users
end
