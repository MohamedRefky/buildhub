// Clean Architecture: AllServicesScreen
// Presentation layer for the services catalog & industrial navigation.
// 10 Categories, 50+ Industrial Construction & AI Services, Search bar, SitePulse banner, Badges & Deep-link routing.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/service_entities.dart';
import '../../data/datasources/services_catalog.dart';
import '../widgets/service_card.dart';

// Re-export domain & data elements for backwards compatibility
export '../../domain/entities/service_entities.dart';
export '../../data/datasources/services_catalog.dart';
export '../widgets/service_card.dart';

/// Legacy alias to maintain compatibility with existing usages
final List<ServiceCategory> allServiceCategories = ServicesCatalog.categories;

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
    final categories = ServicesCatalog.categories;

    final activeCategory = categories[selectedCategoryIndex.clamp(0, categories.length - 1)];

    final filteredItems = searchQuery.trim().isEmpty
        ? activeCategory.items
        : categories
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
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
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
