class MessageModel {
  String? message;
  var type;
  String? time;
  String? senderId;
  String? recieverId;
  String? messageId;
  String? imageUrl;

  MessageModel(
      {this.message,
      this.messageId,
      this.recieverId,
      this.senderId,
      this.time,
      this.imageUrl,
      this.type});

  factory MessageModel.fromjson(Map<String, dynamic> json) => MessageModel(
      message: json['message'],
      type: json['type'],
      senderId: json['senderId'],
      recieverId: json['recieverId'],
      messageId: json['messageId'],
      imageUrl: json['imageUrl'],
      time: json['time']);

  Map<String, dynamic> toJson() => {
        'message': message,
        'type': type,
        'senderId': senderId,
        'recieverId': recieverId,
        'messageId': messageId,
        'time': time,
        'imageUrl': imageUrl
      };
}
