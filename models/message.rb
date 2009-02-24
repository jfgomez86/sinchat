class Message
  include DataMapper::Resource 
  property  :id,    Serial 
  property  :body,  Text
  property  :from, String
  property  :created_at, Time
  property  :usercolor, String
  belongs_to :chat
  belongs_to :user

  before  :create, :save_from
  before  :create, :log_time
  before  :create,  :set_color

  private
  def save_from
    self.from = self.user.name
  end

  def log_time
    self.created_at = Time.now
  end

  def set_color
    self.usercolor = self.user.color
  end

end
