import 'package:supabase/supabase.dart';

class MessageRepository {
  final SupabaseClient supabaseClient;

  const MessageRepository({
    required this.supabaseClient
  });
  createMsg() {

  }

  Future<List<Map<String, dynamic>>> fetchMessages(String chatRoomId) async {
    try {
      final messages = await supabaseClient
          .from('messages')
          .select()
          .eq('chat_room_id', chatRoomId);

      return messages;
    } catch(err) {
      throw Exception(err);
    }
  }
}