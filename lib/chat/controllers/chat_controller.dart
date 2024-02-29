import 'dart:async';

import 'package:chatapp/chat/models/chat_meta_model.dart';
import 'package:chatapp/chat/models/chat_model.dart';
import 'package:chatapp/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Generate ChatRoomId
  String generateChatRoomId(
      {required String user1, required String user2, required String course}) {
    final sortedMembers = [user1, user2, course]
      ..sort((a, b) => a.compareTo(b));

    String chatRoomId =
        "${sortedMembers[0]}_${sortedMembers[1]}_${sortedMembers[2]}";

    return chatRoomId;
  }

  String generateUniqueID() {
    return Uuid().v1();
  }

  Future<void> generateChatRoomToDatabase(
      {required String sender, required String course}) async {
    try {
      String chatRoomId =
          generateChatRoomId(user1: sender, user2: "MyId", course: course);
      ChatMetaModel chatMetaModel = ChatMetaModel();

      // String chatRoomId =
      "6c84fb90-12c4-11e1-840d-7b25c5ee775a_6c84fb90-12c4-11e1-840d-7b25c5ee775a_6c84fb90-12c4-11e1-840d-7b25c5ee775a";
      chatMetaModel.id = generateUniqueID();
      chatMetaModel.chatRoomId = chatRoomId;
      chatMetaModel.sender = "MyId";
      chatMetaModel.reciever = sender;
      chatMetaModel.chatsBetween = [sender, "MyId"];
      chatMetaModel.firstChat = true;
      chatMetaModel.timestamp = DateTime.now();
      chatMetaModel.sentBy = "MyId";
      chatMetaModel.course = course;
      chatMetaModel.seen = ["MyId"];

      await _firestore
          .collection('Chats')
          .doc(chatRoomId)
          .set(chatMetaModel.toJson());
    } catch (e) {
      print('Error Generating ChatRoom to Database: $e');
      rethrow;
    }
  }

  // Add a new message to the Firestore collection
  Future<void> addMessage(
      {required ChatModel chatMessage,
      bool firstChat = true,
      required String course}) async {
    try {
      // chatp

      chatMessage.id = generateUniqueID();

      String chatRoomId = generateChatRoomId(
          user1: DummyUserId,
          user2: chatMessage.chatsBetween!
              .firstWhere((element) => element != DummyUserId),
          course: course);
      await _firestore
          .collection('Chats')
          .doc(chatRoomId)
          .collection("Messages")
          .doc(chatMessage.id)
          .set(
            chatMessage.toJson(),
          );
      ChatMetaModel chatMetaModel = ChatMetaModel(
        chatRoomId: chatMessage.chatRoomId,
        chatsBetween: chatMessage.chatsBetween,
        id: chatMessage.id,
        lastMessage: chatMessage.message,
        reciever: chatMessage.reciever,
        seen: ["MyId"],
        sender: chatMessage.sender,
        sentBy: "MyId", // FirebaseAuth . userID
        timestamp: chatMessage.timestamp,

        //This needs to be checked what to pass from the View / Screen
        firstChat: firstChat,
        course: course,
      );

      await _firestore.collection('Chats').doc(chatRoomId).set(
            chatMetaModel.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      print('Error adding Chat: $e');
      throw Exception('Failed to add message');
    }
  }

  // Get messages between two users
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages({
    required String user1Id,
    required String user2Id,
    required String course,
  }) {
    try {
      String chatRoomId =
          generateChatRoomId(user1: user1Id, user2: user2Id, course: course);
      return _firestore
          .collection('Chats')
          .doc(chatRoomId)
          .collection("Messages")
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      print('Error getting messages: $e');
      rethrow; // Re-throw the exception
    }
  }

  // Mark a message as seen
  Future<void> markMessageAsSeen(String messageId) async {
    try {
      await _firestore.collection('messages').doc(messageId).update({
        'seen': true,
      });
    } catch (e) {
      print('Error marking message as seen: $e');
      throw Exception('Failed to mark message as seen');
    }
  }

  Future<List<ChatMetaModel>> getAllChats(String userId) async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID is required.');
      }

      final QuerySnapshot<Map<String, dynamic>> chatsSnapshot =
          await FirebaseFirestore.instance
              .collection('Chats')
              .where('chatsBetween', arrayContains: userId)
              .get();

      final List<ChatMetaModel> chats = [];
      chatsSnapshot.docs.forEach((doc) {
        final Map<String, dynamic> chatData = doc.data();
        chats.add(ChatMetaModel.fromJson(chatData));
      });

      return chats;
    } catch (error) {
      print('Error getting All chats: $error');
      // Handle error or throw it further as needed
      rethrow;
    }
  }
}

class MessageController extends GetxController {
  MessageController(this.chatMetaModel);

  final messages = <ChatModel>[].obs;
  final docsMessage = <DocumentSnapshot>[].obs;
  final pageSize = 10;
  late ScrollController scrollController;
  final ChatMetaModel chatMetaModel;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> chatStream;
  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_scrollListener);

    getInitialMessages();
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      // Load more messages when the user reaches the end of the list
      getMoreMessages(chatRoomId: chatMetaModel.chatRoomId!);
    }
  }

  void getInitialMessages() {
    // Listen to real-time changes for the first batch of messages
    chatStream = FirebaseFirestore.instance
        .collection('Chats')
        .doc(chatMetaModel.chatRoomId)
        .collection("Messages")
        .orderBy('timestamp', descending: true)
        .limit(pageSize)
        .snapshots()
        .listen((snapshot) {
      // Add messages to the list
      if (docsMessage.isEmpty) {
        //
        docsMessage.addAll(snapshot.docs);
      }
      messages.insertAll(0, snapshot.docs.map((doc) {
        return ChatModel(
          id: doc.id,
          message: doc['message'],
          // timestamp: doc['timestamp'].toDate(),
          sender: doc['sender'],
          reciever: doc['reciever'],
          chatRoomId: doc['chatRoomId'],
          chatsBetween: List<String>.from(doc['chatsBetween']),
        );
      }));
    });
  }

  Future<void> getMoreMessages({required String chatRoomId}) async {
    // Fetch more messages when the user scrolls
    final QuerySnapshot<Map<String, dynamic>> snapshot;

    if (docsMessage.isNotEmpty) {
      snapshot = await FirebaseFirestore.instance
          .collection('Chats')
          .doc(chatRoomId)
          .collection("Messages")
          .orderBy('timestamp', descending: true)
          .startAfterDocument(docsMessage.last)
          .limit(pageSize)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('Chats')
          .doc(chatRoomId)
          .collection("Messages")
          .orderBy('timestamp', descending: true)
          .limit(pageSize)
          .get();
    }

    if (snapshot.docs.isNotEmpty) {
      // Add more messages to the list
      docsMessage.addAll(snapshot.docs);

      // if(messages.){

      // }

      messages.addAll(snapshot.docs.map((doc) {
        final data = doc.data();

        return ChatModel.fromJson(data);
      }).toList());
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    chatStream.cancel();
    super.onClose();
  }
}
