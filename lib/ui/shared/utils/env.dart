import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Env widget
String env(final String key) {
  return dotenv.get(key);
}
