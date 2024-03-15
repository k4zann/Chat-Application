import 'dart:async';
import 'dart:html';

import 'package:api/src/repository/msg_repository.dart';
import 'package:dart_frog/dart_frog.dart';

FutureOr<Response> onRequest(RequestContext context, String chatRoomId) async {
  switch(context.request.method) {
    case HttpMethod.get:
      return _get(context, chatRoomId);
    case HttpMethod.post:
      // return _post(context, chatRoomId);
    case HttpMethod.put:
      // return _put(context, chatRoomId);
    case HttpMethod.delete:
      // return _delete(context, chatRoomId);
    case HttpMethod.patch:
      // return _patch(context, chatRoomId);
    case HttpMethod.head:
      // return _head(context, chatRoomId);
    case HttpMethod.options:
      // return _options(context, chatRoomId);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String chatRoomId) async {

  final messageRepo = context.read<MessageRepository>();

  try {
    final messages = await messageRepo.fetchMessages(chatRoomId);
    return Response.json(
        body: {
          'messages' : messages
        }
    );
  } catch(err) {
    return Response(statusCode: HttpStatus.internalServerError, body: err.toString());
  }
  return Response(body: 'Chat room $chatRoomId');
}