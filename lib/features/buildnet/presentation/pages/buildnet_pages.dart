// Clean Architecture: BuildNet B2B Professional Network & Industry Hub.
// Faithful 1:1 Flutter port of original Kotlin Jetpack Compose screens:
// BuildNetHubView.kt, LinkedInHubView.kt, InteractiveFeedCards.kt,
// BuildNetProfileView.kt, B2BMarketplaceView.kt, BuildNetRecruitmentView.kt.

import 'package:flutter/material.dart';
import 'package:buildhub/core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// 1. DATA MODELS MATCHING KOTLIN BUILDNET MODELS
// ---------------------------------------------------------------------------

class EngineeringPollOption {
  final String id;
  final String textAr;
  final String textEn;
  int votesCount;

  EngineeringPollOption({
    required this.id,
    required this.textAr,
    required this.textEn,
    required this.votesCount,
  });
}

class EngineeringPoll {
  final String id;
  final String questionAr;
  final String questionEn;
  final List<EngineeringPollOption> options;
  int totalVotes;
  String? selectedOptionId;

  EngineeringPoll({
    required this.id,
    required this.questionAr,
    required this.questionEn,
    required this.options,
    required this.totalVotes,
    this.selectedOptionId,
  });
}

class TenderOpportunity {
  final String id;
  final String tenderNo;
  final String titleAr;
  final String titleEn;
  final String authorityAr;
  final String authorityEn;
  final double budgetAed;
  final int deadlineDays;
  final String locationAr;
  final String locationEn;
  final String categoryAr;
  final String categoryEn;
  final String scopeAr;
  final String scopeEn;
  final double bondPercent;

  TenderOpportunity({
    required this.id,
    required this.tenderNo,
    required this.titleAr,
    required this.titleEn,
    required this.authorityAr,
    required this.authorityEn,
    required this.budgetAed,
    required this.deadlineDays,
    required this.locationAr,
    required this.locationEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.scopeAr,
    required this.scopeEn,
    this.bondPercent = 5.0,
  });
}

class SubcontractRfp {
  final String id;
  final String packageNo;
  final String titleAr;
  final String titleEn;
  final String mainContractorAr;
  final String mainContractorEn;
  final String projectAr;
  final String projectEn;
  final String locationAr;
  final String locationEn;
  final double budgetAed;
  final String targetStartDate;
  final String scopeAr;
  final String scopeEn;
  final String tradeAr;
  final String tradeEn;

  SubcontractRfp({
    required this.id,
    required this.packageNo,
    required this.titleAr,
    required this.titleEn,
    required this.mainContractorAr,
    required this.mainContractorEn,
    required this.projectAr,
    required this.projectEn,
    required this.locationAr,
    required this.locationEn,
    required this.budgetAed,
    required this.targetStartDate,
    required this.scopeAr,
    required this.scopeEn,
    required this.tradeAr,
    required this.tradeEn,
  });
}

class SubcontractorVendor {
  final String id;
  final String nameAr;
  final String nameEn;
  final String tradeAr;
  final String tradeEn;
  final String grade;
  final double rating;
  final int reviewsCount;
  final int projectsDelivered;
  final String cityAr;
  final String cityEn;
  final double minContractAed;
  final String phone;
  final String email;
  final bool isVerified;
  final List<String> specializations;

  SubcontractorVendor({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.tradeAr,
    required this.tradeEn,
    required this.grade,
    required this.rating,
    required this.reviewsCount,
    required this.projectsDelivered,
    required this.cityAr,
    required this.cityEn,
    required this.minContractAed,
    required this.phone,
    required this.email,
    this.isVerified = true,
    required this.specializations,
  });
}

class HeavyEquipment {
  final String id;
  final String nameAr;
  final String nameEn;
  final String categoryAr;
  final String categoryEn;
  final String model;
  final String capacity;
  final double dailyRateAed;
  final double monthlyRateAed;
  final int availableCount;
  final String locationAr;
  final String locationEn;
  final bool operatorIncluded;
  final bool tuvCertified;
  final String supplier;

  HeavyEquipment({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.model,
    required this.capacity,
    required this.dailyRateAed,
    required this.monthlyRateAed,
    required this.availableCount,
    required this.locationAr,
    required this.locationEn,
    this.operatorIncluded = true,
    this.tuvCertified = true,
    required this.supplier,
  });
}

class ManpowerLeaseItem {
  final String id;
  final String jobTitleAr;
  final String jobTitleEn;
  final String companyAr;
  final String companyEn;
  final String hourlyRate;
  final List<String> tags;

  ManpowerLeaseItem({
    required this.id,
    required this.jobTitleAr,
    required this.jobTitleEn,
    required this.companyAr,
    required this.companyEn,
    required this.hourlyRate,
    required this.tags,
  });
}

// ---------------------------------------------------------------------------
// 2. MAIN BUILDNET HUB SCREEN (CONTAINER WITH 4 TABS)
// ---------------------------------------------------------------------------

class BuildNetHubScreen extends StatefulWidget {
  const BuildNetHubScreen({super.key});

  @override
  State<BuildNetHubScreen> createState() => _BuildNetHubScreenState();
}

