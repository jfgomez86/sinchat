class Message
  include DataMapper::Resource 
  property  :id,    Serial 
  property  :body,  Text
  property  :from, String
  belongs_to :chat
  belongs_to :user

  before :create, :save_from

  private
  def save_from
    self.from = self.user.name
  end
end
