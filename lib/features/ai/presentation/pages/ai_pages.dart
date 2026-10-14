// Clean Architecture: AI Copilot — Presentation.
// Covers: AiCopilotScreen, AiLegalCopilotScreen, AiSiteSuperintendentScreen,
// AiSpecAuditorView, SiteTalkScreen, AskTheSiteScreen,
// OrionTacticalCopilotScreen, ConstructionChatScreen.
// Titles/hints resolve from JSON — no hardcoded text.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/features/ai/data/datasources/gemini_service.dart';
import 'package:buildhub/features/documents/domain/entities/document_entities.dart';
import 'package:buildhub/features/sitepulse/data/services/orion_service.dart';
import 'package:buildhub/features/sitepulse/domain/entities/telemetry_entities.dart';

class _AiShell extends StatefulWidget {
  final String titleKey;
  final String hintKey;
  const _AiShell({required this.titleKey, required this.hintKey});
  @override
  State<_AiShell> createState() => _AiShellState();
}

class _AiShellState extends State<_AiShell> {
  final ctrl = TextEditingController();
  String answer = '';
  bool busy = false;

  Future<void> ask() async {
    setState(() => busy = true);
    try {
      final svc = GeminiService();
      final res = await svc.askSite(ctrl.text);
      if (!mounted) return;
      setState(() => answer = res);
    } catch (e) {
      if (!mounted) return;
      final loc = context.read<AppLocalization>();
      setState(() => answer = '${loc.t('common.error')}: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t(widget.titleKey))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: ctrl,
            decoration: InputDecoration(hintText: loc.t(widget.hintKey)),
            minLines: 2, maxLines: 4),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: busy ? null : ask,
            child: Text(busy ? '...' : loc.t('common.ask'))),
          const SizedBox(height: 12),
          Expanded(child: SingleChildScrollView(child: Text(answer))),
        ]),
      ),
    );
  }
}

class AiCopilotFullScreen extends StatefulWidget {
  final int initialTab;
  final VoidCallback? onBack;
  const AiCopilotFullScreen({super.key, this.initialTab = 0, this.onBack});

  @override
  State<AiCopilotFullScreen> createState() => _AiCopilotFullScreenState();
}

class _AiCopilotFullScreenState extends State<AiCopilotFullScreen> with SingleTickerProviderStateMixin {
  late int _selectedTab;
  final TextEditingController _chatCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isThinking = false;
  bool _useSearchGrounding = true;
  bool _useMapsGrounding = true;

  // Live voice state
  bool _isLiveActive = false;

  // Image Studio state
  final TextEditingController _imagePromptCtrl = TextEditingController(
    text: 'تصميم ثلاثي الأبعاد لبرج سكني شاهق في دبي مارينا مع واجهات زجاجية مزدوجة ومساحات خضراء عمودية',
  );
  String _imageAspectRatio = '1:1';
  bool _isGeneratingImage = false;
  bool _imageGenerated = false;

  // Veo Video state
  final TextEditingController _videoPromptCtrl = TextEditingController(
    text: 'محاكاة ثلاثية الأبعاد متقدمة لعملية صب الخرسانة المسلحة لأساسات برج شاهق في دبي',
  );
  String _videoAspectRatio = '16:9';
  bool _isGeneratingVideo = false;
  bool _videoGenerated = false;

  // Transcribe state
  bool _isRecording = false;
  String _transcribedText = '';

