// Port of BuildHubSuperApp in MainActivity.kt — bottom nav with 5 tabs.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/localization/app_localization.dart';
import 'screens/dashboard_screen.dart';
import 'screens/all_services_screen.dart';
import 'screens/secondary_screens.dart';

class AppShell extends StatefulWidget {
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleSunlight;
  const AppShell({super.key, required this.onToggleLanguage, required this.onToggleSunlight});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Mirrors selectedTabIndex in MainActivity.kt (starts at Services = 1)
  int tab = 1;

  void go(int t) => setState(() => tab = t);

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();

    Widget body;
    String title;
    switch (tab) {
      case 0:
        body = DashboardScreen(onNavigateToTab: go);
        title = loc.tr('الرئيسية', 'Home');
        break;
      case 1:
        body = AllServicesScreen(onSelect: go);
        title = loc.tr('الخدمات', 'Services');
        break;
      case 2:
        body = const BuildNetScreen();
        title = loc.tr('التجاري', 'Commercial');
        break;
      case 3:
        body = const OrdersScreen();
        title = loc.tr('المستندات', 'Documents');
        break;
      case 4:
        body = const AiCopilotScreen();
        title = loc.tr('المساعد الذكي', 'Copilot');
        break;
      case 5:
        body = const ProcurementScreen();
        title = loc.tr('التوريد', 'Procurement');
        break;
      case 6:
        body = const SafetyScreen();
        title = loc.tr('السلامة', 'Safety');
        break;
      case 7:
        body = const FinanceScreen();
        title = loc.tr('المالية', 'Finance');
        break;
      default:
        body = GenericServiceScreen(tabId: tab, onBack: () => go(1));
        title = loc.tr('خدمة', 'Service');
    }

    final isTopLevel = [0, 1, 2, 3, 4].contains(tab);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.light_mode),
            onPressed: widget.onToggleSunlight,
            tooltip: 'Sunlight',
          ),
          TextButton(
            onPressed: widget.onToggleLanguage,
            child: Text(loc.tr('EN', 'عربي'),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: isTopLevel
          ? NavigationBar(
              selectedIndex: tab > 4 ? 1 : tab,
              onDestinationSelected: (i) {
                // Mirrors MainActivity.kt mapping: 2->22, 3->27, 4->9
                if (i == 2) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(loc.tr('التجاري — مقارنة عروض الأسعار',
                          'Commercial — quotation comparison'))));
                }
                go(i);
              },
              destinations: [
                NavigationDestination(
                    icon: const Icon(Icons.dashboard),
                    label: loc.tr('الرئيسية', 'Home')),
                NavigationDestination(
                    icon: const Icon(Icons.apps),
                    label: loc.tr('الخدمات', 'Services')),
                NavigationDestination(
                    icon: const Icon(Icons.receipt),
                    label: loc.tr('التجاري', 'Commercial')),
                NavigationDestination(
                    icon: const Icon(Icons.description),
                    label: loc.tr('المستندات', 'Docs')),
                NavigationDestination(
                    icon: const Icon(Icons.smart_toy),
                    label: loc.tr('المساعد', 'Copilot')),
              ],
            )
          : null,
    );
  }
}
