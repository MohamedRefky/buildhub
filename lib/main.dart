// Flutter entry — Clean Architecture bootstrap.
// Port of MainActivity.kt onCreate/setContent. Old Kotlin project untouched.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/shell/app_shell.dart';
import 'core/localization/app_localization.dart';
import 'core/theme/app_theme.dart';
import 'data/repository/buildhub_repository.dart';
import 'features/finance/data/finance_repository.dart';
import 'features/procurement/data/procurement_repository.dart';
import 'features/safety/data/safety_repository.dart';
import 'features/sitepulse/data/sitepulse_repository.dart';
import 'features/vendors/data/vendors_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: await Firebase.initializeApp() after adding google-services.json /
  // GoogleService-Info.plist (mirrors google-services.json in the Kotlin app).
  runApp(const BuildHubApp());
}

class BuildHubApp extends StatefulWidget {
  const BuildHubApp({super.key});
  @override
  State<BuildHubApp> createState() => _BuildHubAppState();
}

class _BuildHubAppState extends State<BuildHubApp> {
  bool sunlightMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppLocalization>(
            create: (_) => AppLocalization()),
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
      ],
      builder: (context, _) {
        final loc = context.watch<AppLocalization>();
        return MaterialApp(
          title: 'BuildHub / OrionB',
          debugShowCheckedModeBanner: false,
          locale: loc.locale,
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
