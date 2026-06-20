import '../../domain/repositories/i_chat_repository.dart';
import '../datasources/remote/chat_remote_datasource.dart';

class ChatRepositoryImpl implements IChatRepository {
  final ChatRemoteDataSource dataSource;

  ChatRepositoryImpl(this.dataSource);

  @override
  Future<String> sendMessage(String message) {
    return dataSource.sendMessage(message);
  }
}
