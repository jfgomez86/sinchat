require 'md5'
class User

  include DataMapper::Resource 
  property  :id,    Serial
  property  :name,  String, :nullable => false,
    :messages => {
                  :presence => "El nombre no puede estar en blanco."
    }
  property  :last_poll, DateTime
  property  :color, String

  belongs_to :chat 
  has n, :messages

  before  :create,  :set_color

  def exit_chat
    self.update_attributes :chat_id => nil
  end

  private
  def set_color
    self.color = User.get_random_color
  end

  def self.get_random_color
    c1 = (rand*256).to_i
    c2 = (rand*256).to_i
    c3 = (rand*256).to_i
    return "rgb(#{[c1,c2,c3].join(",")})"
  end

end
