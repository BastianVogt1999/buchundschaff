class Message {
  String message_id;
  String user_name;
  String message_text;
  String date;
  String time;

  Message(this.message_id, this.user_name, this.message_text, this.date, this.time);

  Message.empty() : this("","","", "", "");

  
}