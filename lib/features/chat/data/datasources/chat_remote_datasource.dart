import 'dart:convert';
import 'package:dio/dio.dart';
import '../api/chat_api.dart';
import '../models/chat_message_model.dart';

class ChatRemoteDataSource {
  final ChatApi api;
  final Dio dio;

  ChatRemoteDataSource(this.api, this.dio);

  Future<List<ChatMessageModel>> getChatHistory() async {
    final response = await api.getChatHistory();
    final List<dynamic> data = response['data'] ?? [];
    return data.map((json) => ChatMessageModel.fromJson(json)).toList();
  }

  Future<void> clearChatHistory() async {
    await api.clearChatHistory();
  }

  Stream<String> sendMessage({
    required String message,
    required String token,
    List<ChatMessageModel> history = const [],
  }) async* {
    final response = await dio.post<ResponseBody>(
      'ai/chat',
      data: {
        'message': message,
        'history': history.map((m) => m.toJson()).toList(),
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'text/event-stream',
          'Cache-Control': 'no-cache',
        },
        responseType: ResponseType.stream,
        receiveTimeout: Duration.zero,
      ),
    );

    final stream = response.data?.stream;
    if (stream == null) return;

    String buffer = '';
    await for (final chunk in stream) {
      final decodedChunk = utf8.decode(chunk);
      buffer += decodedChunk;

      final lines = buffer.split('\n');
      buffer = lines.removeLast();

      for (final line in lines) {
        final trimmedLine = line.trim();
        if (trimmedLine.isEmpty || !trimmedLine.startsWith('data: ')) continue;

        try {
          final dataString = trimmedLine.substring(6);
          final data = json.decode(dataString);

          if (data['error'] != null) {
            throw Exception(data['error']);
          }

          final text = data['text'] as String? ?? '';
          if (text.isNotEmpty) {
            yield text;
          }
        } catch (e) {
          continue;
        }
      }
    }
  }
}
