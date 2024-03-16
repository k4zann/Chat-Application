import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((event) {
      print('Received: $event');
      channel.sink.add('Echo: $event');
    });
  });


  return handler(context);
}
