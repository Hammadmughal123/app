import 'dart:convert';

import 'package:app/model/user_model.dart';

class ChatRoomModel {
  UserModel? sender;
  UserModel? receiver;
  String? lastMessage;
  String? lastSeen;
  String? chatRoomId;

  ChatRoomModel({
    this.sender,
    this.receiver,
    this.chatRoomId,
    this.lastMessage,
    this.lastSeen,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
        sender:
            json['sender'] != null ? UserModel.fromMap(json['sender']) : null,
        receiver: json['receiver'] != null
            ? UserModel.fromMap(json['receiver'])
            : null,
        chatRoomId: json['chatRoomId'],
        lastMessage: json['lastMessage'],
        lastSeen: json['lastSeen'],
      );

  Map<String, dynamic> toJson() => {
        'sender': sender != null ? sender!.toMap() : null,
        'receiver': receiver != null ? receiver!.toMap() : null,
        'chatRoomId': chatRoomId,
        'lastMessage': lastMessage,
        'lastSeen': lastSeen,
      };
}
