// Ports: data/api/GeminiApiClient.kt (multimodal client with rich Arabic
// offline fallback) + OrionAiService wiring. API key via
// --dart-define=GEMINI_API_KEY. Deterministic fallbacks keep every
// surface usable without a key.
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

enum AiEngine {
  geminiFlash('GEMINI_3_8_FLASH', 'جيميني فلاش', 'Gemini Flash', 'Google', 'AI'),
  chatGpt4o('CHATGPT_4O', 'شات جي بي تي', 'ChatGPT 4o', 'OpenAI', 'AI'),
  claude35('CLAUDE_3_5', 'كلود', 'Claude 3.5', 'Anthropic', 'AI'),
  hybridMultiAi('HYBRID_MULTI_AI', 'هجين متعدد', 'Hybrid Multi-AI', 'OrionB', 'HYBRID');

  final String id;
  final String titleAr;
  final String titleEn;
  final String provider;
  final String badge;
  const AiEngine(this.id, this.titleAr, this.titleEn, this.provider, this.badge);
}

class GroundedSource {
  final String title;
  final String uri;
  const GroundedSource({required this.title, required this.uri});
}

class GroundedResponse {
  final String textAr;
  final String textEn;
  final List<GroundedSource> sources;
  final List<String> searchQueries;
  final String groundingType;
  const GroundedResponse({
    required this.textAr, required this.textEn,
    this.sources = const [], this.searchQueries = const [],
    this.groundingType = 'AI',
  });

  bool get isFromAi => groundingType == 'AI';
}

class AITranscript {
  final String textAr;
  final String textEn;
  final bool isError;
  const AITranscript({
    required this.textAr, required this.textEn, this.isError = false,
  });
}

class ImageResult {
  final String prompt;
  final String aspectRatio;
  final String base64Image;
  final String descriptionAr;
  final String descriptionEn;
  final String simulatedUrl;
  const ImageResult({
    required this.prompt, required this.aspectRatio,
    this.base64Image = '', required this.descriptionAr,
    required this.descriptionEn, this.simulatedUrl = '',
  });
}

class VideoResult {
  final String prompt;
  final String aspectRatio;
  final String operationId;
  final String status;
  final String titleAr;
  final String titleEn;
  final int durationSeconds;
  const VideoResult({
    required this.prompt, required this.aspectRatio,
    this.operationId = '', this.status = 'PENDING',
    required this.titleAr, required this.titleEn,
    this.durationSeconds = 0,
  });
}

class ToolCallResult {
  final String name;
  final Map<String, dynamic> args;
  final String noteAr;
  final String noteEn;
  const ToolCallResult({
    required this.name, required this.args,
    required this.noteAr, required this.noteEn,
  });
}

class GeminiService {
  final String apiKey;
  late final GenerativeModel _model;

  GeminiService({this.apiKey = const String.fromEnvironment('GEMINI_API_KEY')}) {
    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  }

  bool get isConfigured => apiKey.isNotEmpty;

  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  Future<String> askSite(String prompt, {String context = ''}) async {
    if (!isConfigured) return 'Missing GEMINI_API_KEY (--dart-define).';
    final content = [Content.text('$context\n$prompt')];
    final res = await _model.generateContent(content);
    return res.text ?? '';
  }

