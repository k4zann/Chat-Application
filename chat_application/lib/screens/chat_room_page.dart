import 'package:chat_application/main.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:models/src/chat_room.dart';

import '../widget/avatar.dart';
import '../widget/messageBubble.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key, required this.chatRoom}) : super(key: key);

  final ChatRoom chatRoom;

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> messages = [];

  @override
  void initState() {
    _loadMessages();
    _startWebSocket();

    msgRepo.subscribeToMessageUpdates((messageData) {
      final message = Message.fromJson(messageData);
      if (message.chatRoomId == widget.chatRoom.id) {
        messages.add(message);
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        setState(() {});
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = Message(
      chatRoomId: widget.chatRoom.id,
      senderUserId: userId1,
      receiverUserId: userId2,
      content: _messageController.text,
      createdAt: DateTime.now(),
    );
    await msgRepo.createMessage(message);
    _messageController.clear();
  }

  _loadMessages() async {
    final _messages = await msgRepo.fetchMessages(widget.chatRoom.id);

    _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    setState(() {
      messages.addAll(_messages);
    });
  }

  _startWebSocket() {
    webSocketClient.connect(
      'ws://192.168.0.14:8080/websocket',
      {
        'Authorization': 'Bearer ....',
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final currentUser = widget.chatRoom.participants.firstWhere(
        (user) => user.id == userId1
    );
    final otherUser = widget.chatRoom.participants.firstWhere(
        (user) => user.id != currentUser.id
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Avatar(
              imageUrl: currentUser.avatarUrl,
              radius: 18.0,
            ),
            Text(
              currentUser.username,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
          const SizedBox(width: 8.0),

        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: (viewInsets.bottom > 0) ? 16.0 : 8.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final showImage = index + 1 == messages.length ||
                    messages[index + 1].senderUserId != message.senderUserId;

                    return Row(
                      mainAxisAlignment: message.senderUserId == userId1
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,

                      children: [
                        if (showImage && message.senderUserId != userId1)
                          Avatar(
                            imageUrl: otherUser.avatarUrl,
                            radius: 12.0,
                          ),

                        MessageBubble(
                          message: message
                        ),
                        if (showImage && message.senderUserId == userId1)
                          Avatar(
                            imageUrl: currentUser.avatarUrl,
                            radius: 12.0,
                          ),
                      ]
                    );
                  }
                )
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //TODO send a message
                    },
                    icon: const Icon(Icons.attach_file),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary.withAlpha(100),
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _sendMessage();
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ]
              )
            ]
          ),
        ),
      )
    );
  }
}


