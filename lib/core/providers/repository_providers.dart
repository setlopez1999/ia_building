import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tvapp/core/infraestructure/repositories/auth_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/category_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/channels_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/guide_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/location_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/multicdn_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/notification_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/remember_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/settings_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/slide_http_repository.dart';
import 'package:tvapp/core/infraestructure/repositories/top_channels_http_repository.dart';

final authRepositoryProvider =
    Provider<AuthHttpRepository>((ref) => AuthHttpRepository());

final categoryRepositoryProvider =
    Provider<CategoryHttpRepository>((ref) => CategoryHttpRepository());

final channelsRepositoryProvider =
    Provider<ChannelsHttpRepository>((ref) => ChannelsHttpRepository());

final guideRepositoryProvider =
    Provider<GuideHttpRepository>((ref) => GuideHttpRepository());

final notificationRepositoryProvider =
    Provider<NotificationHttpRepository>((ref) => NotificationHttpRepository());

final multicdnRepositoryProvider =
    Provider<MultiCDNHttpRepository>((ref) => MultiCDNHttpRepository());

final topChannelsRepositoryProvider =
    Provider<TopChannelsHttpRepository>((ref) => TopChannelsHttpRepository());

final locationRepositoryProvider =
    Provider<LocationHttpRepository>((ref) => LocationHttpRepository());

final settingsRepositoryProvider =
    Provider<SettingsHttpRepository>((ref) => SettingsHttpRepository());

final rememberRepositoryProvider =
    Provider<RememberRepository>((ref) => RememberRepository());

final slideRepositoryProvider =
    Provider<SlideHttpRepository>((ref) => SlideHttpRepository());
