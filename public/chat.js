var Chat = {
  initialize: function() { 
    this.timeout = 5000;
    this.interval = setInterval('Chat.getMessages()', this.timeout);
    $('messageForm').observe('submit', function(e) { Chat.sendMessage(); e.stop();})
    Event.observe(window, 'unload', function(e) { Chat.logOut();})
    Event.observe(window, 'load', function(e) { Chat.getMessages(); })
  },

  getMessages: function() {
    this.chat_id = $('chat_id').innerHTML;
    this.last_message = $$('.message').last().identify();
    this.messages_update_url = '/chat/' + this.chat_id + '/messages/' + this.last_message;
    this.updater = new Ajax.Updater('messages', this.messages_update_url, {
      method: 'get',
      insertion: Insertion.Bottom
    });
    this.updateUsers();
    $('messages').scrollTop = $('messages').scrollHeight;
  },

  sendMessage: function() {
    var message_body = $('newMessage').getValue();
    this.request_url = '/chat/' + this.chat_id + '/messages/new'; 
    if (message_body != "") {
      new Ajax.Request(this.request_url, { parameters: { message_body: message_body } });
      Chat.getMessages();
      $('newMessage').clear().focus();
    }
  },

  updateUsers: function() {
    this.users_update_url = '/chat/' + this.chat_id + '/users'
    this.updater = new Ajax.Updater('users', this.users_update_url, {
      method: 'get'
    });
  },

  logOut: function() {
    //this.logout_url = "/chat/logout"
    //new Ajax.Request(this.logout_url);
  }
}
