// Port of data/api/GeminiApiClient.kt + OrionAiService.kt
// Uses google_generative_ai. API key via --dart-define=GEMINI_API_KEY
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;

  GeminiService({this.apiKey = const String.fromEnvironment('GEMINI_API_KEY')}) {
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  }

  bool get isConfigured => apiKey.isNotEmpty;

  Future<String> askSite(String prompt, {String context = ''}) async {
    if (!isConfigured) return 'Missing GEMINI_API_KEY (--dart-define).';
    final content = [Content.text('$context\n$prompt')];
    final res = await _model.generateContent(content);
    return res.text ?? '';
  }
}
