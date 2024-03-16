import 'package:models/models.dart';

import '../services/chat_api_client.dart';

class MsgRepo {
  final ChatApi chatApi;

  MsgRepo({required this.chatApi});

  createMessage() {

  }

  Future<List<Message>> fetchMessages(String chatRoomId) async {
    final response = await chatApi.fetchMessages(chatRoomId);

    final messages = response['messages']
        .map((msg) => Message.fromJson(msg))
        .toList();

    return messages;
  }

}