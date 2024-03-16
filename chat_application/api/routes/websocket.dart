import 'dart:convert';

import 'package:api/src/repository/msg_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';


Future<Response> onRequest(RequestContext context) async {
  final messageRepository = context.read<MessageRepository>();
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
      if (message is! String) {
        channel.sink.add('Invalid message');
        return;
      }

      final messageJson = jsonDecode(message);
      print('Received messageJson: $messageJson');

      final event = messageJson['event'];
      final data = messageJson['data'];
      print('event: $event, data: $data');

      if (data != null && data is Map<String, dynamic>) {
        switch (event) {
          case 'message.create':
            messageRepository.createMsg(data).then((message) {
              channel.sink.add(
                jsonEncode({
                  'event': event,
                  'data': message,
                }),
              );
            }).catchError((err) {
              print('Something went wrong while creating message: $err');
            });
            break;
          default:
        }
      } else {
        print('Data is null or not of type Map<String, dynamic>: $data');
      }
    });
  });
  return handler(context);
}