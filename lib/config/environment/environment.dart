import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tvapp/ui/shared/utils/env.dart';
import 'package:tvapp/ui/shared/utils/hex_color.dart';

class Environment {
  Environment._();

  /// App config
  static String appName = dotenv.env['APP_NAME']!;
  static bool appDebugMode = dotenv.env['APP_DEBUG_MODE']! == 'true';
  static String appSign = dotenv.env['APP_SIGN']!;
  static String appIcon = dotenv.env['APP_ICON']!;

  static String appSplashIcon = dotenv.env['APP_SPLASH_ICON']!;
  static String appSplashBg = dotenv.env['APP_SPLASH_BG']!;
  static double h1FSize = double.tryParse(dotenv.env['H1_SIZE'].toString()) ?? 18;
  static double h2FSize = double.tryParse(dotenv.env['H2_SIZE'].toString()) ?? 14;
  static double labelFSize = double.tryParse(dotenv.env['LABEL_FONT_SIZE'].toString()) ?? 12;

  // static String appSplashIcon = dotenv.env['APP_SPLASH_ICON']!;
  static String appPrincipalLang = dotenv.env['APP_PRINCIPAL_LANG']!.isEmpty
      ? 'es'
      : dotenv.env['APP_PRINCIPAL_LANG']!;

  /// Host config
  static String baseHost = dotenv.env['BASE_HOST']!;
  static String ipFindHost = dotenv.env['IP_FIND_HOST']!;
  static String middlewareHost = dotenv.env['MIDDLEWARE_HOST']!;
  static String crmHost = dotenv.env['CRM_HOST'] ?? 'http://201.234.116.79:8083';

  /// Tools API (Check Health, Diagnostico, Gaming, etc.)
  static String toolsBaseUrl = dotenv.env['TOOLS_BASE_URL'] ?? 'http://201.234.116.79:9090';

  /// Webhook API (camaras)
  static String webhookHost = dotenv.env['WEBHOOK_HOST'] ?? 'http://201.234.116.79:8088';

  /// Gradient colors (wifi status card)
  static Color gradientColor1 = HexColor(dotenv.env['GRADIENT_COLOR_1'] ?? '00CC66');
  static Color gradientColor2 = HexColor(dotenv.env['GRADIENT_COLOR_2'] ?? '004E92');

  /// Theme config
  /// Fondo unico de la app. Toda pantalla debe usar este color.
  static Color backgroundColor =
      HexColor(dotenv.env['BACKGROUND_COLOR'] ?? '#14161C');

  /// Color de los botones de accion principal (flujo de registro).
  /// Modo demostración: las pantallas cuyo endpoint todavia no existe
  /// muestran datos de muestra. En false no queda ningun dato inventado.
  static bool demoMode = (dotenv.env['DEMO'] ?? 'false') == 'true';

  /// Fundido al cambiar de canal.
  static bool channelFadeEnabled = (dotenv.env['CHANNEL_FADE_ENABLED'] ?? 'true') == 'true';
  static int channelFadeMs =
      int.tryParse(dotenv.env['CHANNEL_FADE_MS'] ?? '') ?? 250;

  static Color actionColor = HexColor(dotenv.env['ACTION_COLOR'] ?? '#00CC66');

  static Color lightThemeColor = HexColor(dotenv.env['LIGHT_THEME_COLOR']!);
  static Color darkThemeColor = HexColor(dotenv.env['DARK_THEME_COLOR']!);
  /// Acento de la app. Antes cada tema tenia el suyo (`SECONDARY_*`), que en
  /// IPTV se veia violeta mientras el resto de la app era verde. Ahora los dos
  /// derivan de [actionColor]: un solo valor en el `.env` cambia todo.
  static Color get secondaryLightThemeColor => actionColor;
  static Color get secondaryDarkThemeColor => actionColor;
  static Color lightThemeColorText = HexColor(
    dotenv.env['LIGHT_THEME_TEXT_COLOR']!,
  );
  static Color darkThemeColorText = HexColor(
    dotenv.env['DARK_THEME_TEXT_COLOR']!,
  );
  static Color secondaryLightThemeTextColor = HexColor(
    dotenv.env['SECONDARY_LIGHT_THEME_TEXT_COLOR']!,
  );
  static Color secondaryDarkThemeTextColor = HexColor(
    dotenv.env['SECONDARY_DARK_THEME_TEXT_COLOR']!,
  );
  static String googleFonts = dotenv.env['GOOGLE_FONTS']!;




  // style config
  static Color inputFillColor = HexColor(env('INPUT_FILL_COLOR'));
  static Color inputHintColor = HexColor(env('INPUT_HINT_COLOR'));
  static Color inputTextColor = HexColor(env('INPUT_TEXT_COLOR'));

  // feature flags
  static bool registerEnabled = env('REGISTER_ENABLED') == 'true';
  static bool notificationsEnabled = env('NOTIFICATIONS_ENABLED') == 'true';
  static bool notificationCatchupEnabled = env('NOTIFICATION_CATCHUP_ENABLED') == 'true';
  static bool catchupEnabled = env('CATCHUP_ENABLED') == 'true';
  static bool easterEggMode = env('EASTER_EGG_MODE') == 'true';
  static bool eventsEnabled = env('EVENTS_ENABLED') == 'true';
  static bool packsEnabled = env('PACKS_ENABLED') == 'true';
  static bool multicdnEnabled = env('MULTICDN_ENABLED') == 'true';

  //ICONS SIZES
  static double iconWith = double.parse(dotenv.env['ICON_WIDTH']!);
  static double splashWidth = double.parse(dotenv.env['SPLASH_WIDTH']!);
  static double splashHeight = double.parse(dotenv.env['SPLASH_HEIGHT']!);

  //PARENTAL CONFIG
  static String parentalPlaceholder = dotenv.env['PARENTAL_PLACEHOLDER'] ?? 'Control Parental';
  static String parentalTitle = dotenv.env['PARENTAL_TITLE'] ?? 'Ingrese su PIN';
  static bool showParentalDescription = env('SHOW_PARENTAL_DESCRIPTION') == 'true';
}
