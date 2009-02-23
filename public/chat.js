var Chat = {
  initialize: function() { 
    this.timeout = 3000;
    this.interval = setInterval('Chat.getMessages()', this.timeout);
    $('messageForm').observe('submit', function(e) { Chat.sendMessage(); e.stop();})
  },

  getMessages: function() {
    this.chat_id = parseInt($('chat_id').innerHTML);
    this.last_message = $$('.message').last().identify();
    this.messages_update_url = '/chat/' + this.chat_id + '/messages/' + this.last_message;
    this.updater = new Ajax.Updater('messages', this.messages_update_url, {
      method: 'get',
      insertion: Insertion.Bottom
    });
    $$('.message').last().scrollTo();
    this.updateUsers();
  },

  sendMessage: function() {
    var message_body = $('newMessage').getValue();
    this.request_url = '/chat/' + this.chat_id + '/messages/new'; 
    if (message_body != "") {
      new Ajax.Request(this.request_url, { parameters: { message_body: message_body } });
      $('newMessage').clear().focus();
    }
  },

  updateUsers: function() {
    this.users_update_url = '/chat/' + this.chat_id + '/users'
    this.updater = new Ajax.Updater('users', this.users_update_url, {
      method: 'get'
    });
  }

}

//function loadMessages() {
  //var remote_link = '/chat/' + chat_id + '/messages/since/0';
  //new Ajax.Updater('messages', remote_link);
  //}

  //function getMessages() {
    //get_last_id();
    //if (new_last_id != last_id) {
      //var remote_link = '/chat/' + chat_id + '/messages/since/' + last_id;
      //new Ajax.Updater($('messages'), remote_link, { insertion: Insertion.Bottom}); 
      //last_id = new_last_id;
      //}
      //}

      //function sendMessage() { 
        //var remote_link = '/chat/' + chat_id + '/messages/new';
        //var message = $('message_box').getValue();
        //if (message != "")
        //new Ajax.Request( remote_link, { parameters: { message: message, chat_id: chat_id } }); 
        //$('message_box').clear().focus(); 
        //get_last_id();
        //last_id = new_last_id;
        //}

        //function get_last_id() {
          //var get_last_id_url = '/chat/' + chat_id + '/messages/last';
          //new Ajax.Request(get_last_id_url, { 
            //onSuccess: function(xhr) {
              //new_last_id = parseInt(xhr.responseText);
              //}
              //});
              //}

              //function getUserList() {
                //var userlist_url = '/chat/' + chat_id + '/users';
                //new Ajax.Updater('userlist', userlist_url, { parameters: chat_id}); 
                //}

                //function removeUser() {
                  //remove_user_url = '/logout'
                  //new Ajax.Request(remove_user_url);
                  //}

