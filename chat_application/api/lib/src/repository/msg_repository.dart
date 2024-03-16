import 'package:supabase/supabase.dart';

class MessageRepository {
  final SupabaseClient supabaseClient;

  const MessageRepository({
    required this.supabaseClient
  });

  Future<Map<String, dynamic>> createMsg(Map<String, dynamic> data) async {
    try {
      return await supabaseClient.from('messages').insert(data).select().single();
    } catch (err) {
      throw Exception(err);
    }
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