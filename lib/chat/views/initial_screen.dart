import 'package:chatapp/chat/views/chats_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
//todo:For testing purposes not used inthe app yet

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  TextEditingController _textEditingController = TextEditingController();
  String _typedText = '';

  TextEditingController _courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Input Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: 'Type User Name...',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _courseController,
              decoration: InputDecoration(
                hintText: 'Type Course Name...',
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _typedText = _textEditingController.text;
                    });
                  },
                  child: Text('Get Text'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    //Step 1: Generate ChatRoomId if not generated
                    await FirestoreService().generateChatRoomToDatabase(
                        sender: _textEditingController.text,
                        course: _courseController.text);

                    //Step 2: Navigate to New Screen
                    Get.to(() => ChatScreen());
                  },
                  child: Text('Navigate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
