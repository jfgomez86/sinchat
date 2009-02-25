var Chat = {
  initialize: function() { 
    this.messageTimeout = 5000;
    this.userTimeout = 12000;
    this.interval = setInterval(this.checkForNewMessages.bind(this), this.messageTimeout);
    this.interval = setInterval(this.checkUsers.bind(this), this.userTimeout);
    $('messageForm').observe('submit', function(e) { Chat.sendMessage(); e.stop();})
    $('soundControl').observe('click', function(e) { Chat.soundControl(e) } )
    Event.observe(window, 'load', function(e) { Chat.getNewMessages(); Chat.updateUsers(); });
    Chat.observeSmileys();
  },

  getNewMessages: function() {
    this.chat_id = $('chat_id').innerHTML;
    this.last_message = $$('.message').last().identify();
    this.messages_update_url = '/chat/' + this.chat_id + '/messages/' + this.last_message;
    if (this.messagesUpdater) {
      this.messagesUpdater.transport.abort();
    }
    this.messagesUpdater = new Ajax.Updater('messages', this.messages_update_url, {
      method: 'get',
      insertion: Insertion.Bottom,
      asynchronus: true,
      onComplete: function() {
        new Effect.Highlight($$('.message').last());
        Chat.playSound();
        $('messages').scrollTop = $('messages').scrollHeight;
      }
    });
  },

  sendMessage: function() {
    var message_body = $('newMessage').getValue();
    this.request_url = '/chat/' + this.chat_id + '/messages/new'; 
    if (message_body != "") {
      new Ajax.Request(this.request_url, { 
        parameters: { message_body: message_body },
        asynchronus: true
      });
      Chat.checkForNewMessages();
      $('newMessage').clear().focus();
    }
  },

  updateUsers: function() {
    this.users_update_url = '/chat/' + this.chat_id + '/users'
    if (this.usersUpdater) {
      this.usersUpdater.transport.abort();
    }
    this.usersUpdater = new Ajax.Updater('users', this.users_update_url, {
      method: 'get',
      asynchronus: true
    });
  },

  checkForNewMessages: function() { 
    this.chat_id = $('chat_id').innerHTML;
    this.last_message = $$('.message').last().identify();
    this.messages_check_url = '/chat/' + this.chat_id + '/new_messages/' + this.last_message;
    if (this.checker) {
      this.checker.transport.abort();
    }
    this.checker = new Ajax.Request(this.messages_check_url, {
      method: 'get',
      asynchronus: true,
      onSuccess:  function(xhr) {
        messages = xhr.responseXML.getElementsByTagName('new_messages');
        new_messages = messages[0].firstChild.nodeValue;
        if (new_messages > 0) {
          Chat.getNewMessages();
        }
      }
    });
  },

  checkUsers: function() {
    this.users_check_url = '/chat/' + this.chat_id + '/checkusers/'
    if (this.usersCheckerj) {
      this.usersChecker.transport.abort();
    }
    this.usersChecker = new Ajax.Request(this.users_check_url, {
      method: 'get',
      asynchronus: true,
      onSuccess: function(xhr) {
        users = xhr.responseXML.getElementsByTagName('user_count');
        new_users = users[0].firstChild.nodeValue;
        if (new_users != $$('.user').length) {
          Chat.updateUsers();
        }
      }
    });
  },

  playSound: function() {
    wav_url = "/misc/new_message.mp3"
    Sound.play(wav_url,{replace:true});
  },

  observeSmileys: function() {
    $$('.smiley').map(function (e) { 
      Event.observe(e, 'click', function() { 
        $('newMessage').value += e.firstChild.title; 
        $('newMessage').focus();
      }) 
    });
  },

  soundControl: function() {
    if ($('soundControl').getValue() == "on")
      Sound.enable();
    else
      Sound.disable();
  }
}
