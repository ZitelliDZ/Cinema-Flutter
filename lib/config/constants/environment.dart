import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String movieDbKey =
      dotenv.env['APP_MOVIEDB_KEY'] ?? 'No existe api key.';
}
