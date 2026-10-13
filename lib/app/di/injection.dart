// Clean Architecture: DI container.
// Port of di/DatabaseModule.kt + Hilt modules (HiltDatabaseModule,
// HiltOfflineSyncModule) using manual service locator (no code-gen).
//
// NOTE: keep explicit generics on each provider — raw
// ChangeNotifierProvider types break Provider.of lookups in tests.
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../core/localization/app_localization.dart';
import '../../core/notifications/notification_center.dart';
import '../../features/home/data/repositories/buildhub_repository.dart';
import '../../features/vendors/data/repositories/vendors_repository.dart';
import '../../features/safety/data/repositories/safety_repository.dart';
import '../../features/procurement/data/repositories/procurement_repository.dart';
import '../../features/finance/data/repositories/finance_repository.dart';
import '../../features/sitepulse/data/repositories/sitepulse_repository.dart';
import '../../features/planning/data/repositories/baseline_repository.dart';
import '../../features/documents/data/repositories/sync_repository.dart';
import '../../features/documents/data/services/auth_manager.dart';
import '../../features/ai/data/services/voice_input.dart';
import '../../features/ai/data/services/walkie_talkie.dart';
import '../../features/siteops/data/services/offline_sync.dart';
import '../../features/siteops/data/services/site_agents.dart';

class Injection {
  static List<SingleChildWidget> providers() => [
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
  ];
}