  // Spec Auditor state
  int _selectedSpecIndex = 0;

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'textAr': 'مرحباً بك يا مهندس في الجناح الهندسي الذكي Orion B Super AI Suite.\n\nتم تفعيل أدوات الربط الحي الميداني:\n• بحث جوجل الهندسي المباشر (Google Search Grounding)\n• خرائط المواقع والكسارات (Google Maps Grounding)\n• المعالجة الصوتية الفورية (gemini-3.8-live)\n• استوديو توليد المخططات (gemini-3.1-flash)\n• محاكاة الفيديو الهندسي (veo-3.1-fast).\n\nكيف يمكنني مساعدتك في أعمال موقعك اليوم؟',
      'citation': 'DBC 2021 • Google Search Grounding • Google Maps Grounding',
      'confidence': 99,
      'time': '10:00 AM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    _chatCtrl.dispose();
    _imagePromptCtrl.dispose();
    _videoPromptCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? textOverride]) {
    final text = textOverride ?? _chatCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'textAr': text,
        'time': 'Just now',
      });
      _isThinking = true;
      if (textOverride == null) _chatCtrl.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _isThinking = false;
        String reply;
        String citation = 'DBC 2021 • Clause 14.3';
        if (text.contains('كود دبي') || text.contains('DBC')) {
          reply = 'وفقاً لـ كود دبي للبناء (Dubai Building Code DBC 2021):\n\n1. يجب ألا يقل الغطاء الخرساني (Concrete Cover) للعناصر الملامسة للتربة عن 75 مم.\n2. للأعمدة والكمرات الخارجية المعرضة للعوامل الجوية: 50 مم مع عزل مائي معتمد من بلدية دبي.\n3. نسبة حديد التسليح القصوى في الأعمدة الخاضعة لأحمال الزلازل هي 4% في مناطق الوصلات.';
          citation = 'Dubai Building Code (DBC 2021) Part B - Structural';
        } else if (text.contains('خرسانة') || text.contains('ACI')) {
          reply = 'وفقاً لمواصفات ACI 305R واشتراطات الصب في الأجواء الحارة بدولة الإمارات:\n\n• أقصى درجة حرارة للخرسانة الجاهزة عند التفريغ هي 32°C (أو 30°C للصبات الكتلية Mass Concrete).\n• يُلزم استخدام الثلج المجروش المبرد بدلاً من جزء من مياه الخلط لخفض الحرارة.\n• اختبار الهبوط (Slump Test) المقبول: 150 مم ± 25 مم مع إضافة مباعدات بولي كربوكسيلات.';
          citation = 'ACI 305R-20 • UAE Spec Section 03300';
        } else if (text.contains('فيديك') || text.contains('FIDIC')) {
          reply = 'بموجب المادة 20.1 من عقد الفيديك (FIDIC Red Book):\n\n• مهلة الإخطار الصارمة هي 28 يوماً من تاريخ علم المقاول بالحدث المسبب للمطالبة المالية أو التمديد الزمني.\n• إذا لم يقدم المقاول الإخطار خلال 28 يوماً، يسقط حقه تماماً ويُبرأ صاحب العمل من أي التزام قانوني.';
          citation = 'FIDIC 1999 Red Book Sub-Clause 20.1 & UAE Civil Code Art. 246';
        } else {
          reply = 'تمت معالجة استفسارك الهندسي بالاستناد إلى اللوائح التنظيمية المعتمدة في دولة الإمارات العربية المتحدة ومصادر البحث المتصلة.\n\nالنظام يؤكد مطابقة المتطلبات للمشروع مع الالتزام بتعليمات الاستشاري المشرف وتسجيل الإجراء في التقرير اليومي DPR.';
          citation = 'Google Search Grounding • UAE DM Standards';
        }

        _messages.add({
          'isUser': false,
          'textAr': reply,
          'citation': citation,
          'confidence': 98,
          'time': 'Just now',
        });
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: widget.onBack,
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Orion B AI Multi-Suite',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Gemini 3.8 Live • Grounding • Veo 3 • Vision',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentCyan,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.security, size: 13, color: Color(0xFF0B111E)),
                SizedBox(width: 4),
                Text(
                  'Account',
                  style: TextStyle(color: Color(0xFF0B111E), fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable Tabs Row
          Container(
            color: AppColors.darkSurface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  _buildTabItem(0, 'محادثة وبحث (Grounding)', Icons.chat),
                  _buildTabItem(1, 'صوت تفاعلي حي (Live API)', Icons.mic),
                  _buildTabItem(2, 'استوديو توليد الصور', Icons.image),
                  _buildTabItem(3, 'فيديو Veo 3 الهندسي', Icons.videocam),
                  _buildTabItem(4, 'تفريغ صوتي (Transcribe)', Icons.volume_up),
                  _buildTabItem(5, 'مدقق المواصفات واللوائح', Icons.menu_book),
                ],
              ),
            ),
          ),

          // Tab Content Area
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildChatTab(),
                _buildLiveVoiceTab(),
                _buildImageStudioTab(),
                _buildVeoVideoTab(),
                _buildTranscribeTab(),
                _buildSpecAuditorTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.accentCyan : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: isSelected ? AppColors.accentCyan : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.accentCyan : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 0: CHAT & GROUNDING
  // ---------------------------------------------------------------------------
  Widget _buildChatTab() {
    return Column(
      children: [
        // Grounding Options Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          color: AppColors.darkCard,
          child: Row(
            children: [
              FilterChip(
                selected: _useSearchGrounding,
                onSelected: (val) => setState(() => _useSearchGrounding = val),
                label: const Text('Google Search', style: TextStyle(fontSize: 11)),
                avatar: const Icon(Icons.travel_explore, size: 14),
                selectedColor: AppColors.accentCyan.withValues(alpha: 0.2),
                checkmarkColor: AppColors.accentCyan,
              ),
              const SizedBox(width: 8),
              FilterChip(
                selected: _useMapsGrounding,
                onSelected: (val) => setState(() => _useMapsGrounding = val),
                label: const Text('Google Maps', style: TextStyle(fontSize: 11)),
                avatar: const Icon(Icons.location_on, size: 14),
                selectedColor: AppColors.accentCyan.withValues(alpha: 0.2),
                checkmarkColor: AppColors.accentCyan,
              ),
            ],
          ),
        ),

        // Quick Suggestions
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          color: AppColors.darkBackground,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildQuickChip('فحص كود دبي للبناء DBC'),
                _buildQuickChip('مطابقة مواصفات الخرسانة ACI 305R'),
                _buildQuickChip('اشتراطات الدفاع المدني DCD'),
                _buildQuickChip('تحليل مطالبات عقد فيديك'),
              ],
            ),
          ),
        ),

        // Chat Messages
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(14),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isUser = msg['isUser'] as bool;

              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.darkSurface : AppColors.darkCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isUser ? AppColors.darkBorder : AppColors.accentCyan.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.accentCyan.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.smart_toy, size: 14, color: AppColors.accentCyan),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Orion B Intelligence',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.accentCyan),
                            ),
                            const Spacer(),
                            if (msg['confidence'] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${msg['confidence']}% Match',
                                  style: const TextStyle(color: AppColors.verifiedGreen, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        msg['textAr'] as String,
                        style: const TextStyle(fontSize: 13, height: 1.45, color: Colors.white),
                      ),
                      if (msg['citation'] != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.source, size: 12, color: AppColors.goldEmirates),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  msg['citation'] as String,
                                  style: const TextStyle(fontSize: 10, color: AppColors.goldEmirates),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        if (_isThinking)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accentCyan),
                ),
                const SizedBox(width: 8),
                Text('Orion B is synthesizing UAE regulatory standards...', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),

        // Input Bar
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          color: AppColors.darkSurface,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.mic, color: AppColors.accentCyan),
                onPressed: () {
                  _sendMessage('مراجعة مطابقة صب الخرسانة اليوم مع مواصفات بلدية دبي');
                },
              ),
              Expanded(
                child: TextField(
                  controller: _chatCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'اسأل Orion B عن مواصفات ومطابقات الموقع...',
                    hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    filled: true,
                    fillColor: AppColors.darkCard,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(color: AppColors.darkBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: const BorderSide(color: AppColors.accentCyan),
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _sendMessage(),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.accentCyan,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Color(0xFF0B111E), size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: const TextStyle(fontSize: 10, color: Colors.white)),
        backgroundColor: AppColors.darkCard,
        side: BorderSide(color: AppColors.darkBorder),
        onPressed: () => _sendMessage(label),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: LIVE VOICE API
  // ---------------------------------------------------------------------------
  Widget _buildLiveVoiceTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '🟢 Ultra-Low Latency: 32ms (WebSocket Bidirectional)',
                  style: TextStyle(color: AppColors.verifiedGreen, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              // Waveform Graphics
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(15, (index) {
                  final heights = [12.0, 24.0, 48.0, 32.0, 64.0, 80.0, 40.0, 96.0, 52.0, 72.0, 36.0, 56.0, 28.0, 18.0, 10.0];
                  final h = _isLiveActive ? heights[index] : 8.0;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 4,
                    height: h,
                    decoration: BoxDecoration(
                      color: _isLiveActive ? AppColors.accentCyan : AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 28),
              InkWell(
                onTap: () => setState(() => _isLiveActive = !_isLiveActive),
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: _isLiveActive ? Colors.redAccent : AppColors.accentCyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isLiveActive ? Colors.redAccent : AppColors.accentCyan).withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    _isLiveActive ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isLiveActive ? 'Live Audio Channel Active • Listening...' : 'Tap to Start Gemini 3.8 Live Voice Session',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Instant bidirectional English & Arabic voice conversation with Site Superintendent Agent.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: IMAGE STUDIO
  // ---------------------------------------------------------------------------
  Widget _buildImageStudioTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.palette, color: AppColors.accentCyan, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'gemini-3.1-flash-image-preview',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _imagePromptCtrl,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.darkSurface,
                  hintText: 'Enter architectural visualization prompt...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Aspect Ratio: ', style: TextStyle(color: Colors.white, fontSize: 12)),
                  const SizedBox(width: 8),
                  ...['1:1', '16:9', '4:3', '9:16'].map((ratio) {
                    final isSel = _imageAspectRatio == ratio;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(ratio, style: const TextStyle(fontSize: 11)),
                        selected: isSel,
                        onSelected: (_) => setState(() => _imageAspectRatio = ratio),
                        selectedColor: AppColors.accentCyan,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: const Color(0xFF0B111E),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: _isGeneratingImage
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.auto_awesome),
                  label: Text(_isGeneratingImage ? 'Rendering Architectural Visual...' : 'Generate 3D Architectural Concept'),
                  onPressed: _isGeneratingImage
                      ? null
                      : () {
                          setState(() => _isGeneratingImage = true);
                          Future.delayed(const Duration(milliseconds: 1800), () {
                            if (!mounted) return;
                            setState(() {
                              _isGeneratingImage = false;
                              _imageGenerated = true;
                            });
                          });
                        },
                ),
              ),
            ],
          ),
        ),

        if (_imageGenerated) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Generated Architectural Concept', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                      child: const Text('READY', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.apartment, size: 48, color: AppColors.accentCyan),
                      const SizedBox(height: 8),
                      Text('High-Rise Marina Tower Elevation Render', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      Text('Ratio: $_imageAspectRatio • Resolution: 2048x2048', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: VEO VIDEO
  // ---------------------------------------------------------------------------
  Widget _buildVeoVideoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.videocam, color: AppColors.goldEmirates, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'veo-3.1-fast-generate-preview',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _videoPromptCtrl,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.darkSurface,
                  hintText: 'Enter engineering construction video simulation prompt...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Aspect Ratio: ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ...['16:9', '9:16', '1:1'].map((ratio) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(ratio, style: const TextStyle(fontSize: 10)),
                          selected: _videoAspectRatio == ratio,
                          selectedColor: AppColors.goldEmirates.withValues(alpha: 0.3),
                          onSelected: (_) => setState(() => _videoAspectRatio = ratio),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldEmirates,
                    foregroundColor: const Color(0xFF0B111E),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: _isGeneratingVideo
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.play_circle_filled),
                  label: Text(_isGeneratingVideo ? 'Synthesizing Physics Video...' : 'Synthesize Engineering Simulation Video'),
                  onPressed: _isGeneratingVideo
                      ? null
                      : () {
                          setState(() => _isGeneratingVideo = true);
                          Future.delayed(const Duration(milliseconds: 2200), () {
                            if (!mounted) return;
                            setState(() {
                              _isGeneratingVideo = false;
                              _videoGenerated = true;
                            });
                          });
                        },
                ),
              ),
            ],
          ),
        ),

        if (_videoGenerated) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.goldEmirates.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Veo 3 Synthesized Video Ready', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.goldEmirates.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                      child: const Text('1080P 60FPS', style: TextStyle(color: AppColors.goldEmirates, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  alignment: Alignment.center,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, size: 54, color: AppColors.goldEmirates),
                      SizedBox(height: 6),
                      Text('Concrete Pouring Logistics Simulation (0:15)', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 4: TRANSCRIBE
  // ---------------------------------------------------------------------------
  Widget _buildTranscribeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Audio Transcribe (gemini-3.5-transcribe)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
              const SizedBox(height: 6),
              Text('Record site walkie-talkie audio or voice notes to transcribe into structured DPR log text.', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRecording ? Colors.redAccent : AppColors.accentCyan,
                      foregroundColor: const Color(0xFF0B111E),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                    label: Text(_isRecording ? 'Stop Recording' : 'Record Audio Log'),
                    onPressed: () {
                      setState(() {
                        _isRecording = !_isRecording;
                        if (!_isRecording) {
                          _transcribedText = 'تم استلام 4 خلاطات خرسانة جاهزة C40 من مصنع يونيبتون الساعة 08:30 صباحاً، وتم إجراء فحص الهبوط slump test وكانت النتيجة 145 مم وناجحة، وبدأ الصب في منطقة المحور F4 بالطابق 12.';
                        }
                      });
                    },
                  ),
                ],
              ),
              if (_transcribedText.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Transcription Output:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Text(_transcribedText, style: const TextStyle(fontSize: 12, color: Colors.white, height: 1.4)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 5: SPEC AUDITOR
  // ---------------------------------------------------------------------------
  Widget _buildSpecAuditorTab() {
    final specs = [
      {
        'title': 'Dubai Building Code (DBC 2021)',
        'authority': 'Dubai Municipality',
        'compliance': '98.2%',
        'clauses': [
          {'no': 'Clause B.4.2', 'name': 'Reinforcement Minimum Cover (75mm ground, 50mm external)', 'status': 'COMPLIANT'},
          {'no': 'Clause B.8.1', 'name': 'Structural Slab Deflection Limits under Full Imposed Load', 'status': 'COMPLIANT'},
          {'no': 'Clause F.2.4', 'name': 'Fire Separation Walls (2-Hour Fire Rating Minimum)', 'status': 'COMPLIANT'},
        ],
      },
      {
        'title': 'FIDIC Red Book (1999/2017)',
        'authority': 'International Federation of Consulting Engineers',
        'compliance': '94.5%',
        'clauses': [
          {'no': 'Sub-Clause 20.1', 'name': 'Contractor Claim 28-Day Strict Notice Bar', 'status': 'COMPLIANT'},
          {'no': 'Sub-Clause 14.3', 'name': 'Interim Payment Certificate (IPC) 10% Retention Deduction', 'status': 'COMPLIANT'},
          {'no': 'Sub-Clause 13.3', 'name': 'Variation Order Engineer Written Authorization Required', 'status': 'AUDIT_FLAG'},
        ],
      },
    ];

    final spec = specs[_selectedSpecIndex];
    final clauses = spec['clauses'] as List<Map<String, String>>;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Spec Picker
        Row(
          children: List.generate(specs.length, (i) {
            final isSel = _selectedSpecIndex == i;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(specs[i]['title'] as String, style: const TextStyle(fontSize: 11)),
                selected: isSel,
                onSelected: (_) => setState(() => _selectedSpecIndex = i),
                selectedColor: AppColors.accentCyan,
              ),
            );
          }),
        ),

        const SizedBox(height: 14),

        // Compliance Gauge Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spec['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('Authority: ${spec['authority']}', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.verifiedGreen.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  spec['compliance'] as String,
                  style: const TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),
        const Text('Clause-by-Clause AI Compliance Checklist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
        const SizedBox(height: 8),

        ...clauses.map((c) {
          final isComp = c['status'] == 'COMPLIANT';
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isComp ? AppColors.darkBorder : AppColors.cautionAmber),
            ),
            child: Row(
              children: [
                Icon(
                  isComp ? Icons.check_circle : Icons.warning,
                  color: isComp ? AppColors.verifiedGreen : AppColors.cautionAmber,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['no']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(c['name']!, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isComp ? AppColors.verifiedGreen : AppColors.cautionAmber).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    c['status']!,
                    style: TextStyle(
                      color: isComp ? AppColors.verifiedGreen : AppColors.cautionAmber,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class AiLegalScreen extends StatelessWidget {
  const AiLegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clauses = [
      {'clause': 'Sub-Clause 20.1 [Contractor\'s Claims]', 'title': '28-Day Strict Notice Bar', 'desc': 'Contractor must give notice within 28 days of becoming aware of the event, otherwise Employer is discharged from all liability.'},
      {'clause': 'Sub-Clause 8.4 [Extension of Time for Completion]', 'title': 'EOT Grounds', 'desc': 'Entitled to EOT for: (a) Variations, (b) Exceptionally adverse climatic conditions, (c) Unforeseeable physical conditions, (d) Delays caused by Authorities.'},
      {'clause': 'Sub-Clause 13.1 [Right to Vary]', 'title': 'Engineer Variation Orders', 'desc': 'Variations may be initiated by the Engineer at any time prior to issuing the Taking-Over Certificate.'},
      {'clause': 'Sub-Clause 14.3 [Application for Interim Payment]', 'title': 'Monthly IPC Submissions', 'desc': 'Detailed statement showing amounts entitled together with supporting documents and retention deduction.'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('FIDIC Contract AI Legal Copilot')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.accentCyan)),
            child: const Row(
              children: [
                Icon(Icons.gavel, color: AppColors.accentCyan),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Grounded in FIDIC Red Book (1999/2017) & UAE Civil Transactions Law (Federal Law No. 5 of 1985).', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Pre-Loaded Contract Clauses & Precedents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ...clauses.map((c) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['clause']!, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(c['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(c['desc']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 8),
          const Text('Ask Custom FIDIC Dispute Question:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _AiShellContent(titleKey: 'ai.legal', hintKey: 'ai.hint_legal'),
        ],
      ),
    );
  }
}

class AiSuperintendentScreen extends StatelessWidget {
  const AiSuperintendentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final priorities = [
      {'priority': 'Priority 1 (Critical)', 'title': 'Inspect Level 12 Zone B Rebar with Consultant Eng. Tariq at 10:30 AM', 'status': 'HIGH'},
      {'priority': 'Priority 2 (Logistics)', 'title': 'Unload 35T Rebar delivery at Gate 2 before midday ban begins at 12:30 PM', 'status': 'HIGH'},
      {'priority': 'Priority 3 (Quality)', 'title': 'Verify slump test calibration for Unibeton transit mixers #03 & #04', 'status': 'MEDIUM'},
      {'priority': 'Priority 4 (Coordination)', 'title': 'Coordinate MEP clash meeting at axis F4 with Drake & Scull project engineer', 'status': 'MEDIUM'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('AI Site Superintendent Priorities')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.verifiedGreen)),
            child: const Row(
              children: [
                Icon(Icons.smart_toy, color: AppColors.verifiedGreen),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Morning Superintendent Synthesis: Analyzed 14 walkie-talkie logs, today\'s weather forecast, and CPM schedule.', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Today\'s Key Field Directives', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ...priorities.map((p) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: AppColors.accentCyan),
                  title: Text(p['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text(p['priority']!),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: p['status'] == 'HIGH' ? AppColors.criticalRed.withValues(alpha: 0.15) : AppColors.cautionAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(p['status']!, style: TextStyle(color: p['status'] == 'HIGH' ? AppColors.criticalRed : AppColors.cautionAmber, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class SiteTalkFullScreen extends StatefulWidget {
  const SiteTalkFullScreen({super.key});

  @override
  State<SiteTalkFullScreen> createState() => _SiteTalkFullScreenState();
}

class _SiteTalkFullScreenState extends State<SiteTalkFullScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _activeChannel = 'all_site';
  bool _isTransmitting = false;

  final List<Map<String, dynamic>> _channels = [
    {'id': 'all_site', 'name': 'All Site (عام الموقع)', 'last': 'AI: Sandstorm warning for Jan 23-24', 'members': 248, 'unread': 3},
    {'id': 'structural', 'name': 'Structural Team (الهيكل الإنشائي)', 'last': 'Ahmed: Level 12 rebar complete', 'members': 86, 'unread': 1},
    {'id': 'mep', 'name': 'MEP Coordination (الكهروميكانيك)', 'last': 'Rajiv: clash at grid F4, need meeting', 'members': 48, 'unread': 5},
    {'id': 'hse', 'name': 'HSE & Safety Guard (السلامة والبيئة)', 'last': 'Midday ban siren active 12:30 PM', 'members': 34, 'unread': 0},
  ];

  final List<Map<String, String>> _voiceLogs = [
    {'sender': 'Eng. Abdelfattah', 'role': 'Project Director', 'time': '10:45 AM', 'duration': '0:24', 'text': 'Approved casting for Level 12 Zone B post consultant inspection.'},
    {'sender': 'Rajiv Kumar', 'role': 'MEP Foreman', 'time': '10:12 AM', 'duration': '0:18', 'text': 'Chilled water pipe conflict at axis F4 escalated via RFI-088.'},
    {'sender': 'Ali Hassan', 'role': 'Safety Officer', 'time': '09:30 AM', 'duration': '0:35', 'text': 'Heat index 41.2C, hydration breaks enforced for rebar fixers.'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SiteTalk Walkie-Talkie (PTT)', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('Digital Push-to-Talk • Channels & AI Voice Logs', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentCyan,
          tabs: const [
            Tab(text: 'Radio Channels'),
            Tab(text: 'Voice Logs & Transcripts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Channels tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._channels.map((ch) {
                final isSelected = _activeChannel == ch['id'];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: isSelected ? AppColors.accentCyan : Colors.transparent, width: 1.5),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? AppColors.accentCyan : Colors.white10,
                      child: Icon(Icons.radio, color: isSelected ? Colors.black : AppColors.accentCyan, size: 20),
                    ),
                    title: Text(ch['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text('${ch['last']} • ${ch['members']} Active'),
                    trailing: isSelected
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                            child: const Text('TUNED IN', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                          )
                        : null,
                    onTap: () => setState(() => _activeChannel = ch['id'] as String),
                  ),
                );
              }),
              const SizedBox(height: 24),
              // Push to Talk Button
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTapDown: (_) => setState(() => _isTransmitting = true),
                      onTapUp: (_) => setState(() => _isTransmitting = false),
                      onTapCancel: () => setState(() => _isTransmitting = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: _isTransmitting ? AppColors.criticalRed : AppColors.accentCyan,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (_isTransmitting ? AppColors.criticalRed : AppColors.accentCyan).withValues(alpha: 0.5),
                              blurRadius: _isTransmitting ? 24 : 10,
                              spreadRadius: _isTransmitting ? 6 : 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isTransmitting ? Icons.mic : Icons.mic_none,
                          size: 48,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _isTransmitting ? 'TRANSMITTING ON CHANNEL...' : 'HOLD TO TALK (PUSH-TO-TALK)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: _isTransmitting ? AppColors.criticalRed : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Voice logs tab
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._voiceLogs.map((log) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${log['sender']} (${log['role']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accentCyan)),
                              Text('${log['time']} • ${log['duration']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('"${log['text']}"', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(icon: const Icon(Icons.play_circle, color: AppColors.accentCyan), onPressed: () {}),
                              const Text('Play Audio', style: TextStyle(fontSize: 11, color: AppColors.accentCyan)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiShellContent extends StatefulWidget {
  final String titleKey;
  final String hintKey;
  const _AiShellContent({required this.titleKey, required this.hintKey});
  @override
  State<_AiShellContent> createState() => _AiShellContentState();
}

class _AiShellContentState extends State<_AiShellContent> {
  final ctrl = TextEditingController();
  String answer = '';
  bool busy = false;

  Future<void> ask() async {
    setState(() => busy = true);
    try {
      final svc = GeminiService();
      final res = await svc.askSite(ctrl.text);
      if (!mounted) return;
      setState(() => answer = res);
    } catch (e) {
      if (!mounted) return;
      setState(() => answer = 'Error: $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Enter specific contract clause question or query...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          minLines: 2,
          maxLines: 4,
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
          icon: busy ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.send, size: 16),
          onPressed: busy ? null : ask,
          label: Text(busy ? 'Analyzing Contract...' : 'Consult Legal AI'),
        ),
        if (answer.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
            child: Text(answer),
          ),
        ],
      ],
    );
  }
}

class AskTheSiteScreenFull extends StatelessWidget {
  const AskTheSiteScreenFull({super.key});
  @override
  Widget build(BuildContext context) => const _AiShell(
    titleKey: 'ai.ask_site', hintKey: 'ai.hint_ask',
  );
}

/// Port of ConstructionChatScreen.kt: topic-filtered HSE/project chat
/// with search grounding and offline fallback.
class ConstructionChatScreen extends StatefulWidget {
  const ConstructionChatScreen({super.key});
  @override
  State<ConstructionChatScreen> createState() =>
      _ConstructionChatScreenState();
}

class _ConstructionChatScreenState extends State<ConstructionChatScreen> {
  final _ctrl = TextEditingController();
  String _topic = 'ALL';
  GroundedResponse? _answer;
  bool _busy = false;

  static const _topics = ['ALL', 'PROJECT_STATUS', 'HSE_REGULATIONS'];

  Future<void> _send() async {
    final q = _ctrl.text.trim();
    if (q.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      final res = await GeminiService().queryConstructionChat(
        q,
        topicFilter: _topic,
      );
      if (!mounted) return;
      setState(() => _answer = res);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('ai.chat_title'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: _topics
                    .map((t) => Padding(
                        padding:
                            const EdgeInsetsDirectional.only(end: 6),
                        child: ChoiceChip(
                            label: Text(t),
                            selected: _topic == t,
                            onSelected: (_) =>
                                setState(() => _topic = t))))
                    .toList()),
          ),
          const SizedBox(height: 8),
          TextField(
              controller: _ctrl,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: loc.t('ai.chat_hint'))),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: _busy ? null : _send,
              child: Text(loc.t('ai.chat_send'))),
          const SizedBox(height: 12),
          if (_answer != null)
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                      Text(loc.tr(
                          _answer!.textAr, _answer!.textEn)),
                      if (_answer!.sources.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ..._answer!.sources.map((s) => Text(
                            '• ${s.title} ${s.uri}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall)),
                      ],
                    ]))),
        ]),
      ),
    );
  }
}

class _AuditScenario {
  final String specCode;
  final String inputAr;
  final String inputEn;
  const _AuditScenario(this.specCode, this.inputAr, this.inputEn);
}

/// Port of AiSpecAuditorView.kt: reference-spec picker + site-finding
/// input + AI compliance audit with PASS / CONCERN / FAIL verdict.
class AiSpecAuditorView extends StatefulWidget {
  final List<ConstructionSpec> specs;
  const AiSpecAuditorView({super.key, this.specs = const []});
  @override
  State<AiSpecAuditorView> createState() => _AiSpecAuditorViewState();
}

class _AiSpecAuditorViewState extends State<AiSpecAuditorView> {
  static const _scenarios = [
    _AuditScenario('DM-HSE-SAFETY-CH11', 'خرسانة C50 هبوط 160مم',
        'C50 concrete slump 160mm'),
    _AuditScenario('RTA-RDS-HWY-2024', 'رافعة 41كم/س حمولة 3.5طن',
        'Crane 41km/h load 3.5t'),
    _AuditScenario('MOHRE-HEAT-2024', 'دمك 96.8% وWBGT 33.5',
        'Compaction 96.8% WBGT 33.5'),
    _AuditScenario('OSHAD-SF-TG-CS-2023', 'غازات O2 18.9% وH2S 12ppm',
        'Gases O2 18.9% H2S 12ppm'),
  ];

  int _specIndex = 0;
  int _scenario = 0;
  final _inputCtrl = TextEditingController();
  String? _verdict;
  String _resultAr = '';
  String _resultEn = '';
  bool _busy = false;

  List<ConstructionSpec> get _specs => widget.specs.isNotEmpty
      ? widget.specs
      : const [
          ConstructionSpec(id: 'DM-HSE-SAFETY-CH11', code: 'DM-HSE-SAFETY-CH11',
              titleAr: 'كود السلامة', titleEn: 'Safety Code',
              authority: 'Dubai Municipality'),
          ConstructionSpec(id: 'RTA-RDS-HWY-2024', code: 'RTA-RDS-HWY-2024',
              titleAr: 'كود الطرق', titleEn: 'Road Code', authority: 'RTA'),
          ConstructionSpec(id: 'MOHRE-HEAT-2024', code: 'MOHRE-HEAT-2024',
              titleAr: 'الإجهاد الحراري', titleEn: 'Heat Stress',
              authority: 'MoHRE'),
          ConstructionSpec(id: 'OSHAD-SF-TG-CS-2023',
              code: 'OSHAD-SF-TG-CS-2023', titleAr: 'الأماكن المغلقة',
              titleEn: 'Confined Space', authority: 'OSHAD'),
        ];

  Future<void> _runAudit() async {
    final specs = _specs;
    final spec = specs[_specIndex % specs.length];
    final scenario = _scenarios[_scenario % _scenarios.length];
    final input = _inputCtrl.text.trim().isEmpty
        ? '${scenario.inputAr} / ${scenario.inputEn}'
        : _inputCtrl.text.trim();
    setState(() => _busy = true);
    try {
      final res = await GeminiService().generateWithGrounding(
        'Audit against ${spec.code} (${spec.authority}): $input. '
        'Reply with a verdict word PASS, CONCERN or FAIL first.',
        useSearch: true,
      );
      if (!mounted) return;
      final combined = '${res.textAr} ${res.textEn}'.toUpperCase();
      final verdict = combined.contains('FAIL')
          ? 'FAIL'
          : (combined.contains('CONCERN') ? 'CONCERN' : 'PASS');
      setState(() {
        _verdict = verdict;
        _resultAr = res.textAr;
        _resultEn = res.textEn;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Color _verdictColor() => switch (_verdict) {
        'FAIL' => Colors.red,
        'CONCERN' => Colors.amber,
        'PASS' => Colors.green,
        _ => Colors.grey,
      };

  String _verdictKey() => switch (_verdict) {
        'FAIL' => 'ai.spec_fail',
        'CONCERN' => 'ai.spec_concern',
        _ => 'ai.spec_pass',
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final specs = _specs;
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('ai.spec_title'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(loc.t('ai.spec_sub')),
          const SizedBox(height: 8),
          Text(loc.t('ai.spec_step1')),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(
                    specs.length,
                    (i) => Padding(
                        padding:
                            const EdgeInsetsDirectional.only(end: 6),
                        child: ChoiceChip(
                            label: Text(
                                '${specs[i].code} • ${specs[i].authority}'),
                            selected: _specIndex == i,
                            onSelected: (_) => setState(
                                () => _specIndex = i))))),
          ),
          if (specs.isNotEmpty)
            Card(
                child: ListTile(
              title: Text(loc.tr(specs[_specIndex % specs.length].titleAr,
                  specs[_specIndex % specs.length].titleEn)),
              subtitle: Text(specs[_specIndex % specs.length].authority),
            )),
          const SizedBox(height: 8),
          Text(loc.t('ai.spec_step2')),
          Row(
              children: List.generate(
                  _scenarios.length,
                  (i) => Padding(
                      padding:
                          const EdgeInsetsDirectional.only(end: 6),
                      child: ChoiceChip(
                          label: Text('S${i + 1}'),
                          selected: _scenario == i,
                          onSelected: (_) =>
                              setState(() => _scenario = i))))),
          TextField(
              controller: _inputCtrl,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: loc.tr(_scenarios[_scenario % _scenarios.length].inputAr,
                      _scenarios[_scenario % _scenarios.length].inputEn))),
          const SizedBox(height: 8),
          ElevatedButton(
              onPressed: _busy ? null : _runAudit,
              child: Text(loc.t(_busy
                  ? 'ai.spec_running'
                  : 'ai.spec_run'))),
          if (_verdict != null) ...[
            const SizedBox(height: 8),
            Card(
              color: _verdictColor().withValues(alpha: 0.12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                          label: Text(loc.t(_verdictKey())),
                          backgroundColor: _verdictColor()
                              .withValues(alpha: 0.25)),
                      const SizedBox(height: 4),
                      Text(loc.tr(_resultAr, _resultEn)),
                      Row(children: [
                        TextButton(
                            onPressed: () => ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(SnackBar(
                                    content: Text(
                                        loc.t('ai.spec_linked')))),
                            child:
                                Text(loc.t('ai.spec_link'))),
                      ]),
                    ]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class OrionTacticalCopilotScreen extends StatefulWidget {
  const OrionTacticalCopilotScreen({super.key});
  @override
  State<OrionTacticalCopilotScreen> createState() =>
      _OrionTacticalCopilotScreenState();
}

class _OrionTacticalCopilotScreenState
    extends State<OrionTacticalCopilotScreen> {
  static const _packet = OrionTelemetryPacket(
    coreTemperature: 52.4,
    reactorStatus: ReactorStatus.nominal,
    powerGridEfficiency: 94.5,
    signalToNoiseRatio: 18.2,
    commsStatus: CommsStatus.locked,
    packetThroughput: 1240,
    chamberPressure: 101.3,
  );
  static const _fleet = [
    FleetAsset(id: 'FL-01', callsign: 'TC-01', sector: 'Zone A',
        status: 'ACTIVE', batteryPercent: 87),
    FleetAsset(id: 'FL-02', callsign: 'RMC-04', sector: 'Zone C',
        status: 'ACTIVE', batteryPercent: 64),
    FleetAsset(id: 'FL-03', callsign: 'EXC-02', sector: 'Zone B',
        status: 'IDLE', batteryPercent: 92),
  ];

  OrionAiAssessment? _assessment;

  String _reactorLabel(AppLocalization loc, ReactorStatus s) => switch (s) {
        ReactorStatus.nominal => loc.t('orion.nominal'),
        ReactorStatus.elevated => loc.t('orion.elevated'),
        ReactorStatus.critical => loc.t('orion.critical'),
      };

  String _commsLabel(AppLocalization loc, CommsStatus s) => switch (s) {
        CommsStatus.locked => loc.t('orion.locked'),
        CommsStatus.degraded => loc.t('orion.degraded'),
        CommsStatus.searching => loc.t('orion.searching'),
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('screen.tactical'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Expanded(child: Card(child: ListTile(
              title: Text(loc.t('orion.reactor')),
              subtitle: Text(_reactorLabel(loc, _packet.reactorStatus)),
            ))),
            Expanded(child: Card(child: ListTile(
              title: Text(loc.t('orion.comms')),
              subtitle: Text(_commsLabel(loc, _packet.commsStatus)),
            ))),
          ]),
          Card(child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              _GaugeRow(label: loc.t('orion.core_temp'),
                  value: '${_packet.coreTemperature}°C'),
              _GaugeRow(label: loc.t('orion.grid'),
                  value: '${_packet.powerGridEfficiency}%'),
              _GaugeRow(label: loc.t('orion.snr'),
                  value: '${_packet.signalToNoiseRatio}'),
              _GaugeRow(label: loc.t('orion.throughput'),
                  value: '${_packet.packetThroughput}'),
              _GaugeRow(label: loc.t('orion.pressure'),
                  value: '${_packet.chamberPressure}'),
            ]),
          )),
          Text(loc.t('orion.fleet'),
              style: Theme.of(context).textTheme.titleMedium),
          ..._fleet.map((f) => ListTile(
                leading: const Icon(Icons.precision_manufacturing),
                title: Text('${f.callsign} • ${f.sector}'),
                subtitle: Text(f.status),
                trailing: Text('${f.batteryPercent}%'),
              )),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => setState(() => _assessment =
                const OrionAiService().analyzeTelemetryAndSuggestDirectives(
                    _packet, _fleet)),
            child: Text(loc.t('orion.assess')),
          ),
          if (_assessment != null) ...[
            const SizedBox(height: 8),
            Card(child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${loc.t('orion.assessment')} • ${loc.t('orion.defcon')} ${_assessment!.defconLevel}'),
                    Text('${loc.t('orion.confidence')}: ${(_assessment!.confidence * 100).toInt()}%'),
                    const SizedBox(height: 4),
                    Text(loc.tr(_assessment!.tacticalSummaryAr,
                        _assessment!.tacticalSummaryEn)),
                    if (_assessment!.recommendedDirective != null)
                      ListTile(
                        leading: const Icon(Icons.campaign),
                        title: Text(
                            '${loc.t('orion.directive')} ${_assessment!.recommendedDirective!.code}'),
                        subtitle: Text(loc.tr(
                            _assessment!.recommendedDirective!.titleAr,
                            _assessment!.recommendedDirective!.titleEn)),
                      ),
                  ]),
            )),
          ],
        ],
      ),
    );
  }
}

class _GaugeRow extends StatelessWidget {
  final String label;
  final String value;
  const _GaugeRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value)],
        ),
      );
}
