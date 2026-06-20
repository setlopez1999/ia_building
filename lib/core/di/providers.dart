import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/remote/chat_remote_datasource.dart';
import '../../data/datasources/remote/ping_remote_datasource.dart';
import '../../data/datasources/remote/game_server_datasource.dart';
import '../../data/datasources/remote/streaming_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/device_repository_impl.dart';
import '../../data/repositories/gaming_repository_impl.dart';
import '../../data/repositories/gaming_monitor_repository_impl.dart';
import '../../data/repositories/network_repository_impl.dart';
import '../../data/repositories/streaming_repository_impl.dart';
import '../../data/repositories/streaming_monitor_repository_impl.dart';
import '../../domain/repositories/i_chat_repository.dart';
import '../../domain/repositories/i_device_repository.dart';
import '../../domain/repositories/i_gaming_repository.dart';
import '../../domain/repositories/i_gaming_monitor_repository.dart';
import '../../domain/repositories/i_network_repository.dart';
import '../../domain/repositories/i_streaming_repository.dart';
import '../../domain/repositories/i_streaming_monitor_repository.dart';

part 'providers.g.dart';

@riverpod
PingRemoteDataSource pingDataSource(PingDataSourceRef ref) =>
    PingRemoteDataSource();

@riverpod
ChatRemoteDataSource chatDataSource(ChatDataSourceRef ref) =>
    ChatRemoteDataSource();

@riverpod
GameServerDataSource gameServerDataSource(GameServerDataSourceRef ref) =>
    GameServerDataSource();

@riverpod
StreamingDataSource streamingDataSource(StreamingDataSourceRef ref) =>
    StreamingDataSource();

@riverpod
INetworkRepository networkRepository(NetworkRepositoryRef ref) =>
    NetworkRepositoryImpl(ref.watch(pingDataSourceProvider));

@riverpod
IChatRepository chatRepository(ChatRepositoryRef ref) =>
    ChatRepositoryImpl(ref.watch(chatDataSourceProvider));

@riverpod
IDeviceRepository deviceRepository(DeviceRepositoryRef ref) =>
    DeviceRepositoryImpl();

@riverpod
IGamingRepository gamingRepository(GamingRepositoryRef ref) =>
    GamingRepositoryImpl();

@riverpod
IStreamingRepository streamingRepository(StreamingRepositoryRef ref) =>
    StreamingRepositoryImpl();

@riverpod
IGamingMonitorRepository gamingMonitorRepository(
        GamingMonitorRepositoryRef ref) =>
    GamingMonitorRepositoryImpl(
      pingDataSource: ref.watch(pingDataSourceProvider),
      gameServerDataSource: ref.watch(gameServerDataSourceProvider),
    );

@riverpod
IStreamingMonitorRepository streamingMonitorRepository(
        StreamingMonitorRepositoryRef ref) =>
    StreamingMonitorRepositoryImpl(
      pingDataSource: ref.watch(pingDataSourceProvider),
      streamingDataSource: ref.watch(streamingDataSourceProvider),
    );
