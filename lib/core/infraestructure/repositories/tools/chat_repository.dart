import 'package:tvapp/core/infraestructure/datasource/tools/tools_api_client.dart';

class ChatRepository {
  final ToolsApiClient _api;

  ChatRepository({required ToolsApiClient apiClient}) : _api = apiClient;

  Future<Map<String, dynamic>> sendMessage(
    String text, {
    String? sessionId,
  }) async {
    final body = <String, dynamic>{'message': text};
    if (sessionId != null) {
      body['session_id'] = sessionId;
    }
    final data = await _api.post('/v1/chat/message', body: body);
    return data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getHistory(String sessionId) async {
    final data = await _api.get('/v1/chat/history?session_id=$sessionId');
    return data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> newSession() async {
    final data = await _api.post('/v1/chat/new', body: {});
    return data as Map<String, dynamic>;
  }
}
