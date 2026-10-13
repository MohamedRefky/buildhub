// Clean Architecture: AllServicesScreen
// Complete port of Kotlin AllServicesScreen.kt
// 10 Categories, 50+ Industrial Construction & AI Services, Search bar, SitePulse banner, Badges & Deep-link routing.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/theme/app_colors.dart';

class ServiceItem {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descAr;
  final String descEn;
  final IconData icon;
  final List<String> badges;
  final Color iconBgColor;
  final Color iconColor;
  final int targetTab;

  const ServiceItem({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descAr,
    required this.descEn,
    required this.icon,
    this.badges = const [],
    this.iconBgColor = const Color(0x2600E5FF),
    this.iconColor = AppColors.accentCyan,
    required this.targetTab,
  });
}

class ServiceCategory {
  final String id;
  final String nameAr;
  final String nameEn;
  final IconData icon;
  final List<ServiceItem> items;

  const ServiceCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.items,
  });
}

final List<ServiceCategory> allServiceCategories = [
  ServiceCategory(
    id: 'procurement',
    nameAr: 'الذكاء الشرائي',
    nameEn: 'Procurement Intelligence',
    icon: Icons.trending_up,
    items: [
      ServiceItem(
        id: 'ai_baseline_suite',
        titleAr: 'خريطة الأساس ومسار العمل الحرج (AI Baseline Suite)',
        titleEn: 'AI Baseline & Critical Path Suite',
        descAr: 'تفكيك WBS كامل للمشروع، ربط التوريدات بالمسار الحرج والمراقبة المستمرة',
        descEn: 'Full project lifecycle WBS, Procurement & QC links, Critical Path calculation',
        icon: Icons.timeline,
        badges: ['Full Lifecycle', 'Critical Path', 'AI Monitor'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 57,
      ),
      ServiceItem(
        id: 'verified_vendor_hub',
        titleAr: 'شبكة الموردين المعتمدين والموثقين (Verified Vendor Network)',
        titleEn: 'Verified Vendor Network & Approvals',
        descAr: 'تأهيل وفحص الموردين المعتمدين (RTA • DEWA • DM • Trakhees) ورادار الرخص',
        descEn: 'Vendor registration, official authority verification (RTA, DEWA, DM, Trakhees)',
        icon: Icons.verified,
        badges: ['Verified Badge', 'RTA/DEWA/DM', 'Expiry Radar'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 58,
      ),
      ServiceItem(
        id: 'risk_heatmap',
        titleAr: 'خريطة المخاطر الحرارية',
        titleEn: 'Risk Heat-Map',
        descAr: 'تدقيق ذكي للمخاطر وتحديد التأخيرات المحتملة مع خريطة بصرية تفاعلية',
        descEn: 'AI risk audit with visual heat-map - proactive delay management',
        icon: Icons.warning_amber_rounded,
        badges: ['AI', 'AI Audit'],
        iconColor: AppColors.criticalRed,
        iconBgColor: Color(0x26EF4444),
        targetTab: 48,
      ),
      ServiceItem(
        id: 'procurement_planning',
        titleAr: 'مركز المشتريات الموحد (Procurement Hub)',
        titleEn: 'Unified Procurement Hub',
        descAr: 'دورة المشتريات المتكاملة (MR -> RFQ -> PO -> فحص الموقع MIR برمز QR)',
        descEn: 'Unified supply chain: Requisition (MR) -> RFQ -> PO -> Site QR Delivery',
        icon: Icons.shopping_cart,
        badges: ['Unified Hub', '4-Step Cycle'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 5,
      ),
      ServiceItem(
        id: 'market_intelligence',
        titleAr: 'محرك ذكاء السوق وبورصة المواد',
        titleEn: 'Market Intelligence & Price Engine',
        descAr: 'أسعار الموردين الحية ومؤشرات التضخم في الإمارات واستشارات الشراء بالذكاء الاصطناعي',
        descEn: 'Real-time supplier prices, UAE/GCC inflation indices & AI advisory',
        icon: Icons.bar_chart,
        badges: ['Live Data', 'AI Advisor'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 20,
      ),
      ServiceItem(
        id: 'approval_engine',
        titleAr: 'محرك الاعتمادات الموحد والحوكمة (Approval Engine)',
        titleEn: 'Central Approval & Workflow Engine',
        descAr: 'مصفوفة الصلاحيات (Authority Matrix)، عداد اتفاقية الخدمة والتفويض وسجل التدقيق',
        descEn: 'Cross-module approval governance, SLA countdown & audit trail',
        icon: Icons.verified_user,
        badges: ['Authority Matrix', 'Audit Trail'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 54,
      ),
      ServiceItem(
        id: 'exception_override',
        titleAr: 'نظام الاستثناءات والتجاوزات المحكومة (Exception Control)',
        titleEn: 'Exception & Override Controls',
        descAr: 'تجاوزات مؤقتة مقيدة بحدود انتهاء تلقائية ومصفوفة مخاطر بدون أي تجاوز صامت',
        descEn: 'Controlled temporary overrides, auto-expiry limits & risk matrix',
        icon: Icons.gavel,
        badges: ['Zero Silent Bypasses', 'Auto-Expiry'],
        iconColor: AppColors.cautionAmber,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 55,
      ),
      ServiceItem(
        id: 'orion_roadmap',
        titleAr: 'خارطة الطريق المعتمدة وبوابات القرارات (Phased Roadmap)',
        titleEn: 'Phased Roadmap & Decision Gates',
        descAr: '١٤ مرحلة تطويرية (٠ إلى ١٣)، وبوابات القرارات الإلزامية A إلى K',
        descEn: '14 Development Phases (0 to 13), Decision Gates & Release Gates',
        icon: Icons.alt_route,
        badges: ['14 Phases', 'Gates A-K'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 56,
      ),
      ServiceItem(
        id: 'predictive_delay',
        titleAr: 'قمرة التحكم التجاري والتكاليف (Commercial Cockpit)',
        titleEn: 'Commercial & Cost Control Cockpit',
        descAr: 'توقع التأخيرات، مطالبات فيديك، إدارة الفروقات وحساب التكلفة المتوقعة',
        descEn: 'Predictive delay engine, FIDIC claims, variance management',
        icon: Icons.speed,
        badges: ['Predictive', 'FIDIC'],
        iconColor: AppColors.accentSky,
        iconBgColor: Color(0x2638BDF8),
        targetTab: 19,
      ),
    ],
  ),
  ServiceCategory(
    id: 'site_engineering',
    nameAr: 'هندسة الموقع والجودة',
    nameEn: 'Site Engineering & QA/QC',
    icon: Icons.verified,
    items: [
      ServiceItem(
        id: 'sitepulse',
        titleAr: 'غرفة عمليات الموقع (SitePulse™)',
        titleEn: 'SitePulse™ Daily CM Command Center',
        descAr: 'لوحة تحكم مدير الإنشاء الصباحية، القيود الميدانية، ومصفوفة اتخاذ القرار',
        descEn: 'Morning CM dashboard, live site constraints & decision matrix',
        icon: Icons.dashboard,
        badges: ['CM Control', 'Live Pulse'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 50,
      ),
      ServiceItem(
        id: 'concrete_qc',
        titleAr: 'الجودة الميدانية وفحص وتدقيق الخرسانة والمكعبات (SitePulse QA)',
        titleEn: 'Field Quality, Concrete QC & Cube Tests',
        descAr: 'فحص الهبوط (Slump Test)، اختبار كسر المكعبات ٧/٢٨ يوم وفق معيار ASTM C94',
        descEn: 'Slump test logging, 7/28 day cube compressive test & ASTM C94 QA',
        icon: Icons.science,
        badges: ['Cube QA', 'ASTM C94'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 50,
      ),
      ServiceItem(
        id: 'snagging_qa',
        titleAr: 'الملاحظات والعيوب الميدانية (SitePulse Snags)',
        titleEn: 'Field Observations & Snagging',
        descAr: 'تسجيل عيوب التشطيبات وملاحظات الاستشاري مع صور وتحديد الموقع ومتابعة الإغلاق',
        descEn: 'Punch list, snagging defects with photos, consultant sign-off',
        icon: Icons.check_circle_outline,
        badges: ['Punch List', 'NCR / SIR'],
        iconColor: AppColors.cautionAmber,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 50,
      ),
      ServiceItem(
        id: 'export_reports',
        titleAr: 'تصدير التقارير الهندسية الموحدة (SitePulse Reports)',
        titleEn: 'Unified Engineering PDF Reports',
        descAr: 'توليد وتصدير تقارير الموقع اليومية وسجلات الجودة بصيغة PDF قابلة للمشاركة',
        descEn: 'Automated daily site progress & QA report PDF generation',
        icon: Icons.picture_as_pdf,
        badges: ['PDF Export', 'Share Intent'],
        iconColor: AppColors.criticalRed,
        iconBgColor: Color(0x26EF4444),
        targetTab: 50,
      ),
      ServiceItem(
        id: 'rfi_submittals',
        titleAr: 'طلبات المعلومات والمراسلات (RFIs & Submittals)',
        titleEn: 'RFIs & Submittals State Machine',
        descAr: 'إدارة دورة حياة استفسارات الموقع والاعتمادات الفنية مع الاستشاري',
        descEn: 'Complete lifecycle for contractor RFIs, technical submittals',
        icon: Icons.assignment,
        badges: ['Workflow', 'Consultant'],
        iconColor: AppColors.accentSky,
        iconBgColor: Color(0x2638BDF8),
        targetTab: 29,
      ),
      ServiceItem(
        id: 'site_camera',
        titleAr: 'توثيق الموقع بالكاميرا (Site Progress Camera)',
        titleEn: 'Site Progress Camera',
        descAr: 'التقاط صور التوثيق الإنشائي مع التاريخ والوقت والإحداثيات الجغرافية التلقائية',
        descEn: 'Construction photo tagging with automatic timestamp and GPS metadata',
        icon: Icons.photo_camera,
        badges: ['Live Capture', 'GPS Tag'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 46,
      ),
    ],
  ),
  ServiceCategory(
    id: 'finance',
    nameAr: 'الأدوات المالية',
    nameEn: 'Financial Tools',
    icon: Icons.account_balance_wallet,
    items: [
      ServiceItem(
        id: 'cash_flow',
        titleAr: 'المالية وضريبة القيمة المضافة والمطالبات',
        titleEn: 'Finance, VAT & Claims',
        descAr: 'إدارة التدفقات النقدية، احتساب ضريبة القيمة المضافة ٥٪، المستخلصات والمطالبات',
        descEn: 'Cash flow forecasting, UAE 5% VAT calculations, IPC progress billing',
        icon: Icons.account_balance,
        badges: ['UAE VAT 5%', 'IPC Billing'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 7,
      ),
      ServiceItem(
        id: 'smart_wallet',
        titleAr: 'المحفظة الذكية (البيتي كاش وبطاقات المهندسين)',
        titleEn: 'Smart Petty Cash Wallet & Corporate Cards',
        descAr: 'إدارة عهدة الموقع الفورية، مسح الفواتير بالـ OCR، وبطاقات الدفع الذكية للعهد',
        descEn: 'Instant petty cash requests, receipt OCR scanning & corporate card limits',
        icon: Icons.credit_card,
        badges: ['OCR Scan', '0% Fees'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 52,
      ),
      ServiceItem(
        id: 'financial_ai',
        titleAr: 'الذكاء المالي والتمويل والتأمين',
        titleEn: 'Financial AI, BNPL & Micro-Insurance',
        descAr: 'حلول تمويل مشتريات مواد البناء (اشتر الآن وادفع لاحقاً) وتأمين مخاطر المقاولين',
        descEn: 'Material supply BNPL credit, invoice factoring & CAR insurance',
        icon: Icons.analytics,
        badges: ['BNPL Fin', 'CAR Insurance'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 40,
      ),
      ServiceItem(
        id: 'green_wallet',
        titleAr: 'المحفظة الخضراء وشهادات الكهرباء',
        titleEn: 'Green Wallet & Electricity Certificates (I-REC)',
        descAr: 'شهادات الطاقة المتجددة I-REC، كفاءة استهلاك DEWA والتحفيزات البيئية',
        descEn: 'Renewable energy I-REC credits, DEWA efficiency & green badges',
        icon: Icons.eco,
        badges: ['I-REC DEWA', 'Green Pass'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 53,
      ),
      ServiceItem(
        id: 'cost_to_complete',
        titleAr: 'التحكم المالي والقيمة المكتسبة (EVA & EAC)',
        titleEn: 'Cost Control & Earned Value (EVA)',
        descAr: 'حساب القيمة المكتسبة (EV, PV, AC)، مؤشرات CPI/SPI والتكلفة المتوقعة عند الإنجاز (EAC)',
        descEn: 'Earned value management (EVA), CPI/SPI metrics & Estimate at Completion',
        icon: Icons.calculate,
        badges: ['EVA Engine', 'EAC Forecast'],
        iconColor: AppColors.accentSky,
        iconBgColor: Color(0x2638BDF8),
        targetTab: 25,
      ),
    ],
  ),
  ServiceCategory(
    id: 'logistics',
    nameAr: 'اللوجستيات والعمليات',
    nameEn: 'Logistics & Operations',
    icon: Icons.local_shipping,
    items: [
      ServiceItem(
        id: 'live_gps_and_stations',
        titleAr: 'تتبع الشحنات والشاحنات اللحظي وأقرب محطات الخرسانة',
        titleEn: 'Live Shipments, Trucks Tracking & Batch Plants',
        descAr: 'تتبع مباشر لحركة خلاطات الخرسانة والشاحنات على الخريطة مع زمن الوصول المتوقع ETA',
        descEn: 'Live GPS locator for concrete transit mixers & nearest batching plants',
        icon: Icons.location_on,
        badges: ['Live GPS', 'ETA Radar'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 14,
      ),
      ServiceItem(
        id: 'submittal_and_smart_orders',
        titleAr: 'اعتماد المواد ونموذج الطلب والإشعارات الذكية المؤتمتة',
        titleEn: 'Material Submittals & Smart Orders',
        descAr: 'دورة اعتماد المواد مع الاستشاري ونموذج الطلب المؤتمت مع حساب الضريبة والإشعارات',
        descEn: 'Material technical submittals, smart automated order form with VAT',
        icon: Icons.assignment_turned_in,
        badges: ['Workflow', 'Auto-Alert'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 5,
      ),
      ServiceItem(
        id: 'field_receiving',
        titleAr: 'تطبيق الاستلام الميداني',
        titleEn: 'Field Receiving App',
        descAr: 'مطابقة الشحنات الميدانية عبر الباركود ورمز QR مع جداول الكميات BOQ',
        descEn: 'Mobile barcode & QR quantity delivery inspection matching BOQ',
        icon: Icons.qr_code_scanner,
        badges: ['Mobile QR', 'BOQ Match'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 3,
      ),
    ],
  ),
  ServiceCategory(
    id: 'field_ops',
    nameAr: 'العمليات الميدانية',
    nameEn: 'Field Operations',
    icon: Icons.engineering,
    items: [
      ServiceItem(
        id: 'site_talk',
        titleAr: 'محاكي اللاسلكي الفوري',
        titleEn: 'Site Talk (Walkie-Talkie)',
        descAr: 'تواصل صوتي ورسائل فورية للموقع مع مزامنة ذكية بدون إنترنت',
        descEn: 'Digital push-to-talk walkie-talkie for field crews, offline auto-sync',
        icon: Icons.cell_tower,
        badges: ['Push-To-Talk', 'Offline-First'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 26,
      ),
      ServiceItem(
        id: 'geo_attendance',
        titleAr: 'الحضور والانصراف الجغرافي',
        titleEn: 'Geo-Attendance',
        descAr: 'تسجيل الحضور ضمن نطاق ٢٠٠ متر لموقع المشروع مع التوافق مع نظام حماية الأجور WPS',
        descEn: 'Automatic GPS check-in/out within 200m site perimeter - WPS compliance',
        icon: Icons.person_pin_circle,
        badges: ['GPS 200m', 'WPS Compliant'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 28,
      ),
      ServiceItem(
        id: 'project_vault',
        titleAr: 'خزينة المشروع المشفرة',
        titleEn: 'Project Vault',
        descAr: 'مستودع مستندات هرمي آمن للمشروع مع تشفير عسكري متقدم AES-256',
        descEn: 'Secure hierarchical file vault: Company + Project ID + AES-256',
        icon: Icons.lock,
        badges: ['AES-256', 'Secure Vault'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 27,
      ),
      ServiceItem(
        id: 'weather_brain',
        titleAr: 'محرك الطقس الذكي (Weather Brain)',
        titleEn: 'Weather Brain Intelligence',
        descAr: 'معادلة مينزل لتبخر الخرسانة ACI 305R ومراقبة رياح الرافعات وحظر الظهيرة',
        descEn: 'ACI 305R evaporation rate, crane lift wind limits & UAE midday ban',
        icon: Icons.wb_sunny,
        badges: ['ACI 305R', 'Wind Radar'],
        iconColor: AppColors.cautionAmber,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 35,
      ),
      ServiceItem(
        id: 'activity_data_entry',
        titleAr: 'إدخال بيانات الأنشطة (Activity Data Hub)',
        titleEn: 'Site Activities Data Hub',
        descAr: 'تسجيل نسب الإنجاز والتسجيل الصوتي والصور والعمالة ومحاضر الصب بسهولة',
        descEn: 'Easily log progress %, voice logs, photos, manpower & slump tests',
        icon: Icons.edit_note,
        badges: ['Quick Add', 'Activities'],
        iconColor: AppColors.accentSky,
        iconBgColor: Color(0x2638BDF8),
        targetTab: 44,
      ),
      ServiceItem(
        id: 'offline_queue',
        titleAr: 'مزامنة التغييرات المعلقة (Offline Queue)',
        titleEn: 'Offline-to-Cloud Sync Queue',
        descAr: 'عداد العمليات المحفوظة محلياً والمزامنة التلقائية فور عودة الاتصال',
        descEn: 'Local SQLite queue counter with automatic background cloud sync',
        icon: Icons.sync,
        badges: ['SQLite DB', 'Auto-Sync'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 41,
      ),
      ServiceItem(
        id: 'firebase_cloud_sync',
        titleAr: 'ربط ومزامنة فايربيس (Firebase Cloud Sync)',
        titleEn: 'Firebase Cloud Sync Hub',
        descAr: 'مزامنة ثنائية الاتجاه مع Cloud Firestore لضمان استمرارية البيانات',
        descEn: 'Direct synchronization with Cloud Firestore backend database',
        icon: Icons.cloud_sync,
        badges: ['Cloud Firestore', 'Connected'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 45,
      ),
      ServiceItem(
        id: 'enterprise_integrations',
        titleAr: 'بوابة التكامل المؤسسي (ERP & Primavera P6)',
        titleEn: 'Enterprise Integrations Hub',
        descAr: 'ربط ومزامنة الجداول الزمنية مع Primavera P6 وإشعارات واتساب الأعمال',
        descEn: 'Schedule sync with Primavera P6 & WhatsApp Business API alerts',
        icon: Icons.business,
        badges: ['P6 Sync', 'Webhooks'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 33,
      ),
    ],
  ),
  ServiceCategory(
    id: 'safety_team',
    nameAr: 'السلامة وفريق العمل',
    nameEn: 'Safety & Team Hub',
    icon: Icons.health_and_safety,
    items: [
      ServiceItem(
        id: 'safety_qr_passport',
        titleAr: 'جوازات السلامة ورموز QR الذكية',
        titleEn: 'Safety Passports & Machine QR',
        descAr: 'شهادات تأهيل العمال، فحص المعدات برموز QR ورادار انتهاء الشهادات',
        descEn: 'Worker HSE credentials, machinery inspection QR passports & radar',
        icon: Icons.qr_code,
        badges: ['QR Passport', 'HSE Certs'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 6,
      ),
      ServiceItem(
        id: 'safety_shield',
        titleAr: 'درع السلامة والامتثال',
        titleEn: 'Safety Shield & Compliance',
        descAr: 'تذاكر السلامة وملاحظات HSE، معدات الوقاية الشخصية PPE والإبلاغ الفوري',
        descEn: 'Safety tickets, PPE compliance audits, hazard observations',
        icon: Icons.security,
        badges: ['Protected', 'Gov Ready'],
        iconColor: AppColors.criticalRed,
        iconBgColor: Color(0x26EF4444),
        targetTab: 6,
      ),
      ServiceItem(
        id: 'crane_wind',
        titleAr: 'سرعة الرياح وسلامة الرافعات البرجية (HSE Safety)',
        titleEn: 'Tower Crane Wind & Safety',
        descAr: 'مراقبة سرعة الرياح اللحظية والتنبيه التلقائي عند تجاوز حد ٣٨ كم/ساعة',
        descEn: 'Live anemometer monitoring with instant alert on 38 km/h wind limit',
        icon: Icons.air,
        badges: ['HSE Alert', '38 km/h Limit'],
        iconColor: AppColors.cautionAmber,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 6,
      ),
      ServiceItem(
        id: 'midday_work_ban',
        titleAr: 'حظر العمل وقت الظهيرة (وزارة الموارد البشرية)',
        titleEn: 'UAE Summer Midday Work Ban',
        descAr: 'مؤشر الإجهاد الحراري وساعات الحظر القانونية في صيف الإمارات (١٢:٣٠ - ٣:٠٠)',
        descEn: 'MOHRE UAE summer midday work ban timer (12:30 PM - 3:00 PM)',
        icon: Icons.thermostat,
        badges: ['MOHRE UAE', 'Compliance'],
        iconColor: AppColors.criticalRed,
        iconBgColor: Color(0x26EF4444),
        targetTab: 38,
      ),
      ServiceItem(
        id: 'worker_welfare',
        titleAr: 'رعاية العمال والتوافق العمالي (Worker Welfare)',
        titleEn: 'Worker Welfare & Standards',
        descAr: 'معايير السكن العمالي، حماية الأجور وتوثيق الرعاية الميدانية',
        descEn: 'Worker welfare living standards, health tracking & wage security',
        icon: Icons.groups,
        badges: ['Welfare', 'WPS'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 38,
      ),
      ServiceItem(
        id: 'buildnet',
        titleAr: 'شبكة بيلد نت ولينكدإن المهنية',
        titleEn: 'BuildNet & Professional Network',
        descAr: 'شبكة المقاولين والمهندسين، توثيق تراخيص SOE والتوظيف الهندسي المتخصص',
        descEn: 'Professional network with SOE engineering license verification',
        icon: Icons.connect_without_contact,
        badges: ['Network', 'LinkedIn', 'Verified'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 2,
      ),
    ],
  ),
  ServiceCategory(
    id: 'permits_gov',
    nameAr: 'التصاريح والامتثال',
    nameEn: 'Permits & Compliance',
    icon: Icons.gavel,
    items: [
      ServiceItem(
        id: 'permit_roadmap',
        titleAr: 'خارطة تصاريح البناء',
        titleEn: 'Permit Roadmap',
        descAr: 'تحديد متطلبات التصاريح الإنشائية حسب المنطقة والبلدية',
        descEn: 'Location-aware building permit tracking & milestone approvals',
        icon: Icons.map,
        badges: ['Smart Map', 'Authority'],
        iconColor: AppColors.accentSky,
        iconBgColor: Color(0x2638BDF8),
        targetTab: 5,
      ),
      ServiceItem(
        id: 'gcc_authorities_hub',
        titleAr: 'منصة هيئات دول مجلس التعاون (GCC Authorities Hub)',
        titleEn: 'GCC Authorities & Regulatory Hub',
        descAr: 'الاعتماد المتبادل للتراخيص الهندسية وأكواد البناء (SBC, DBC, QCS)',
        descEn: 'Cross-border engineering licensing, regional building codes',
        icon: Icons.language,
        badges: ['GCC Unified', 'Cross-Border'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 12,
      ),
      ServiceItem(
        id: 'ai_legal_copilot',
        titleAr: 'المحامي الآلي للعقود',
        titleEn: 'AI Legal Co-pilot',
        descAr: 'تحليل ذكي لعقود المقاولات وكشف الثغرات والامتثال لشروط فيديك FIDIC',
        descEn: 'AI contract analysis, risk clause detection & FIDIC compliance',
        icon: Icons.policy,
        badges: ['AI Legal', 'FIDIC'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 21,
      ),
    ],
  ),
  ServiceCategory(
    id: 'bim_digital',
    nameAr: 'النمذجة والأدوات الرقمية',
    nameEn: 'BIM & Digital Tools',
    icon: Icons.build,
    items: [
      ServiceItem(
        id: 'drawing_bim',
        titleAr: 'مستعرض المخططات وBIM ثلاثي الأبعاد',
        titleEn: 'Drawing & BIM 3D/2D Viewer',
        descAr: 'استعراض مخططات DWG/PDF وتحديد دبابيس الملاحظات الموقعية ومجسمات IFC',
        descEn: '2D drawing markup pins, architectural DWG viewer & 3D BIM coordination',
        icon: Icons.layers,
        badges: ['BIM 3D', 'Site Pins'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 32,
      ),
      ServiceItem(
        id: 'attached_specs',
        titleAr: 'مواصفات البناء والبنية التحتية والسلامة المرفقة',
        titleEn: 'Building & Infrastructure Specs',
        descAr: 'مستودع المواصفات الإلزامية الكاملة لكود دبي ٢٠٢٣، RTA، DEWA، وأوشاد',
        descEn: 'Master repository of attached DBC 2023, RTA, DEWA & OSHAD specs',
        icon: Icons.menu_book,
        badges: ['Full Specs', 'AI Audit'],
        iconColor: AppColors.accentSky,
        iconBgColor: Color(0x2638BDF8),
        targetTab: 51,
      ),
      ServiceItem(
        id: 'engineering_library',
        titleAr: 'المكتبة الهندسية المعتمدة',
        titleEn: 'Engineering Library',
        descAr: 'مراجع هندسية ومواصفات قياسية وكتالوجات تقنية معتمدة في الخليج',
        descEn: 'Technical engineering references, datasheets & Gulf standards',
        icon: Icons.local_library,
        badges: ['Codes', 'Standards'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 23,
      ),
      ServiceItem(
        id: 'training_courses',
        titleAr: 'الدورات والشهادات المهنية',
        titleEn: 'Training Courses',
        descAr: 'دورات هندسية وشهادات مهنية معتمدة من جهات تدريب موثوقة في الإمارات',
        descEn: 'Certified engineering courses and professional training programs',
        icon: Icons.school,
        badges: ['Certified', 'PDUs'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 24,
      ),
    ],
  ),
  ServiceCategory(
    id: 'marketplace',
    nameAr: 'السوق والاستدامة',
    nameEn: 'Marketplace & Sustainability',
    icon: Icons.shopping_cart,
    items: [
      ServiceItem(
        id: 'rent_equipment',
        titleAr: 'سوق المعدات والعمالة',
        titleEn: 'Equipment & Manpower Marketplace',
        descAr: 'تأجير وشراء الآليات الثقيلة والمعدات وتوظيف العمالة الفنية المتخصصة',
        descEn: 'Rent or buy heavy machinery, hire skilled operators & labor',
        icon: Icons.construction,
        badges: ['Heavy Fleet', 'Operators'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 15,
      ),
      ServiceItem(
        id: 'buy_materials',
        titleAr: 'سوق مواد البناء الموحد (Materials Market)',
        titleEn: 'Unified Materials Marketplace',
        descAr: 'طلب عروض الأسعار والكتالوجات المعتمدة وربطها التلقائي بدورة المشتريات',
        descEn: 'Approved vendor catalog with instant RFQ and site requisition sync',
        icon: Icons.storefront,
        badges: ['Approved', 'Direct RFQ'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 13,
      ),
      ServiceItem(
        id: 'compare_quotes',
        titleAr: 'مقارنة عروض الأسعار الذكية',
        titleEn: 'Compare Quotations',
        descAr: 'تحليل ومقارنة عروض الأسعار المتنافسة واختيار العرض الأنسب فنياً ومالياً',
        descEn: 'Side-by-side commercial & technical quote evaluation engine',
        icon: Icons.compare_arrows,
        badges: ['Smart Compare', 'Best Value'],
        iconColor: AppColors.accentSky,
        iconBgColor: Color(0x2638BDF8),
        targetTab: 22,
      ),
      ServiceItem(
        id: 'approved_vendors',
        titleAr: 'الموردون المعتمدون رسمياً',
        titleEn: 'Approved Vendors Directory',
        descAr: 'دليل الموردين المعتمدين والموثقين لدى الهيئات الرسمية والبلديات',
        descEn: 'Multi-authority verified suppliers directory (DM, RTA, DEWA)',
        icon: Icons.verified,
        badges: ['Verified', 'Approved'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 58,
      ),
      ServiceItem(
        id: 'esg_sustainability',
        titleAr: 'الاستدامة والبناء الأخضر (ESG & Green)',
        titleEn: 'ESG & Carbon Footprint',
        descAr: 'حساب الانبعاثات الكربونية، تحويل مخلفات الهدم وتوافق استدامة ومعايير LEED',
        descEn: 'Embodied carbon tracking, waste diversion & Estidama / LEED compliance',
        icon: Icons.recycling,
        badges: ['Estidama', 'LEED'],
        iconColor: AppColors.verifiedGreen,
        iconBgColor: Color(0x2610B981),
        targetTab: 37,
      ),
    ],
  ),
  ServiceCategory(
    id: 'ai_intel',
    nameAr: 'وكلاء الذكاء الاصطناعي',
    nameEn: 'AI Agents',
    icon: Icons.smart_toy,
    items: [
      ServiceItem(
        id: 'ai_site_superintendent',
        titleAr: 'مشرف الموقع الذكي ومراقب المحادثات',
        titleEn: 'AI Site Superintendent & Ambient Log',
        descAr: 'الاستماع المحيطي لمحادثات الموقع، استخراج المهام الفورية ورادار كشف المخاطر',
        descEn: 'Ambient site speech recognition, instant task extraction & safety radar',
        icon: Icons.auto_awesome,
        badges: ['Ambient AI', 'Live Radar'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 42,
      ),
      ServiceItem(
        id: 'orion_core',
        titleAr: 'الذكاء التكتيكي للمهمة (ORION B CORE AI)',
        titleEn: 'ORION B CORE Tactical AI Co-Pilot',
        descAr: 'مراقبة القياسات عن بعد وتوجيهات المهمة المباشرة وتحليل المخاطر المتقدم',
        descEn: 'Tactical mission co-pilot: live telemetry & anomaly directives',
        icon: Icons.psychology,
        badges: ['Gemini AI', 'Tactical'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 47,
      ),
      ServiceItem(
        id: 'ask_the_site',
        titleAr: 'اسأل الموقع (Site Memory RAG)',
        titleEn: 'Ask the Site (Site Memory AI)',
        descAr: 'استرجاع معرفي فوري وبحث في مستندات وسجلات وتسجيلات الموقع مع التوثيق',
        descEn: 'Grounded RAG semantic retrieval across site voice logs & RFIs',
        icon: Icons.forum,
        badges: ['RAG AI', 'Live Search'],
        iconColor: AppColors.accentSky,
        iconBgColor: Color(0x2638BDF8),
        targetTab: 36,
      ),
      ServiceItem(
        id: 'autonomous_input_agent',
        titleAr: 'وكيل الإدخال المستقل (Autopilot Agent)',
        titleEn: 'Autonomous Site Input Agent',
        descAr: 'إدارة وتسجيل كافة مدخلات الموقع تلقائياً في وضع الغياب مع التزامن السحابي',
        descEn: 'Autonomous site autopilot: logs progress & inputs while you are away',
        icon: Icons.flight_takeoff,
        badges: ['Autopilot', 'Away Mode'],
        iconColor: AppColors.goldEmirates,
        iconBgColor: Color(0x26F59E0B),
        targetTab: 43,
      ),
      ServiceItem(
        id: 'daily_report_agent',
        titleAr: 'مركز تصدير التقرير اليومي (SitePulse DPR)',
        titleEn: 'SitePulse Daily Progress Report',
        descAr: 'توليد وتصدير التقرير اليومي الموحد تلقائياً من تحديثات الموقع المباشرة',
        descEn: 'Unified daily progress report compilation directly from field logs',
        icon: Icons.description,
        badges: ['SitePulse DPR', 'Unified Flow'],
        iconColor: AppColors.accentCyan,
        iconBgColor: Color(0x2600E5FF),
        targetTab: 34,
      ),
    ],
  ),
];

class AllServicesScreen extends StatefulWidget {
  final void Function(int tab) onSelect;
  final int initialCategoryIndex;

  const AllServicesScreen({
    super.key,
    required this.onSelect,
    this.initialCategoryIndex = 0,
  });

  @override
  State<AllServicesScreen> createState() => _AllServicesScreenState();
}

class _AllServicesScreenState extends State<AllServicesScreen> {
  late int selectedCategoryIndex;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    selectedCategoryIndex = widget.initialCategoryIndex;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final scheme = Theme.of(context).colorScheme;

    final activeCategory = allServiceCategories[selectedCategoryIndex.clamp(0, allServiceCategories.length - 1)];

    final filteredItems = searchQuery.trim().isEmpty
        ? activeCategory.items
        : allServiceCategories
            .expand((cat) => cat.items)
            .where((item) {
              final query = searchQuery.toLowerCase();
              return item.titleAr.toLowerCase().contains(query) ||
                  item.titleEn.toLowerCase().contains(query) ||
                  item.descAr.toLowerCase().contains(query) ||
                  item.descEn.toLowerCase().contains(query) ||
                  item.badges.any((b) => b.toLowerCase().contains(query));
            })
            .fold<List<ServiceItem>>([], (list, item) {
              if (!list.any((x) => x.id == item.id)) list.add(item);
              return list;
            });

    return Column(
      children: [
        // Top Header matching original: "Orion B" + "جميع الخدمات والوحدات الهندسية" + "RTA Verified" green badge
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orion B',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          loc.tr('جميع الخدمات والوحدات الهندسية', 'All Services & Engineering Modules'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: scheme.onSurface,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // RTA Verified Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.verifiedGreen.withValues(alpha: 0.45),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: AppColors.verifiedGreen),
                        SizedBox(width: 4),
                        Text(
                          'RTA Verified',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.verifiedGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Search Bar
              TextField(
                controller: searchController,
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  hintText: loc.tr('ابحث في كل الميزات والخدمات...', 'Search all features & services...'),
                  prefixIcon: Icon(Icons.search, size: 20, color: scheme.onSurfaceVariant),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            searchController.clear();
                            setState(() => searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: scheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.accentCyan, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // SitePulse™ Control Room Quick Launch Banner
              InkWell(
                onTap: () => widget.onSelect(50),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.accentCyan.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentCyan.withValues(alpha: 0.45),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.dashboard, color: Colors.black, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'SitePulse™ Control Room',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: scheme.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.verifiedGreen.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    loc.tr('حي ومباشر', 'LIVE'),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.verifiedGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              loc.tr(
                                'ماذا يحدث بموقعي اليوم؟ ما الذي يوقفنا؟ من المسؤول؟',
                                'What is happening, what is stopping us, who is responsible?',
                              ),
                              style: TextStyle(
                                fontSize: 11,
                                color: scheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 18, color: AppColors.accentCyan),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Horizontal Category Tabs
        if (searchQuery.trim().isEmpty)
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: allServiceCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = allServiceCategories[index];
                final isSelected = index == selectedCategoryIndex;
                return ChoiceChip(
                  avatar: Icon(
                    cat.icon,
                    size: 16,
                    color: isSelected ? Colors.black : scheme.onSurfaceVariant,
                  ),
                  label: Text(loc.tr(cat.nameAr, cat.nameEn)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => selectedCategoryIndex = index);
                  },
                  selectedColor: AppColors.accentCyan,
                  backgroundColor: scheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected ? Colors.black : scheme.onSurface,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.accentCyan
                          : scheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  showCheckmark: false,
                );
              },
            ),
          ),

        const SizedBox(height: 8),

        // 2-Column Grid of Service Cards
        Expanded(
          child: filteredItems.isEmpty
              ? Center(
                  child: Text(
                    loc.tr('لا توجد خدمات مطابقة لبحثك', 'No services found matching your search'),
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.96,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return ServiceCard(
                      item: item,
                      onTap: () => widget.onSelect(item.targetTab),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final ServiceItem item;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  Color _getBadgeColor(String badge) {
    final lower = badge.toLowerCase();
    if (lower.contains('ai') || lower.contains('gemini') || lower.contains('rag')) {
      return AppColors.accentCyan;
    }
    if (lower.contains('live') || lower.contains('verified') || lower.contains('green') || lower.contains('connect')) {
      return AppColors.verifiedGreen;
    }
    if (lower.contains('code') || lower.contains('dm') || lower.contains('anemometer') || lower.contains('wind') || lower.contains('alert')) {
      return AppColors.cautionAmber;
    }
    if (lower.contains('gcc') || lower.contains('gov') || lower.contains('fidic') || lower.contains('p6') || lower.contains('gold')) {
      return AppColors.goldEmirates;
    }
    return AppColors.accentSky;
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: AppColors.darkBorder.withValues(alpha: 0.65),
          width: 0.9,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Icon + Stacked Pill Badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: item.iconColor.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Icon(item.icon, size: 20, color: item.iconColor),
                  ),
                  const Spacer(),
                  if (item.badges.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: item.badges.take(2).map((badge) {
                        final color = _getBadgeColor(badge);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: color.withValues(alpha: 0.4),
                              width: 0.7,
                            ),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                loc.tr(item.titleAr, item.titleEn),
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryDark,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Description
              Expanded(
                child: Text(
                  loc.tr(item.descAr, item.descEn),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondaryDark,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Bottom arrow
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: AppColors.accentCyan.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
