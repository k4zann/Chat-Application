import 'dart:io';

import 'package:api/src/env/env.dart';
import 'package:api/src/repository/msg_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';

late MessageRepository messageRepository;


Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final supabaseClient = SupabaseClient(
    Env.SUPABASE_URL,
    Env.SUPABASE_SERVICE_ROLE_KEY
  );

  messageRepository = MessageRepository(
    supabaseClient: supabaseClient
  );

  return serve(handler, ip, port);
}