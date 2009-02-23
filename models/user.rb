require 'md5'
class User

  include DataMapper::Resource 
  property  :id,    Serial
  property  :name,  String, :nullable => false,
    :messages => {
                  :presence => "El nombre no puede estar en blanco."
    }

  belongs_to :chat 
  has n, :messages

  def exit_chat
    self.update_attributes :chat_id => nil
  end

end
