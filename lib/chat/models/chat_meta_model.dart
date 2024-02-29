// To parse this JSON data, do
//
//     final chatMetaModel = chatMetaModelFromJson(jsonString);

import 'dart:convert';

ChatMetaModel chatMetaModelFromJson(String str) =>
    ChatMetaModel.fromJson(json.decode(str));

String chatMetaModelToJson(ChatMetaModel data) => json.encode(data.toJson());

class ChatMetaModel {
  String? lastMessage;
  String? id;
  DateTime? timestamp;
  String? sentBy;
  List<String>? seen;
  String? sender;
  String? reciever;
  String? chatRoomId;
  List<String>? chatsBetween;
  bool? firstChat;
  String? course;

  ChatMetaModel({
    this.lastMessage,
    this.id,
    this.timestamp,
    this.sentBy,
    this.seen,
    this.sender,
    this.reciever,
    this.chatRoomId,
    this.chatsBetween,
    this.firstChat,
    this.course,
  });

  factory ChatMetaModel.fromJson(Map<String, dynamic> json) => ChatMetaModel(
        lastMessage: json["lastMessage"],
        id: json["ID"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        sentBy: json["sentBy"],
        seen: json["seen"] == null
            ? []
            : List<String>.from(json["seen"]!.map((x) => x)),
        sender: json["sender"],
        reciever: json["reciever"],
        chatRoomId: json["chatRoomId"],
        chatsBetween: json["chatsBetween"] == null
            ? []
            : List<String>.from(json["chatsBetween"]!.map((x) => x)),
        firstChat: json["firstChat"],
        course: json["course"],
      );

  Map<String, dynamic> toJson() => {
        "lastMessage": lastMessage,
        "ID": id,
        "timestamp": timestamp?.toIso8601String(),
        "sentBy": sentBy,
        "seen": seen == null ? [] : List<dynamic>.from(seen!.map((x) => x)),
        "sender": sender,
        "reciever": reciever,
        "chatRoomId": chatRoomId,
        "chatsBetween": chatsBetween == null
            ? []
            : List<dynamic>.from(chatsBetween!.map((x) => x)),
        "firstChat": firstChat,
        "course": course,
      };
}
