import 'package:chatapp/chat/controllers/chat_controller.dart';
import 'package:chatapp/chat/models/chat_meta_model.dart';
import 'package:chatapp/chat/models/chat_model.dart';
import 'package:chatapp/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

//todo:For testing purposes not used inthe app yet
class User {
  final String id;
  final String name;
  final String lastMessage;
  final String timestamp;
  final bool isSeen;

  User({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    required this.isSeen,
  });
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<User> users = [
    User(
      id: "1",
      name: "User 1",
      lastMessage: "Hello!",
      timestamp: "12:30 PM",
      isSeen: true,
    ),
    User(
      id: "2",
      name: "User 2",
      lastMessage: "Hi there!",
      timestamp: "11:45 AM",
      isSeen: false,
    ),
    User(
      id: "3",
      name: "User 3",
      lastMessage: "Flutter is awesome!",
      timestamp: "10:15 AM",
      isSeen: true,
    ),
    User(
      id: "4",
      name: "User 4",
      lastMessage: "Hi there!",
      timestamp: "11:45 AM",
      isSeen: false,
    ),
    // Add more users as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Chats')
              .where(
                'chatsBetween',
                arrayContains: DummyUserId,
                // arrayContains: "Vinayak",
              )
              .snapshots(),
          builder: (context, snapshot) {
            print("The Snapshot : ${snapshot.data?.docs}");
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                List<ChatMetaModel> chats = snapshot.data!.docs.map((e) {
                  print("From Stream : ${e.data().toString()}");
                  return ChatMetaModel.fromJson(e.data());
                }).toList();

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        // Add user profile images here
                        child: Text(users[index].name[0]),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(chats[index]
                              .chatsBetween!
                              .firstWhere((element) => element != DummyUserId)),
                          Text(
                            chats[index].course.toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          Text(chats[index].lastMessage.toString()),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(users[index].timestamp),
                              !users[index].isSeen ? Text("seen") : Text(""),
                            ],
                          ),
                          SizedBox(width: 8.0),
                        ],
                      ),
                      onTap: () {
                        // Navigate to the chat screen when a user is tapped
                        Get.to(() => ChatDetailScreen(
                              user: users[index],
                              chatMetaModel: chats[index],
                            ));
                      },
                    );
                  },
                );
              } else {
                return Text("Empty Docs");
              }
            } else {
              return Text("Inside the last Else conditions : ${snapshot}");
            }
          }),
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  final User user;
  final ChatMetaModel chatMetaModel;
  // final ChatMetaModel chatMetaData;
  ChatDetailScreen({
    super.key,
    required this.user,
    required this.chatMetaModel,
    // required this.chatMetaData,
  });
  late MessageController messageController =
      Get.put(MessageController(chatMetaModel));

  TextEditingController _textController = TextEditingController();

  final List<ChatModel> _messages = [
    ChatModel(
      message: 'Hi there!',
      id: '1',
      timestamp: DateTime.now(),
      sender: DummyUserId,
      reciever: 'user2',
      chatRoomId: 'room1',
      chatsBetween: ['user1', 'user2'],
    ),
    ChatModel(
      message: 'Hello!',
      id: '2',
      timestamp: DateTime.now(),
      sender: 'user2',
      reciever: 'user1',
      chatRoomId: 'room1',
      chatsBetween: ['user1', 'user2'],
    ),
  ];

  Widget _buildMessage(ChatModel message) {
    return Container(
      alignment: message.sender == DummyUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      margin: EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.sender == DummyUserId ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message.message.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chatMetaModel.chatsBetween!
                .firstWhere((element) => element != DummyUserId)),
            Text(
              chatMetaModel.course.toString(),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Chat messages will be displayed here
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: messageController.messages.length,
                controller: messageController.scrollController,
                reverse: true,
                itemBuilder: (context, index) {
                  return _buildMessage(messageController.messages[index]);
                },
              ),
            ),
          ),
          // Input field for sending messages
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    // Implement logic to send the message
                    try {
                      ChatModel chat = ChatModel(
                        message: _textController.text.trim(),
                        id: '2',
                        timestamp: DateTime.now(),
                        sender: DummyUserId,
                        reciever: chatMetaModel.reciever,
                        chatRoomId: chatMetaModel.chatRoomId,
                        chatsBetween: chatMetaModel.chatsBetween,
                      );

                      await FirestoreService().addMessage(
                        chatMessage: chat,
                        course: chatMetaModel.course!,
                      );
                      _textController.clear();
                      print("Message Sent Successfully");
                    } catch (e) {
                      print("Chats Detail Screen Error : ${e.toString()}");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