class _BuildNetHubScreenState extends State<BuildNetHubScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.hub_outlined, color: AppColors.accentCyan, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'BuildNet GCC Network',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A66C2).withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF0A66C2)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link, size: 11, color: Color(0xFF0A66C2)),
                      SizedBox(width: 3),
                      Text('LinkedIn Sync', style: TextStyle(color: Color(0xFF0A66C2), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const Text(
              'شبكة الأعمال والمهندسين المعتمدين في دول مجلس التعاون',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentCyan,
          indicatorWeight: 3,
          labelColor: AppColors.accentCyan,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dynamic_feed, size: 18), text: 'LinkedIn & Feed'),
            Tab(icon: Icon(Icons.person_pin, size: 18), text: 'المهندسون & البروفايل'),
            Tab(icon: Icon(Icons.storefront, size: 18), text: 'سوق المقاولين B2B'),
            Tab(icon: Icon(Icons.badge, size: 18), text: 'التوظيف والعمالة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _LinkedInHubTab(),
          _BuildNetProfileTab(),
          _B2BMarketplaceTab(),
          _BuildNetRecruitmentTab(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. TAB 1: LINKEDIN HUB & INTERACTIVE FEED CARDS
// ---------------------------------------------------------------------------

class _LinkedInHubTab extends StatefulWidget {
  const _LinkedInHubTab();

  @override
  State<_LinkedInHubTab> createState() => _LinkedInHubTabState();
}

class _LinkedInHubTabState extends State<_LinkedInHubTab> {
  bool _isSyncing = false;
  String? _syncStatus;

  // Poll state
  late EngineeringPoll _poll;

  // Tenders state
  final List<TenderOpportunity> _tenders = [
    TenderOpportunity(
      id: 'tnd-01',
      tenderNo: 'TND-DXB-2026-881',
      titleAr: 'أعمال البنية التحتية والمرافق - مشروع نخلة جبل علي (الحزمة 3)',
      titleEn: 'Palm Jebel Ali Infrastructure & Utilities (Package 3)',
      authorityAr: 'نخيل العقارية (Nakheel PJSC)',
      authorityEn: 'Nakheel PJSC',
      budgetAed: 4800000.0,
      deadlineDays: 12,
      locationAr: 'دبي - نخلة جبل علي',
      locationEn: 'Dubai - Palm Jebel Ali',
      categoryAr: 'شبكات صرف وتصريف مياه أمطار',
      categoryEn: 'Stormwater & Drainage Networks',
      scopeAr: 'تمديد 18 كم من أنابيب GRP بقطر 1200 مم وإنشاء 4 محطات رفع هيدروليكية',
      scopeEn: '18km GRP pipeline installation & 4 hydraulic lift stations',
      bondPercent: 5.0,
    ),
    TenderOpportunity(
      id: 'tnd-02',
      tenderNo: 'TND-AUH-2026-402',
      titleAr: 'أعمال التكسية المعمارية والواجهات الزجاجية الذكية - جزيرة الريم',
      titleEn: 'Smart Architectural Façade & Glazing - Reem Island',
      authorityAr: 'الدار العقارية (Aldar Properties)',
      authorityEn: 'Aldar Properties',
      budgetAed: 9200000.0,
      deadlineDays: 19,
      locationAr: 'أبوظبي - جزيرة الريم',
      locationEn: 'Abu Dhabi - Reem Island',
      categoryAr: 'واجهات وألومنيوم مقاوم للحريق',
      categoryEn: 'Curtain Wall & Fire-Rated Cladding',
      scopeAr: 'تكسية واجهات زجاجية مزدوجة متوافقة مع اشتراطات الدفاع المدني DCD',
      scopeEn: 'Double-glazed DCD compliant curtain wall installation',
      bondPercent: 5.0,
    ),
  ];

  // Subcontract RFP state
  final List<SubcontractRfp> _rfps = [
    SubcontractRfp(
      id: 'sub-01',
      packageNo: 'SUB-2026-114',
      titleAr: 'مقاول باطن لأعمال الكهروميكانيك وإطفاء الحريق (MEP & Firefighting)',
      titleEn: 'MEP & Firefighting Subcontract Package',
      mainContractorAr: 'المقاولون العرب (تحالف أوراسكوم والنابودة)',
      mainContractorEn: 'Arab Contractors (Orascom-Naboodah JV)',
      projectAr: 'برج مارينا ليفينج (Marina Living Tower)',
      projectEn: 'Marina Living Tower',
      locationAr: 'دبي مارينا',
      locationEn: 'Dubai Marina',
      budgetAed: 1250000.0,
      targetStartDate: '2026/11/01',
      scopeAr: 'توريد وتركيب مجاري الهواء وشبكة الرشاشات ومضخات الحريق المعتمدة',
      scopeEn: 'Supply & install approved HVAC ducts, sprinklers & fire pumps',
      tradeAr: 'كهروميكانيك وحريق',
      tradeEn: 'MEP & Fire Protection',
    ),
  ];

  // Industry posts
  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'Unibeton Ready Mix Official',
      'role': 'Leading Concrete Supplier in GCC • Top Partner',
      'time': 'منذ 3 ساعات',
      'text': 'تم توريد 480 م³ من الخرسانة الخضراء C50 بنسبة استبدال 65% خبث أفران (GGBS) لمشروع برج معتمد LEED Gold في وسط مدينة دبي وفق مواصفات بلدية دبي DBC 2023.',
      'tag': '#GreenConcrete #Estidama #DubaiMunicipality #ACI305R',
      'likes': 94,
      'comments': 16,
      'isLiked': true,
      'verified': true,
    },
    {
      'author': 'Eng. Tariq Al-Mansoor',
      'role': 'Principal Structural Consultant • Dar Al-Handasah',
      'time': 'منذ 7 ساعات',
      'text': 'فحص تسليح بلاطة الطابق 12 بمشروع برج المارينا: اجتاز الفحص الاستشاري بنجاح بنسبة مطابقة 98.2% بدون أي عدم مطابقة NCR. جاهزون لصب الخرسانة الليلة.',
      'tag': '#StructuralEngineering #MarinaTower #InspectionPassed',
      'likes': 142,
      'comments': 28,
      'isLiked': false,
      'verified': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _poll = EngineeringPoll(
      id: 'poll-01',
      questionAr: 'ما هو الإجراء المعتمد لمعالجة التعشيش الخرساني (Honeycomb) في الأعمدة وفق كود دبي للبناء DBC؟',
      questionEn: 'What is the approved procedure for concrete honeycomb repair in columns per Dubai Building Code (DBC)?',
      options: [
        EngineeringPollOption(
          id: 'opt-1',
          textAr: 'استخدام مونة إسمنتية غير قابلة للانكماش (Non-Shrink Grout) بعد فحص الاستشاري',
          textEn: 'Approved Non-Shrink Grout post inspection',
          votesCount: 112,
        ),
        EngineeringPollOption(
          id: 'opt-2',
          textAr: 'حقن إيبوكسي تحت ضغط منخفض للتشققات الدقيقة فقط',
          textEn: 'Low-pressure epoxy injection for hairline micro-cracks',
          votesCount: 22,
        ),
        EngineeringPollOption(
          id: 'opt-3',
          textAr: 'إزالة كامل العمود وإعادة الصب دون الرجوع للاستشاري',
          textEn: 'Full column demolition without consultant review',
          votesCount: 8,
        ),
      ],
      totalVotes: 142,
    );
  }

  void _syncLinkedIn() async {
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      _syncStatus = 'تمت مزامنة بيانات LinkedIn بنجاح: تم تحديث 4 اعتمادات مهنية و 1,480 جهة اتصال.';
    });
  }

  void _showShareDialog() {
    String category = 'HSE';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: AppColors.darkCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.share, color: Color(0xFF0A66C2)),
              SizedBox(width: 8),
              Text('نشر إنجاز الموقع على LinkedIn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('اختر فئة المنشور المهني:', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('HSE السلامة', style: TextStyle(fontSize: 11)),
                    selected: category == 'HSE',
                    selectedColor: AppColors.verifiedGreen.withValues(alpha: 0.3),
                    onSelected: (_) => setDlgState(() => category = 'HSE'),
                  ),
                  const SizedBox(width: 6),
                  ChoiceChip(
                    label: const Text('إنجاز صب Milestone', style: TextStyle(fontSize: 11)),
                    selected: category == 'MILESTONE',
                    selectedColor: AppColors.accentCyan.withValues(alpha: 0.3),
                    onSelected: (_) => setDlgState(() => category = 'MILESTONE'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Text(
                  category == 'HSE'
                      ? 'إنجاز 1,000,000 ساعة عمل آمنة بدون إصابات هادرة (Zero LTI) في مشروع برج الوصل - دبي، التزاماً بكود سلامة الإنشاءات ببلدية دبي Ch. 11.4.'
                      : 'إتمام صب 2,400 م³ من الخرسانة المسلحة للأساسات الحصيرة (Raft Foundation) في برج مارينا ليفينج في 18 ساعة متواصلة مع Unibeton.',
                  style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.white),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A66C2),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.send, size: 16),
              label: const Text('نشر فوري على LinkedIn'),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFF0A66C2),
                    content: Text('تم نشر الإنجاز على صفحة شركتك وحسابك المهني على LinkedIn بنجاح!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBidDialog(TenderOpportunity tender) {
    final priceCtrl = TextEditingController(text: '${tender.budgetAed.toInt()}');
    final durationCtrl = TextEditingController(text: '90 يوماً');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.gavel, color: AppColors.goldEmirates),
            const SizedBox(width: 8),
            Expanded(
              child: Text('تقديم عطاء: ${tender.tenderNo}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tender.titleAr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
              const SizedBox(height: 4),
              Text('الجهة المالكة: ${tender.authorityAr}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const Divider(height: 20),
              TextField(
                controller: priceCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'قيمة العطاء المالي المقترح (AED)',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on, color: AppColors.goldEmirates),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'المدة الزمنية المقترحة للتنفيذ',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer, color: AppColors.accentCyan),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.goldEmirates.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  'ملاحظة: يشترط إرفاق خطاب ضمان بنكي ابتدائي (Bid Bond) بنسبة 5% من القيمة الإجمالية.',
                  style: TextStyle(fontSize: 11, color: AppColors.goldEmirates),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تسجيل عطائكم رسمياً للمناقصة ${tender.tenderNo} لدى ${tender.authorityAr}.')),
              );
            },
            child: const Text('تأكيد وإرسال العطاء'),
          ),
        ],
      ),
    );
  }

  void _showQuoteDialog(SubcontractRfp rfp) {
    final quoteCtrl = TextEditingController(text: '${rfp.budgetAed.toInt()}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.request_quote, color: AppColors.accentCyan),
            const SizedBox(width: 8),
            Expanded(child: Text('عرض تسعير باطن: ${rfp.packageNo}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(rfp.titleAr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
            const SizedBox(height: 4),
            Text('المقاول الرئيسي: ${rfp.mainContractorAr}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const Divider(height: 18),
            TextField(
              controller: quoteCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'السعر الإجمالي المقدم (AED)',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money, color: AppColors.verifiedGreen),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.verifiedGreen, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إرسال عرض التسعير إلى ${rfp.mainContractorAr} بنجاح!')),
              );
            },
            child: const Text('إرسال التسعير المباشر'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. LINKEDIN PROFILE INTEGRATION CARD
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0A66C2), Color(0xFF004182)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: const Color(0xFF0A66C2).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Text('TA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('Eng. Tariq Al-Mansoor', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            SizedBox(width: 6),
                            Icon(Icons.verified, color: Colors.white, size: 16),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Senior Structural Consultant • Dar Al-Handasah',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('SOE UAE #48102', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            const Text('1,480+ علاقة هندسية', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                    ),
                    icon: _isSyncing
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.sync, size: 16),
                    label: Text(_isSyncing ? 'جاري المزامنة...' : 'مزامنة مع LinkedIn'),
                    onPressed: _isSyncing ? null : _syncLinkedIn,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0A66C2),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('مشاركة إنجاز موقع'),
                    onPressed: _showShareDialog,
                  ),
                ],
              ),
              if (_syncStatus != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Expanded(child: Text(_syncStatus!, style: const TextStyle(color: Colors.white, fontSize: 11))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 2. OFFICIAL EMIRATES ACCREDITATION BADGES
        const Text(
          'الاعتمادات والتراخيص المهنية الموثقة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildBadgeCard('تأشيرة الإقامة الذهبية', 'فئة المهندسين الاستشاريين', Icons.workspace_premium, AppColors.goldEmirates),
              _buildBadgeCard('بلدية دبي (DM)', 'معتمد مباني شاهقة G+12', Icons.apartment, AppColors.accentCyan),
              _buildBadgeCard('إدارة المشاريع PMP®', 'شهادة دولية PMI معتمدة', Icons.verified, AppColors.verifiedGreen),
              _buildBadgeCard('مباني خضراء LEED AP', 'معتمد الاستدامة BD+C', Icons.eco, AppColors.verifiedGreen),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 3. INTERACTIVE ENGINEERING POLL CARD
        const Text(
          'استطلاع رأي هندسي موقعي مباشر',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Card(
          color: AppColors.darkCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.accentCyan.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.accentCyan.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.how_to_vote, size: 18, color: AppColors.accentCyan),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('استطلاع كود البناء الميداني', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan)),
                            Text('صادر عن مجتمع استشاريي الهندسة الإنشائية', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.cautionAmber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                      child: const Text('مفتوح للتصويت', style: TextStyle(color: AppColors.cautionAmber, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _poll.questionAr,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, height: 1.4, color: Colors.white),
                ),
                const SizedBox(height: 14),
                ..._poll.options.map((opt) {
                  final isSelected = _poll.selectedOptionId == opt.id;
                  final hasVoted = _poll.selectedOptionId != null;
                  final pct = _poll.totalVotes > 0 ? (opt.votesCount / _poll.totalVotes) : 0.0;

                  return GestureDetector(
                    onTap: hasVoted
                        ? null
                        : () {
                            setState(() {
                              _poll.selectedOptionId = opt.id;
                              opt.votesCount += 1;
                              _poll.totalVotes += 1;
                            });
                          },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.accentCyan : AppColors.darkBorder,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Stack(
                        children: [
                          if (hasVoted)
                            FractionallySizedBox(
                              widthFactor: pct,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  size: 16,
                                  color: isSelected ? AppColors.accentCyan : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    opt.textAr,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? Colors.white : Colors.grey.shade300,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (hasVoted)
                                  Text(
                                    '${(pct * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: isSelected ? AppColors.accentCyan : Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'إجمالي الأصوات: ${_poll.totalVotes} مهندساً مسجلاً',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 4. OFFICIAL TENDERS & RFPS CARDS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('مناقصات وعطاءات حكومية وخاصة (GCC)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
            Text('${_tenders.length} مناقصة نشطة', style: const TextStyle(fontSize: 11, color: AppColors.accentCyan)),
          ],
        ),
        const SizedBox(height: 10),
        ..._tenders.map((t) => Card(
              color: AppColors.darkCard,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.darkBorder)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.goldEmirates.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(t.tenderNo, style: const TextStyle(color: AppColors.goldEmirates, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 14, color: AppColors.criticalRed),
                            const SizedBox(width: 4),
                            Text('متبقي ${t.deadlineDays} يوماً', style: const TextStyle(color: AppColors.criticalRed, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(t.titleAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('الجهة: ${t.authorityAr} • ${t.locationAr}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text('النطاق: ${t.scopeAr}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('الميزانية التقديرية', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text('${t.budgetAed.toStringAsFixed(0)} AED', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.verifiedGreen)),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentCyan,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          icon: const Icon(Icons.gavel, size: 14),
                          label: const Text('تقديم عطاء فني ومالي', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          onPressed: () => _showBidDialog(t),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 14),

        // 5. SUBCONTRACT RFPS
        const Text('فرص التعاقد من الباطن (Direct Subcontracts)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        const SizedBox(height: 10),
        ..._rfps.map((rfp) => Card(
              color: AppColors.darkCard,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.darkBorder)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(rfp.packageNo, style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        Text('البدء: ${rfp.targetStartDate}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(rfp.titleAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('المقاول الرئيسي: ${rfp.mainContractorAr}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text('المشروع: ${rfp.projectAr} • الميزانية: ${rfp.budgetAed.toStringAsFixed(0)} AED', style: const TextStyle(fontSize: 11, color: AppColors.goldEmirates, fontWeight: FontWeight.bold)),
                    const Divider(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.verifiedGreen, foregroundColor: Colors.black),
                        icon: const Icon(Icons.request_quote, size: 14),
                        label: const Text('تقديم تسعير مباشر (Instant Quote)'),
                        onPressed: () => _showQuoteDialog(rfp),
                      ),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 14),

        // 6. INDUSTRY POSTS
        const Text('منشورات مهنية وتحديثات ميدانية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        const SizedBox(height: 10),
        ..._posts.map((p) => Card(
              color: AppColors.darkCard,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.darkBorder)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.accentCyan.withValues(alpha: 0.2),
                          child: const Icon(Icons.person, color: AppColors.accentCyan, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(p['author'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, size: 14, color: AppColors.verifiedGreen),
                                ],
                              ),
                              Text(p['role'] as String, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Text(p['time'] as String, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(p['text'] as String, style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.white)),
                    const SizedBox(height: 6),
                    Text(p['tag'] as String, style: const TextStyle(fontSize: 10, color: AppColors.accentCyan, fontWeight: FontWeight.bold)),
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          icon: Icon(
                            (p['isLiked'] as bool) ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                            size: 16,
                            color: (p['isLiked'] as bool) ? AppColors.accentCyan : Colors.grey,
                          ),
                          label: Text('${p['likes']} إعجاب', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          onPressed: () {
                            setState(() {
                              final cur = p['isLiked'] as bool;
                              p['isLiked'] = !cur;
                              p['likes'] = (p['likes'] as int) + (cur ? -1 : 1);
                            });
                          },
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.comment_outlined, size: 16, color: Colors.grey),
                          label: Text('${p['comments']} تعليق', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, size: 16, color: Colors.grey),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ رابط المنشور للمشاركة.')));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildBadgeCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      width: 175,
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(fontSize: 9, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. TAB 2: BUILDNET PROFILE & VERIFIED PORTFOLIO (BUILDNETPROFILEVIEW.KT)
// ---------------------------------------------------------------------------

class _BuildNetProfileTab extends StatefulWidget {
  const _BuildNetProfileTab();

  @override
  State<_BuildNetProfileTab> createState() => _BuildNetProfileTabState();
}

class _BuildNetProfileTabState extends State<_BuildNetProfileTab> {
  final List<Map<String, dynamic>> _portfolio = [
    {
      'title': 'برج كراون السكني - وسط مدينة دبي (Burj Crown)',
      'client': 'إعمار العقارية (Emaar Properties)',
      'role': 'مدير المشروع العام (Project Director)',
      'budget': '650,000,000 د.إ',
      'year': '2024',
      'metrics': '44 طابقاً • 440 شقة فخمة • 85,000 م²',
      'status': 'تم التسليم بنجاح مع شهادة إنجاز بلدية دبي',
      'tags': ['High-Rise', 'BIM 4D', 'Post-Tension', 'LEED Gold', 'Dubai Code'],
      'highlights': 'إدارة كاملة للأعمال المدنية والكهروميكانيكية وتطبيق نمذجة المعلومات 4D BIM، وتسليم المشروع قبل الموعد بـ 28 يوماً.',
      'color': AppColors.accentCyan,
    },
    {
      'title': 'مساكن خور دبي - الواجهة البحرية (Phase 1)',
      'client': 'دبي القابضة & إعمار (Dubai Holding & Emaar)',
      'role': 'استشاري إنشائي رئيسي وممثل المقاول',
      'budget': '820,000,000 د.إ',
      'year': '2023',
      'metrics': '6 أبراج متصلة • 1,280 وحدة • منصة مارينا',
      'status': 'منجز ومعتمد من الدفاع المدني DCD وهيئة الطرق RTA',
      'tags': ['Deep Piling', 'Marine Works', 'Dewatering', 'FIDIC Red Book'],
      'highlights': 'حل معضلات النزح المائي العميق (Dewatering) على خط الواجهة البحرية واستخدام أوتاد بقطر 1200 مم لعمق 32 متراً.',
      'color': AppColors.verifiedGreen,
    },
    {
      'title': 'مجمع فلل حدائق دبي هيلز الفاخرة (Package B)',
      'client': 'مِراس & إعمار (Meraas & Emaar)',
      'role': 'مدير عقود ومطالبات فيديك (Commercial & Contracts)',
      'budget': '380,000,000 د.إ',
      'year': '2022',
      'metrics': '220 فيلا معاصرة • شبكة طرق وبنية تحتية',
      'status': 'مسلم بالكامل للملاك مع شهادات فحص الضمان DLP',
      'tags': ['Villas', 'Infrastructure', 'Value Eng', 'FIDIC 1999'],
      'highlights': 'هندسة القيمة (Value Engineering) وفرت 34 مليون درهم دون التأثير على معايير العزل والجودة المعمارية.',
      'color': AppColors.goldEmirates,
    },
  ];

  final List<Map<String, dynamic>> _specializations = [
    {'name': 'تصميم الخرسانة مسبقة الإجهاد (Post-Tensioning)', 'count': 142, 'endorsed': false},
    {'name': 'سند جوانب الحفر والأوتاد العميقة (Deep Shoring & Piling)', 'count': 98, 'endorsed': true},
    {'name': 'إدارة مطالبات فيديك الكتاب الأحمر (FIDIC Red Book Claims)', 'count': 116, 'endorsed': false},
    {'name': 'معايير الاستدامة وكود المباني الخضراء (LEED & Estidama)', 'count': 84, 'endorsed': true},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Hero Header
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.accentCyan.withValues(alpha: 0.2),
                    child: const Text('TA', style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 22)),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Eng. Tariq Al-Mansoor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(width: 6),
                            Icon(Icons.verified, color: AppColors.verifiedGreen, size: 18),
                          ],
                        ),
                        SizedBox(height: 3),
                        Text('Senior Structural Director • Dar Al-Handasah', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(height: 4),
                        Text('Society of Engineers UAE #SOE-48102', style: TextStyle(fontSize: 11, color: AppColors.accentCyan, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white30)),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('تحميل السيرة CV (PDF)'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري تنزيل السيرة الهندسية المعتمدة...')));
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('تعديل البروفايل'),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 4 Key Achievements
        Row(
          children: [
            _buildStatItem('1.85B د.إ', 'قيمة المشاريع المنجزة', AppColors.accentCyan),
            const SizedBox(width: 8),
            _buildStatItem('24+', 'مشاريع كبرى مسلمة', AppColors.goldEmirates),
            const SizedBox(width: 8),
            _buildStatItem('18 Yrs', 'سنوات الخبرة في الإمارات', AppColors.verifiedGreen),
            const SizedBox(width: 8),
            _buildStatItem('Zero LTI', 'سجل سلامة مثالي', AppColors.accentCyan),
          ],
        ),
        const SizedBox(height: 20),

        // Portfolio Projects
        const Text('سجل المشاريع الهندسية المسلمة (Verified Portfolio)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        const SizedBox(height: 10),
        ..._portfolio.map((proj) => Card(
              color: AppColors.darkCard,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: (proj['color'] as Color).withValues(alpha: 0.3))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(proj['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: (proj['color'] as Color).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(proj['year'] as String, style: TextStyle(color: proj['color'] as Color, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('العميل: ${proj['client']} • الدور: ${proj['role']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text(proj['metrics'] as String, style: const TextStyle(fontSize: 11, color: AppColors.goldEmirates, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(proj['highlights'] as String, style: const TextStyle(fontSize: 11, height: 1.4, color: Colors.white70)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: (proj['tags'] as List<String>).map((t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.darkBorder)),
                            child: Text(t, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          )).toList(),
                    ),
                    const Divider(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الميزانية: ${proj['budget']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.verifiedGreen)),
                        Row(
                          children: [
                            const Icon(Icons.check_circle, size: 14, color: AppColors.verifiedGreen),
                            const SizedBox(width: 4),
                            Text(proj['status'] as String, style: const TextStyle(fontSize: 10, color: AppColors.verifiedGreen)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 14),

        // Endorsed Specializations
        const Text('التخصصات والمهارات المعتمدة مع التزكيات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        const SizedBox(height: 10),
        ..._specializations.map((spec) => Card(
              color: AppColors.darkCard,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(spec['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text('${spec['count']} تزكية من استشاريين ومقاولين', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                trailing: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: (spec['endorsed'] as bool) ? AppColors.verifiedGreen : AppColors.accentCyan,
                  ),
                  icon: Icon((spec['endorsed'] as bool) ? Icons.check : Icons.thumb_up, size: 14),
                  label: Text((spec['endorsed'] as bool) ? 'تمت التزكية' : 'تزكية'),
                  onPressed: () {
                    setState(() {
                      final cur = spec['endorsed'] as bool;
                      spec['endorsed'] = !cur;
                      spec['count'] = (spec['count'] as int) + (cur ? -1 : 1);
                    });
                  },
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildStatItem(String val, String lbl, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
            const SizedBox(height: 2),
            Text(lbl, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. TAB 3: B2B MARKETPLACE (B2BMARKETPLACEVIEW.KT)
// ---------------------------------------------------------------------------

class _B2BMarketplaceTab extends StatefulWidget {
  const _B2BMarketplaceTab();

  @override
  State<_B2BMarketplaceTab> createState() => _B2BMarketplaceTabState();
}

class _B2BMarketplaceTabState extends State<_B2BMarketplaceTab> with SingleTickerProviderStateMixin {
  late TabController _subTabController;
  final TextEditingController _searchCtrl = TextEditingController();

  final List<SubcontractorVendor> _vendors = [
    SubcontractorVendor(
      id: 'sub-01',
      nameAr: 'مجموعة الخليج للكهروميكانيك MEP',
      nameEn: 'Gulf MEP Engineering Contractors',
      tradeAr: 'أعمال كهروميكانيكية وتكييف مركزي (MEP & HVAC)',
      tradeEn: 'MEP & Central HVAC Contracting',
      grade: 'فئة أولى استشاري • معتمد DEWA & ADDC',
      rating: 4.9,
      reviewsCount: 58,
      projectsDelivered: 42,
      cityAr: 'دبي',
      cityEn: 'Dubai',
      minContractAed: 250000.0,
      phone: '+971 4 398 2200',
      email: 'tenders@gulfmep.ae',
      specializations: ['BMS', 'Chilled Water', 'Firefighting', 'Substations'],
    ),
    SubcontractorVendor(
      id: 'sub-02',
      nameAr: 'الشرق للأوتاد وسند جوانب الحفر (Piling)',
      nameEn: 'Al Sharq Deep Foundation & Shoring',
      tradeAr: 'نزح مياه جوفية وأوتاد خرسانية عميقة',
      tradeEn: 'Deep Piling, Secant Walls & Dewatering',
      grade: 'مصنف أوتاد غير محدود • معتمد بلدية دبي',
      rating: 4.8,
      reviewsCount: 44,
      projectsDelivered: 65,
      cityAr: 'دبي وأبوظبي',
      cityEn: 'Dubai & Abu Dhabi',
      minContractAed: 400000.0,
      phone: '+971 2 554 8190',
      email: 'rfq@alsharqpiling.ae',
      specializations: ['Secant Piles', 'Wellpoints', 'Micro-piling', 'Load Tests'],
    ),
    SubcontractorVendor(
      id: 'sub-03',
      nameAr: 'الإمارات للواجهات الإنشائية والزجاج (Façade)',
      nameEn: 'Emirates Architectural Façade & Cladding',
      tradeAr: 'واجهات زجاجية مسبقة الصنع وألواح الألمنيوم',
      tradeEn: 'Unitized Curtain Walls & Aluminium Cladding',
      grade: 'معتمد الدفاع المدني DCD لمقاومة الحريق',
      rating: 4.9,
      reviewsCount: 37,
      projectsDelivered: 29,
      cityAr: 'الشارقة ودبي',
      cityEn: 'Sharjah & Dubai',
      minContractAed: 350000.0,
      phone: '+971 6 534 1122',
      email: 'contracts@emiratesfacade.ae',
      specializations: ['Double Glazing', 'DCD Fire Safe', 'Spider Glass', 'Louvers'],
    ),
    SubcontractorVendor(
      id: 'sub-04',
      nameAr: 'أطلس للمنشآت الفولاذية والحديد الإنشائي',
      nameEn: 'Atlas Structural Steel Fabrication',
      tradeAr: 'تصنيع وتركيب هياكل فولاذية وجسور ثقيلة',
      tradeEn: 'Heavy Steel Structures & Trusses',
      grade: 'فئة ممتازة • طاقة إنتاج 2,500 طن/شهرياً',
      rating: 4.7,
      reviewsCount: 31,
      projectsDelivered: 51,
      cityAr: 'أبوظبي (مصفح)',
      cityEn: 'Abu Dhabi (Mussafah)',
      minContractAed: 180000.0,
      phone: '+971 2 551 7733',
      email: 'estimating@atlassteel.ae',
      specializations: ['CNC Cutting', 'Blast Cleaning', 'Anchor Bolts', 'Warehouses'],
    ),
  ];

  final List<HeavyEquipment> _equipment = [
    HeavyEquipment(
      id: 'eq-01',
      nameAr: 'رافعة برجية 16 طن بدون رأس (Topless Crane)',
      nameEn: 'Topless Tower Crane 16-Ton',
      categoryAr: 'رافعات برجية',
      categoryEn: 'Tower Cranes',
      model: 'Potain MDT 389 L16',
      capacity: '16 طن أقصى حمولة • ذراع 75 متراً',
      dailyRateAed: 1600.0,
      monthlyRateAed: 34000.0,
      availableCount: 3,
      locationAr: 'مدينة دبي الصناعية (DIC)',
      locationEn: 'Dubai Industrial City',
      supplier: 'النابودة لتأجير المعدات الثقيلة',
    ),
    HeavyEquipment(
      id: 'eq-02',
      nameAr: 'مضخة خرسانة جاهزة محمولة على شاحنة 42 م',
      nameEn: 'Truck-Mounted Concrete Pump 42m',
      categoryAr: 'معدات صب الخرسانة',
      categoryEn: 'Concrete Pumps',
      model: 'Putzmeister BSF 42-5',
      capacity: 'ضخ 160 م³/ساعة • ذراع هيدروليكي 5 وصلات',
      dailyRateAed: 2800.0,
      monthlyRateAed: 58000.0,
      availableCount: 2,
      locationAr: 'الراشدية، دبي',
      locationEn: 'Al Rashidiya, Dubai',
      supplier: 'شركة يونيميكس للخرسانة الجاهزة',
    ),
    HeavyEquipment(
      id: 'eq-03',
      nameAr: 'بلدوزر كوماتسو D85EX مجهز بكسارة صخور',
      nameEn: 'Komatsu D85EX-15 Bulldozer',
      categoryAr: 'معدات حفر وتسوية',
      categoryEn: 'Bulldozers',
      model: 'Komatsu D85EX-15',
      capacity: 'محرك 264 حصان • وزن تشغيلي 28 طن',
      dailyRateAed: 1200.0,
      monthlyRateAed: 24000.0,
      availableCount: 4,
      locationAr: 'رأس الخور الصناعية 2',
      locationEn: 'Ras Al Khor Ind. 2',
      supplier: 'كلداري لتجارة المعدات الثقيلة',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _subTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _subTabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showRfqDialog(SubcontractorVendor vendor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('طلب عرض سعر (RFQ): ${vendor.nameAr}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التصنيف: ${vendor.grade}', style: const TextStyle(fontSize: 11, color: AppColors.accentCyan)),
            const SizedBox(height: 8),
            Text('الحد الأدنى لقيمة التعاقد: ${vendor.minContractAed.toStringAsFixed(0)} AED', style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const Divider(height: 18),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'عنوان الحزمة أو نطاق العمل',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم إرسال RFQ إلى ${vendor.nameAr} بنجاح!')),
              );
            },
            child: const Text('إرسال طلب التسعير'),
          ),
        ],
      ),
    );
  }

  void _showBookEquipmentDialog(HeavyEquipment eq) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('حجز معدة: ${eq.nameAr}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الموديل: ${eq.model}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
            const SizedBox(height: 4),
            Text('سعر الإيجار اليومي: ${eq.dailyRateAed.toStringAsFixed(0)} AED', style: const TextStyle(fontSize: 11, color: AppColors.goldEmirates, fontWeight: FontWeight.bold)),
            Text('سعر الإيجار الشهري: ${eq.monthlyRateAed.toStringAsFixed(0)} AED', style: const TextStyle(fontSize: 11, color: AppColors.verifiedGreen, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('الموقع: مدينة دبي الصناعية • شامل السائق وفحص TUV', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.goldEmirates, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم حجز المعدة ${eq.model} بنجاح. سيتواصل المورد لتأكيد الإرسال.')),
              );
            },
            child: const Text('تأكيد الحجز الفوري'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sub-tabs: Subcontractors vs Heavy Equipment
        Container(
          color: AppColors.darkSurface,
          child: TabBar(
            controller: _subTabController,
            indicatorColor: AppColors.accentCyan,
            labelColor: AppColors.accentCyan,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.business, size: 16), text: 'دليل مقاولي الباطن المعتمدين'),
              Tab(icon: Icon(Icons.forklift, size: 16), text: 'تأجير المعدات الثقيلة والرافعات'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _subTabController,
            children: [
              // Subcontractors List
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _vendors.length,
                itemBuilder: (ctx, i) {
                  final v = _vendors[i];
                  return Card(
                    color: AppColors.darkCard,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.darkBorder)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.accentCyan.withValues(alpha: 0.15),
                                child: const Icon(Icons.domain, color: AppColors.accentCyan, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(v.nameAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.verified, size: 14, color: AppColors.verifiedGreen),
                                      ],
                                    ),
                                    Text(v.tradeAr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: AppColors.goldEmirates),
                                  const SizedBox(width: 2),
                                  Text('${v.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('التصنيف: ${v.grade}', style: const TextStyle(fontSize: 11, color: AppColors.accentCyan)),
                          const SizedBox(height: 4),
                          Text('مشاريع مسلمة: ${v.projectsDelivered} • الموقع: ${v.cityAr}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: v.specializations.map((s) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(4)),
                                  child: Text(s, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                )).toList(),
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('الحد الأدنى: ${v.minContractAed.toStringAsFixed(0)} AED', style: const TextStyle(fontSize: 11, color: AppColors.goldEmirates, fontWeight: FontWeight.bold)),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                                icon: const Icon(Icons.send, size: 14),
                                label: const Text('طلب عرض سعر RFQ'),
                                onPressed: () => _showRfqDialog(v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Heavy Equipment List
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _equipment.length,
                itemBuilder: (ctx, i) {
                  final eq = _equipment[i];
                  return Card(
                    color: AppColors.darkCard,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.darkBorder)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: AppColors.goldEmirates.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                                child: Text(eq.categoryAr, style: const TextStyle(color: AppColors.goldEmirates, fontWeight: FontWeight.bold, fontSize: 11)),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.check_circle, size: 13, color: AppColors.verifiedGreen),
                                  const SizedBox(width: 4),
                                  Text('متاح (${eq.availableCount}) وحدات', style: const TextStyle(color: AppColors.verifiedGreen, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(eq.nameAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('الموديل: ${eq.model} • السعة: ${eq.capacity}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          const SizedBox(height: 6),
                          Text('المورد: ${eq.supplier} • الموقع: ${eq.locationAr}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
                          const Divider(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${eq.dailyRateAed.toStringAsFixed(0)} AED / يوم', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.goldEmirates)),
                                  Text('${eq.monthlyRateAed.toStringAsFixed(0)} AED / شهر', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.verifiedGreen)),
                                ],
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.goldEmirates, foregroundColor: Colors.black),
                                icon: const Icon(Icons.bookmark_add, size: 14),
                                label: const Text('حجز المعدة الآن'),
                                onPressed: () => _showBookEquipmentDialog(eq),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 6. TAB 4: RECRUITMENT & SKILLED MANPOWER (BUILDNETRECRUITMENTVIEW.KT)
// ---------------------------------------------------------------------------

class _BuildNetRecruitmentTab extends StatelessWidget {
  const _BuildNetRecruitmentTab();

  static final List<ManpowerLeaseItem> _recruitmentItems = [
    ManpowerLeaseItem(
      id: '1',
      jobTitleAr: 'نجار مسلح وقوالب خرسانية',
      jobTitleEn: 'Steel Fixer & Formwork Carpenter',
      companyAr: 'شركة المقاولات العربية (Arabtec)',
      companyEn: 'Arabtec Contracting',
      hourlyRate: '45 AED/hr',
      tags: ['معتمد بلدية', 'جاهز فوراً', 'شهادة سلامة'],
    ),
    ManpowerLeaseItem(
      id: '2',
      jobTitleAr: 'مشغل رافعة برجية مرخص',
      jobTitleEn: 'Certified Tower Crane Operator',
      companyAr: 'الأساسات الحديثة للمعدات',
      companyEn: 'Modern Foundations',
      hourlyRate: '85 AED/hr',
      tags: ['خبرة 10+ سنوات', 'رخصة TUV', 'لغة إنجليزية'],
    ),
    ManpowerLeaseItem(
      id: '3',
      jobTitleAr: 'كهربائي تمديدات مباني ومحطات',
      jobTitleEn: 'MEP Building Electrician',
      companyAr: 'إلكترو-ميكانيكا الخليج',
      companyEn: 'Gulf Electro-Mech',
      hourlyRate: '55 AED/hr',
      tags: ['معتمد DEWA', 'متاح فوراً', 'فحص مهني'],
    ),
    ManpowerLeaseItem(
      id: '4',
      jobTitleAr: 'عامل لحام هياكل فولاذية معتمد 6G',
      jobTitleEn: 'Certified 6G Structural Welder',
      companyAr: 'صناعات الحديد الإنشائي',
      companyEn: 'Steel Industries LLC',
      hourlyRate: '65 AED/hr',
      tags: ['شهادة AWS', 'فحص أشعة راديوغرافية', 'فوري'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.badge, color: AppColors.accentCyan, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('توظيف وتأجير العمالة الفنية الماهرة (WPS Compliant)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    SizedBox(height: 2),
                    Text('عمالة نظامية موثقة وفق اشتراطات حماية الأجور والجواز المهني الرقمي.', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ..._recruitmentItems.map((item) => Card(
              color: AppColors.darkCard,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.darkBorder)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.jobTitleAr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(item.hourlyRate, style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(item.companyAr, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      children: item.tags.map((t) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.darkSurface, borderRadius: BorderRadius.circular(4)),
                            child: Text(t, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                          )).toList(),
                    ),
                    const Divider(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                        icon: const Icon(Icons.person_add, size: 14),
                        label: const Text('طلب استقدام / تأجير الحزمة'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تم إرسال طلب تأجير: ${item.jobTitleAr}. سيتواصل مسؤول الموارد البشرية معك.')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
