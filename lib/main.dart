// Flutter entry — Clean Architecture bootstrap.
// Port of MainActivity.kt onCreate/setContent. Old Kotlin project untouched.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app/shell/app_shell.dart';
import 'core/localization/app_localization.dart';
import 'core/theme/app_theme.dart';
import 'features/home/data/repositories/buildhub_repository.dart';
import 'features/finance/data/repositories/finance_repository.dart';
import 'features/procurement/data/repositories/procurement_repository.dart';
import 'features/safety/data/repositories/safety_repository.dart';
import 'features/sitepulse/data/repositories/sitepulse_repository.dart';
import 'features/vendors/data/repositories/vendors_repository.dart';
import 'features/planning/data/repositories/baseline_repository.dart';
import 'features/documents/data/repositories/sync_repository.dart';
import 'features/documents/data/services/auth_manager.dart';
import 'features/ai/data/services/voice_input.dart';
import 'features/ai/data/services/walkie_talkie.dart';
import 'features/siteops/data/services/offline_sync.dart';
import 'features/siteops/data/services/site_agents.dart';
import 'core/notifications/notification_center.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Preload default (Arabic) strings before first frame — no hardcoded fallback.
  final localization = AppLocalization();
  await localization.load();
  // TODO: await Firebase.initializeApp() after adding google-services.json /
  // GoogleService-Info.plist (mirrors google-services.json in the Kotlin app).
  runApp(BuildHubApp(localization: localization));
}

class BuildHubApp extends StatefulWidget {
  final AppLocalization localization;
  const BuildHubApp({super.key, required this.localization});
  @override
  State<BuildHubApp> createState() => _BuildHubAppState();
}

class _BuildHubAppState extends State<BuildHubApp> {
  bool sunlightMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLocalization>.value(
            value: widget.localization),
        ChangeNotifierProvider<BuildHubRepository>(
            create: (_) => BuildHubRepository()),
        ChangeNotifierProvider<VendorsRepository>(
            create: (_) => VendorsRepository()),
        ChangeNotifierProvider<SafetyRepository>(
            create: (_) => SafetyRepository()),
        ChangeNotifierProvider<ProcurementRepository>(
            create: (_) => ProcurementRepository()),
        ChangeNotifierProvider<FinanceRepository>(
            create: (_) => FinanceRepository()),
        ChangeNotifierProvider<SitePulseRepository>(
            create: (_) => SitePulseRepository()),
        ChangeNotifierProvider<BaselineRepository>(
            create: (_) => BaselineRepository()),
        ChangeNotifierProvider<DailyReportSyncRepository>(
            create: (_) => DailyReportSyncRepository()),
        ChangeNotifierProvider<RecordSyncRepository>(
            create: (_) => RecordSyncRepository()),
        ChangeNotifierProvider<AuthManager>(
            create: (_) => AuthManager()),
        ChangeNotifierProvider<VoiceInputManager>(
            create: (_) => VoiceInputManager()),
        ChangeNotifierProvider<WalkieTalkieAudioService>(
            create: (_) => WalkieTalkieAudioService()),
        ChangeNotifierProvider<OfflineSyncManager>(
            create: (_) => OfflineSyncManager()),
        ChangeNotifierProvider<AutonomousInputAgent>(
            create: (_) => AutonomousInputAgent()),
        ChangeNotifierProvider<SiteAiAgent>(
            create: (_) => SiteAiAgent()),
        ChangeNotifierProvider<NotificationCenter>(
            create: (_) => NotificationCenter()),
      ],
      builder: (context, _) {
        final loc = context.watch<AppLocalization>();
        return MaterialApp(
          title: loc.t('app.title'),
          debugShowCheckedModeBanner: false,
          locale: loc.locale,
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.darkIndustrial(),
          darkTheme: AppTheme.darkIndustrial(),
          themeMode: sunlightMode ? ThemeMode.light : ThemeMode.dark,
          builder: (context, child) => Directionality(
            textDirection: loc.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          ),
          home: AppShell(
            onToggleLanguage: () =>
                context.read<AppLocalization>().toggleLanguage(),
            onToggleSunlight: () =>
                setState(() => sunlightMode = !sunlightMode),
          ),
        );
      },
    );
  }
}