  /// Grounded generation with optional Google-Search grounding via REST.
  Future<GroundedResponse> generateWithGrounding(
    String prompt, {
    bool useSearch = false,
  }) async {
    if (!isConfigured) {
      return const GroundedResponse(
        textAr: 'المساعد الذكي — اربط GEMINI_API_KEY عبر --dart-define',
        textEn: 'AI Copilot — pass GEMINI_API_KEY via --dart-define',
        groundingType: 'OFFLINE',
      );
    }
    try {
      final body = {
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        if (useSearch)
          'tools': [
            {
              'google_search': <String, dynamic>{}
            }
          ],
      };
      final httpRes = await http.post(
        Uri.parse('$_baseUrl/gemini-2.0-flash:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (httpRes.statusCode != 200) {
        return GroundedResponse(
          textAr: 'تعذر الاتصال بالنموذج (${httpRes.statusCode})',
          textEn: 'Model call failed (${httpRes.statusCode})',
          groundingType: 'ERROR',
        );
      }
      final data = json.decode(httpRes.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List? ?? [];
      var text = '';
      final sources = <GroundedSource>[];
      final queries = <String>[];
      if (candidates.isNotEmpty) {
        final content =
            candidates.first['content'] as Map<String, dynamic>?;
        final parts = content?['parts'] as List? ?? [];
        text = parts
            .map((p) => '${(p as Map)['text'] ?? ''}')
            .join('\n');
        final meta = candidates.first['groundingMetadata']
            as Map<String, dynamic>?;
        final chunks =
            meta?['groundingChunks'] as List? ?? [];
        for (final c in chunks) {
          final web = (c as Map)['web'] as Map? ?? {};
          sources.add(GroundedSource(
            title: '${web['title'] ?? ''}',
            uri: '${web['uri'] ?? ''}',
          ));
        }
        final q = meta?['webSearchQueries'] as List? ?? [];
        queries.addAll(q.map((e) => '$e'));
      }
      return GroundedResponse(
          textAr: text, textEn: text,
          sources: sources, searchQueries: queries);
    } catch (e) {
      return GroundedResponse(
        textAr: 'خطأ الاتصال: $e', textEn: 'Connection error: $e',
        groundingType: 'ERROR',
      );
    }
  }

  /// Construction site chat with HSE knowledge + rich offline fallback
  /// (midday ban, WBGT flags, scafftag, excavation, permits).
  Future<GroundedResponse> queryConstructionChat(
    String query, {
    String projectContext = '',
    String hseContext = '',
    String topicFilter = 'ALL',
  }) async {
    const system = 'You are a UAE construction site manager assistant '
        '(Arabic/English) covering HSE regulations, permits (DM/RTA/DEWA/DCD), '
        'progress and FIDIC topics.';
    if (!isConfigured) {
      return GroundedResponse(
        textAr: _offlineHseAr(query, projectContext, hseContext),
        textEn: _offlineHseEn(query, projectContext, hseContext),
        groundingType: 'OFFLINE',
      );
    }
    return generateWithGrounding(
      '$system\nProject: $projectContext\nHSE: $hseContext\n'
      'Topic: $topicFilter\nQuestion: $query',
      useSearch: true,
    );
  }

  String _offlineHseAr(String q, String project, String hse) =>
      'رد تلقائي (بدون مفتاح): "$q"\n'
      '• حظر الظهيرة MoHRE ساري 12:30–3:00 — غرامة 5000 درهم للمخالفة و50000 عند التكرار.\n'
      '• رايات الإجهاد الحراري WBGT: أخضر <27.5 / أصفر 27.5–29 / أحمر 29–31.5 / أسود ≥31.5.\n'
      '• السقالات: بطاقة خضراء سليمة / صفراء بحذر / حمراء ممنوعة + درابزين 950–1150مم ولوح وسطي 470مم وحاجز قدم 150مم.\n'
      '• الحفر أعمق من 1.2م يستلزم سند الجوانب + درابزين 1.5م + سلالم كل 7.5م.\n'
      '• تقدم المشروع $project: الإنجاز 68% — تابع لوحة القيادة للتفاصيل.\n'
      '• التصاريح: بلدية دبي / RTA / DEWA / الدفاع المدني $hse.';

  String _offlineHseEn(String q, String project, String hse) =>
      'Offline auto-reply (no key): "$q"\n'
      '• MoHRE midday ban 12:30–3:00 — AED 5k fine, AED 50k repeat.\n'
      '• WBGT flags: green <27.5 / yellow 27.5–29 / red 29–31.5 / black ≥31.5.\n'
      '• Scafftag green/yellow/red + guardrails 950–1150mm, mid 470mm, toe 150mm.\n'
      '• Excavations deeper than 1.2m need shoring + 1.5m rails + ladders every 7.5m.\n'
      '• Project $project progress 68% — see dashboard.\n'
      '• Permits: DM / RTA / DEWA / Civil Defense $hse.';

  Future<AITranscript> transcribeAudio(
    List<int> audioBytes, {
    String mimeType = 'audio/mp3',
  }) async {
    if (!isConfigured) {
      return const AITranscript(
        textAr: 'التفريغ الصوتي يتطلب GEMINI_API_KEY',
        textEn: 'Transcription requires GEMINI_API_KEY',
        isError: true,
      );
    }
    try {
      final body = {
        'contents': [
          {
            'parts': [
              {'text': 'Transcribe this site audio briefly.'},
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Encode(audioBytes),
                }
              }
            ]
          }
        ],
      };
      final httpRes = await http.post(
        Uri.parse('$_baseUrl/gemini-2.0-flash:generateContent?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (httpRes.statusCode != 200) {
        return AITranscript(
            textAr: 'فشل التفريغ (${httpRes.statusCode})',
            textEn: 'Transcription failed (${httpRes.statusCode})',
            isError: true);
      }
      final data = json.decode(httpRes.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List? ?? [];
      var text = '';
      if (candidates.isNotEmpty) {
        final parts = (candidates.first['content'] as Map?)?['parts'] as List? ?? [];
        text = parts.map((p) => '${(p as Map)['text'] ?? ''}').join('\n');
      }
      return AITranscript(textAr: text, textEn: text);
    } catch (e) {
      return AITranscript(
          textAr: 'خطأ التفريغ: $e', textEn: 'Transcription error: $e',
          isError: true);
    }
  }

  Future<ImageResult> generateOrEditImage(
    String prompt, {
    String? referenceImageBase64,
    String aspectRatio = '1:1',
  }) async {
    // TODO: image REST (responseModalities IMAGE+TEXT, imageConfig) once
    // an image-capable model is enabled for the key.
    return ImageResult(
      prompt: prompt, aspectRatio: aspectRatio,
      descriptionAr: 'توليد الصور يتطلب مفتاحاً بمزايا الصور',
      descriptionEn: 'Image generation needs an image-enabled key',
    );
  }

  Future<VideoResult> generateVeoVideo(
    String prompt, {
    String aspectRatio = '16:9',
  }) async {
    // TODO: Veo REST (generateVideos + operation polling, 1080p).
    return VideoResult(
      prompt: prompt, aspectRatio: aspectRatio,
      titleAr: 'توليد الفيديو غير مفعل بعد',
      titleEn: 'Video generation not wired yet',
    );
  }

  /// OrionB tool calls: submit_fde_daily_report + create_ncr_ticket.
  Future<ToolCallResult> executeOrionBToolCall(String prompt) async {
    final lower = prompt.toLowerCase();
    if (lower.contains('ncr') || lower.contains('ticket')) {
      return ToolCallResult(
        name: 'create_ncr_ticket',
        args: {'prompt': prompt, 'status': 'DRAFT'},
        noteAr: 'تم تجهيز تذكرة NCR كمسودة — بانتظار الاعتماد',
        noteEn: 'NCR ticket drafted — pending approval',
      );
    }
    return ToolCallResult(
      name: 'submit_fde_daily_report',
      args: {'prompt': prompt, 'status': 'DRAFT'},
      noteAr: 'تم تجهيز التقرير اليومي كمسودة — بانتظار التوقيع',
      noteEn: 'Daily report drafted — pending signature',
    );
  }
}
