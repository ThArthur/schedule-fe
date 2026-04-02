import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl => dotenv.get('API_URL', fallback: 'http://localhost:8090/api');

  static String? formatImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (kIsWeb) return url;

    // Se a URL do banco/backend vier como localhost, substituímos pelo host configurado no .env
    // Isso é essencial para que o emulador/dispositivo Android acesse o servidor na sua máquina.
    if (url.contains('localhost')) {
      final uri = Uri.parse(baseUrl);
      return url.replaceAll('localhost', uri.host);
    }
    return url;
  }
}
