// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  String? message;
  String? id;
  DateTime? timestamp;
  String? sender;
  String? reciever;
  String? chatRoomId;
  List<String>? chatsBetween;

  ChatModel({
    this.message,
    this.id,
    this.timestamp,
    this.sender,
    this.reciever,
    this.chatRoomId,
    this.chatsBetween,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        message: json["message"],
        id: json["ID"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        sender: json["sender"],
        reciever: json["reciever"],
        chatRoomId: json["chatRoomId"],
        chatsBetween: List<String>.from(json["chatsBetween"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "ID": id,
        "timestamp": timestamp?.toIso8601String(),
        "sender": sender,
        "reciever": reciever,
        "chatRoomId": chatRoomId,
        "chatsBetween": chatsBetween
      };
}
