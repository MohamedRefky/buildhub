// Clean Architecture: Procurement & Heavy Machinery Market â€” Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// MachineryMarketplaceScreen, ConstructionOpenMarketScreen, GpsMaterialLocatorScreen,
// QuotationComparisonScreen, OrdersProcurementScreen, SuppliersCompaniesDirectoryScreen,
// GccTendersAiScreen.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:buildhub/core/localization/app_localization.dart';
import 'package:buildhub/core/theme/app_colors.dart';
import 'package:buildhub/features/procurement/data/repositories/procurement_repository.dart';
import 'package:buildhub/shared/widgets/material_procurement_view.dart';

// ---------------------------------------------------------------------------
// 1. HEAVY MACHINERY MARKETPLACE (DUBIZZLE STYLE)
// ---------------------------------------------------------------------------

class MachineryMarketScreen extends StatefulWidget {
  const MachineryMarketScreen({super.key});

  @override
  State<MachineryMarketScreen> createState() => _MachineryMarketScreenState();
}

class _MachineryMarketScreenState extends State<MachineryMarketScreen> {
  String _selectedType = 'ALL'; // ALL, FOR_RENT, FOR_SALE
  String _selectedCategory = 'ALL';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _machinery = [
    {
      'title': 'Caterpillar 336D Hydraulic Excavator',
      'category': 'Excavators',
      'type': 'FOR_RENT',
      'price': '1,400 AED / Day',
      'monthly': '28,000 AED / Mo',
      'location': 'Dubai Industrial City (DIC)',
      'hours': '3,420 Hours Logged',
      'operator': true,
      'telematics': 'GPS Active (Live)',
      'inspection': 'Valid DM / TUV Third Party Cert',
      'supplier': 'Al Naboodah Heavy Plant',
      'rating': 4.9,
      'phone': '+971 4 294 8888',
    },
    {
      'title': 'Liebherr LTM 1100-4.2 All Terrain Mobile Crane (100 Ton)',
      'category': 'Mobile Cranes',
      'type': 'FOR_RENT',
      'price': '3,800 AED / Day',
      'monthly': '75,000 AED / Mo',
      'location': 'Abu Dhabi â€“ Musaffah Ind.',
      'hours': '4,150 Hours Logged',
      'operator': true,
      'telematics': 'Telematics Active (Safe Load Indic.)',
      'inspection': 'Third Party Inspection Passed',
      'supplier': 'Al Jaber Heavy Crane Transport',
      'rating': 4.8,
      'phone': '+971 2 555 4000',
    },
    {
      'title': 'Putzmeister BSF 42-5 16H Concrete Boom Pump',
      'category': 'Concrete Pumps',
      'type': 'FOR_RENT',
      'price': '45 AED / mآ³ Pumped',
      'monthly': 'Min. 120 mآ³ / Pour',
      'location': 'Sharjah Industrial 12',
      'hours': '2,800 Hours',
      'operator': true,
      'telematics': 'Flow Rate Sensor Online',
      'inspection': 'Boom Thickness Ultrasonic Tested',
      'supplier': 'Unibeton Pumping Div.',
      'rating': 4.9,
      'phone': '+971 6 534 2200',
    },
    {
      'title': 'Komatsu D85EX-15 Bulldozer (Ripper Equipped)',
      'category': 'Bulldozers',
      'type': 'FOR_SALE',
      'price': '420,000 AED (Sale)',
      'monthly': 'Outright Purchase',
      'location': 'Ras Al Khor Industrial 2',
      'hours': '5,800 Hours Logged',
      'operator': false,
      'telematics': 'Komtrax Telematics Included',
      'inspection': 'Engine & Track Undercarriage 85%',
      'supplier': 'Galadari Heavy Equipment',
      'rating': 4.7,
      'phone': '+971 4 417 6000',
    },
  ];

  void _postMachineryDialog() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String cat = 'Excavators';
    String typ = 'FOR_RENT';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Post Heavy Machinery Listing'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Make & Model (e.g. CAT 320D)', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: cat,
                decoration: const InputDecoration(labelText: 'Machine Category', border: OutlineInputBorder()),
                items: ['Excavators', 'Mobile Cranes', 'Tower Cranes', 'Concrete Pumps', 'Bulldozers', 'Generators']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => cat = v!,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: typ,
                decoration: const InputDecoration(labelText: 'Listing Type', border: OutlineInputBorder()),
                items: const [DropdownMenuItem(value: 'FOR_RENT', child: Text('For Rent (ظ„ظ„ط¥ظٹط¬ط§ط±)')), DropdownMenuItem(value: 'FOR_SALE', child: Text('For Sale (ظ„ظ„ط¨ظٹط¹)'))],
                onChanged: (v) => typ = v!,
              ),
              const SizedBox(height: 10),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price in AED (e.g. 1,500 AED / Day)', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                setState(() {
                  _machinery.insert(0, {
                    'title': titleCtrl.text,
                    'category': cat,
                    'type': typ,
                    'price': priceCtrl.text.isEmpty ? 'Contact for Price' : priceCtrl.text,
                    'monthly': 'Negotiable',
                    'location': 'Dubai, UAE',
                    'hours': 'Certified Equipment',
                    'operator': true,
                    'telematics': 'GPS Integrated',
                    'inspection': 'Municipality Inspected',
                    'supplier': 'Contractor Direct',
                    'rating': 5.0,
                    'phone': '+971 50 123 4567',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Machinery listing published on Orion Heavy Equipment Network!')));
              }
            },
            child: const Text('Publish Listing'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _machinery.where((m) {
      final matchesType = _selectedType == 'ALL' || m['type'] == _selectedType;
      final matchesCat = _selectedCategory == 'ALL' || m['category'] == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || (m['title'] as String).toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesType && matchesCat && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Heavy Machinery Marketplace', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('Orion B Heavy Equipment Hub (Dubizzle Style)', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle, color: AppColors.accentCyan), onPressed: _postMachineryDialog),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search & Filter
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search excavators, mobile cranes, boom pumps...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
          const SizedBox(height: 12),

          // Rent / Sale selector
          Row(
            children: [
              ChoiceChip(
                label: const Text('All (ط§ظ„ظƒظ„)'),
                selected: _selectedType == 'ALL',
                onSelected: (_) => setState(() => _selectedType = 'ALL'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('For Rent (ظ„ظ„ط¥ظٹط¬ط§ط±)'),
                selected: _selectedType == 'FOR_RENT',
                onSelected: (_) => setState(() => _selectedType = 'FOR_RENT'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('For Sale (ظ„ظ„ط¨ظٹط¹)'),
                selected: _selectedType == 'FOR_SALE',
                onSelected: (_) => setState(() => _selectedType = 'FOR_SALE'),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Category filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['ALL', 'Excavators', 'Mobile Cranes', 'Tower Cranes', 'Concrete Pumps', 'Bulldozers'].map((c) {
                final isSel = _selectedCategory == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(c, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : null)),
                    selected: isSel,
                    selectedColor: AppColors.primary,
                    onSelected: (_) => setState(() => _selectedCategory = c),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Machinery Cards
          ...filtered.map((m) => Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                            child: Text(m['category'] as String, style: const TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: m['type'] == 'FOR_RENT' ? AppColors.verifiedGreen.withValues(alpha: 0.15) : AppColors.goldEmirates.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(m['type'] as String, style: TextStyle(color: m['type'] == 'FOR_RENT' ? AppColors.verifiedGreen : AppColors.goldEmirates, fontWeight: FontWeight.bold, fontSize: 10)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(m['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 6),
                      Text('${m['price']} â€¢ ${m['monthly']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(m['location'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.speed, size: 14, color: AppColors.accentCyan),
                          const SizedBox(width: 4),
                          Text('${m['hours']} â€¢ Telematics: ${m['telematics']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.verified, size: 14, color: AppColors.verifiedGreen),
                          const SizedBox(width: 4),
                          Expanded(child: Text(m['inspection'] as String, style: const TextStyle(fontSize: 11, color: AppColors.verifiedGreen))),
                        ],
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['supplier'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text('${m['rating']} Star Verified Vendor', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.call, size: 16),
                                label: const Text('Call'),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${m['supplier']} at ${m['phone']}')));
                                },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking request sent for ${m['title']}')));
                                },
                                child: const Text('Book Now'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. CONSTRUCTION OPEN MARKET (SURPLUS & LIQUIDATIONS)
// ---------------------------------------------------------------------------

class OpenMarketScreen extends StatelessWidget {
  const OpenMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listings = [
      {'title': 'Surplus Deformed Steel Rebar 25mm (18 Tons)', 'desc': 'Emirates Steel mill certs available. Stored under cover in JAFZA.', 'price': '1,950 AED / Ton (20% Off)', 'seller': 'Al Habtoor Contracting', 'verified': true},
      {'title': 'Doka Frami Xlife Shuttering Panels & Clamps (400 mآ²)', 'desc': 'Used on single tower project. Good re-usable condition.', 'price': '65,000 AED (Lot)', 'seller': 'Arabtec Liquidation Lot', 'verified': true},
      {'title': 'Schedule 40 Carbon Steel Chilled Water Pipes 6-inch', 'desc': 'Unused surplus 240 meters. Factory epoxy coated.', 'price': '18,500 AED', 'seller': 'Drake & Scull Excess Inventory', 'verified': true},
      {'title': 'Porcelain Floor Tiles 60x60 RAK Ceramics (1,200 mآ²)', 'desc': 'Calacatta White finish, Grade 1 premium.', 'price': '32 AED / mآ²', 'seller': 'Sobha Projects Surplus', 'verified': true},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Construction Open Market (Surplus)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.goldEmirates.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.goldEmirates)),
            child: const Row(
              children: [
                Icon(Icons.inventory_2, color: AppColors.goldEmirates),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Liquidate excess site inventory or purchase certified surplus materials from leading UAE contractors at discounted rates.', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...listings.map((item) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(item['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                          Text(item['price'] as String, style: const TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(item['desc'] as String, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Seller: ${item['seller']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                            icon: const Icon(Icons.chat, size: 14),
                            label: const Text('Inquire', style: TextStyle(fontSize: 11)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contacting ${item['seller']}')));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. CONCRETE TRUCK GPS LIVE RADAR
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// 3. CONCRETE TRUCK GPS LIVE RADAR (1:1 PORT OF GpsMaterialLocatorScreen.kt)
// ---------------------------------------------------------------------------

enum GpsSortMode { nearest, cheapest, topRated }

enum TruckDeliveryStatus {
  enRoute('ظپظٹ ط§ظ„ط·ط±ظٹظ‚ ظ„ظ„ظ…ظˆظ‚ط¹ ًںڑڑ', 'En Route to Site', AppColors.verifiedGreen),
  arrivedOnSite('ظˆطµظ„ ط§ظ„ظ…ظˆظ‚ط¹ - ط¬ط§ظ‡ط² ظ„ظ„طھظپط±ظٹط؛ ًںڑ§', 'On Site - Queueing', AppColors.accentCyan),
  pouring('ط¬ط§ط±ظٹ ط§ظ„طµط¨ ط¨ط§ظ„ظ…ط¶ط®ط© ًںڈ—ï¸ڈ', 'Discharging Concrete', AppColors.goldEmirates),
  completed('طھظ… ط§ظ„طµط¨ ظˆط§ظ„ط§ط¹طھظ…ط§ط¯ âœ…', 'Poured & Inspected', AppColors.verifiedGreen);

  final String titleAr;
  final String titleEn;
  final Color badgeColor;
  const TruckDeliveryStatus(this.titleAr, this.titleEn, this.badgeColor);
}

class ConcreteTransitMixerModel {
  final String id;
  final String plateNumber;
  final String fleetId;
  final String driverName;
  final String driverPhone;
  final String batchPlantName;
  final String concreteGrade;
  final double volumeM3;
  final String departureTime;
  final int etaMinutes;
  final int totalSlumpLifeMinutes;
  final int elapsedMinutes;
  final int speedKmH;
  final double distanceRemainingKm;
  final String currentRoute;
  final TruckDeliveryStatus status;
  final double tempCelsius;
  final int slumpMm;
  final String batchTicketNumber;

  const ConcreteTransitMixerModel({
    required this.id,
    required this.plateNumber,
    required this.fleetId,
    required this.driverName,
    required this.driverPhone,
    required this.batchPlantName,
    required this.concreteGrade,
    required this.volumeM3,
    required this.departureTime,
    required this.etaMinutes,
    this.totalSlumpLifeMinutes = 90,
    required this.elapsedMinutes,
    required this.speedKmH,
    required this.distanceRemainingKm,
    required this.currentRoute,
    required this.status,
    this.tempCelsius = 28.5,
    this.slumpMm = 160,
    this.batchTicketNumber = 'TKT-2026-8914',
  });

  int get remainingSlumpMinutes => (totalSlumpLifeMinutes - elapsedMinutes).clamp(0, totalSlumpLifeMinutes);
}

class GpsLocatorScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const GpsLocatorScreen({super.key, this.onBack});

  @override
  State<GpsLocatorScreen> createState() => _GpsLocatorScreenState();
}

class _GpsLocatorScreenState extends State<GpsLocatorScreen> with SingleTickerProviderStateMixin {
  GpsSortMode _sortMode = GpsSortMode.nearest;
  late AnimationController _pulseController;

  final List<ConcreteTransitMixerModel> _mixers = const [
    ConcreteTransitMixerModel(
      id: 'TM-01',
      plateNumber: 'DXB-77291',
      fleetId: 'Fleet #04',
      driverName: 'Tariq Mahmood',
      driverPhone: '+971 55 982 1104',
      batchPlantName: 'Unibeton Ready Mix (Al Quoz)',
      concreteGrade: 'C40/50 Self-Compacting',
      volumeM3: 9.0,
      departureTime: '13:45',
      etaMinutes: 12,
      elapsedMinutes: 38,
      speedKmH: 48,
      distanceRemainingKm: 4.2,
      currentRoute: 'Sheikh Zayed Rd -> Exit 32',
      status: TruckDeliveryStatus.enRoute,
      tempCelsius: 28.2,
      slumpMm: 165,
    ),
    ConcreteTransitMixerModel(
      id: 'TM-02',
      plateNumber: 'DXB-88302',
      fleetId: 'Fleet #11',
      driverName: 'Suresh Babu',
      driverPhone: '+971 50 412 8899',
      batchPlantName: 'CEMEX UAE (Jebel Ali)',
      concreteGrade: 'C50 Sulphate-Resistant',
      volumeM3: 10.0,
      departureTime: '13:30',
      etaMinutes: 0,
      elapsedMinutes: 55,
      speedKmH: 0,
      distanceRemainingKm: 0.0,
      currentRoute: 'Site Gate 2 â€¢ Queueing at Pump #1',
      status: TruckDeliveryStatus.arrivedOnSite,
      tempCelsius: 29.0,
      slumpMm: 155,
    ),
    ConcreteTransitMixerModel(
      id: 'TM-03',
      plateNumber: 'AUH-44109',
      fleetId: 'Fleet #08',
      driverName: 'Mohamed Rafiq',
      driverPhone: '+971 52 331 4455',
      batchPlantName: 'Readymix Gulf (DIP Plant)',
      concreteGrade: 'C40 Screed Mix',
      volumeM3: 8.5,
      departureTime: '14:10',
      etaMinutes: 28,
      elapsedMinutes: 15,
      speedKmH: 62,
      distanceRemainingKm: 14.8,
      currentRoute: 'E311 Sheikh Mohammed Bin Zayed Rd',
      status: TruckDeliveryStatus.enRoute,
      tempCelsius: 27.8,
      slumpMm: 170,
    ),
  ];

  final List<Map<String, dynamic>> _batchPlants = const [
    {
      'name': 'Unibeton Ready Mix LLC',
      'plant': 'Al Quoz Central Batching Facility',
      'distance': '6.4 km (14 min ETA)',
      'capacity': '360 mآ³/hour',
      'price': '310 AED / mآ³',
      'rating': 4.9,
      'phone': '+971 4 338 8888',
      'approvals': 'RTA â€¢ DEWA â€¢ DM Approved',
    },
    {
      'name': 'CEMEX Supermix UAE',
      'plant': 'Jebel Ali Industrial Plant 2',
      'distance': '12.8 km (22 min ETA)',
      'capacity': '480 mآ³/hour',
      'price': '295 AED / mآ³',
      'rating': 4.8,
      'phone': '+971 4 880 1200',
      'approvals': 'Dubai Municipality Class A',
    },
    {
      'name': 'Readymix Gulf LLC',
      'plant': 'Dubai Investments Park (DIP)',
      'distance': '18.2 km (29 min ETA)',
      'capacity': '320 mآ³/hour',
      'price': '285 AED / mآ³',
      'rating': 4.7,
      'phone': '+971 4 885 3300',
      'approvals': 'Trakhees â€¢ DCD Certified',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _shareTracking(ConcreteTransitMixerModel mixer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('âœ“ Shared Live GPS Radar link for Truck ${mixer.plateNumber} via WhatsApp'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack ?? () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ط±ط§ط¯ط§ط± ط´ط§ط­ظ†ط§طھ ط§ظ„ط®ط±ط³ط§ظ†ط© ظˆط§ظ„ط®ظ„ط·',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(width: 8),
                Text('ًںڑڑ', style: TextStyle(fontSize: 14)),
              ],
            ),
            Text(
              'Live GPS Concrete Truck Radar â€¢ ASTM C94 Slump Timer',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // 1. Interactive Radar Visualizer
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4), width: 1.2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final val = _pulseController.value;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140 * (0.8 + val * 0.4),
                          height: 140 * (0.8 + val * 0.4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentCyan.withValues(alpha: (1 - val) * 0.5),
                              width: 1.5,
                            ),
                          ),
                        ),
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.45)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                // Center Site Pin
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.criticalRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white, size: 16),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Site Hub (Gate 2)',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                // Truck Pins on Radar
                Positioned(
                  top: 35,
                  right: 50,
                  child: _radarTruckPin('DXB-77291', '4.2 km', AppColors.accentCyan),
                ),
                Positioned(
                  bottom: 30,
                  left: 60,
                  child: _radarTruckPin('AUH-44109', '14.8 km', AppColors.goldEmirates),
                ),
                // Top Status Tag
                Positioned(
                  top: 10,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.verifiedGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.verifiedGreen.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.radar, size: 12, color: AppColors.verifiedGreen),
                        SizedBox(width: 4),
                        Text(
                          'RADAR ACTIVE â€¢ 3 TRANSIT MIXERS',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Sort Mode Chips
          Row(
            children: [
              const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Nearest (GPS)'),
                selected: _sortMode == GpsSortMode.nearest,
                onSelected: (val) {
                  if (val) setState(() => _sortMode = GpsSortMode.nearest);
                },
                selectedColor: AppColors.accentCyan,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _sortMode == GpsSortMode.nearest ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              ChoiceChip(
                label: const Text('Top Rated'),
                selected: _sortMode == GpsSortMode.topRated,
                onSelected: (val) {
                  if (val) setState(() => _sortMode = GpsSortMode.topRated);
                },
                selectedColor: AppColors.accentCyan,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _sortMode == GpsSortMode.topRated ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(width: 6),
              ChoiceChip(
                label: const Text('Cheapest'),
                selected: _sortMode == GpsSortMode.cheapest,
                onSelected: (val) {
                  if (val) setState(() => _sortMode = GpsSortMode.cheapest);
                },
                selectedColor: AppColors.accentCyan,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: _sortMode == GpsSortMode.cheapest ? Colors.black : Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3. Live Transit Mixer Cards
          const Text(
            'Live In-Transit Mixers (Real-Time Telematics):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ..._mixers.map((m) => _buildMixerCard(m)),

          const SizedBox(height: 18),

          // 4. Nearby Concrete Batch Plants
          const Text(
            'Approved Batching Plants Nearby (Ready to Dispatch):',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          const SizedBox(height: 8),
          ..._batchPlants.map((p) => _buildPlantCard(p)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _radarTruckPin(String plate, String dist, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const Icon(Icons.local_shipping, size: 12, color: Colors.black),
        ),
        Text(
          '$plate ($dist)',
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildMixerCard(ConcreteTransitMixerModel mixer) {
    final lifePct = (mixer.remainingSlumpMinutes / mixer.totalSlumpLifeMinutes).clamp(0.0, 1.0);
    final isCritical = mixer.remainingSlumpMinutes < 30;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCritical ? AppColors.cautionAmber : AppColors.darkBorder,
          width: isCritical ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: mixer.status.badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.local_shipping, size: 18, color: mixer.status.badgeColor),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${mixer.plateNumber} (${mixer.fleetId})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      ),
                      Text(
                        mixer.batchPlantName,
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: mixer.status.badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  mixer.status.titleAr,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: mixer.status.badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Slump Life Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ظ…ط¤ظ‚طھ ط§ظ„ط´ظƒ ط§ظ„ط£ظ‚طµظ‰ (ASTM C94): ${mixer.remainingSlumpMinutes} ط¯ظ‚ظٹظ‚ط© ظ…طھط¨ظ‚ظٹط©',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isCritical ? AppColors.cautionAmber : AppColors.verifiedGreen,
                ),
              ),
              Text(
                'ETA: ${mixer.etaMinutes} min',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accentCyan),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: lifePct,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(
                isCritical ? AppColors.cautionAmber : AppColors.verifiedGreen,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),

          // Specs Grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Grade: ${mixer.concreteGrade}', style: const TextStyle(fontSize: 11, color: Colors.white70)),
              Text('Volume: ${mixer.volumeM3} mآ³', style: const TextStyle(fontSize: 11, color: Colors.white70)),
              Text('Temp: ${mixer.tempCelsius}آ°C', style: const TextStyle(fontSize: 11, color: AppColors.goldEmirates)),
              Text('Slump: ${mixer.slumpMm} mm', style: const TextStyle(fontSize: 11, color: AppColors.accentCyan)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Route: ${mixer.currentRoute} â€¢ Speed: ${mixer.speedKmH} km/h',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(height: 10),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentCyan,
                    side: const BorderSide(color: AppColors.accentCyan),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  icon: const Icon(Icons.call, size: 14),
                  label: Text('Call Driver (${mixer.driverName})', style: const TextStyle(fontSize: 11)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling driver ${mixer.driverName} at ${mixer.driverPhone}')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Share Live Tracking',
                icon: const Icon(Icons.share, color: AppColors.verifiedGreen, size: 20),
                onPressed: () => _shareTracking(mixer),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCard(Map<String, dynamic> plant) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      plant['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, size: 13, color: AppColors.goldEmirates),
                    Text(
                      '${plant['rating']}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldEmirates),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${plant['plant']} â€¢ ${plant['distance']}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                Text(
                  '${plant['price']} â€¢ ${plant['approvals']}',
                  style: const TextStyle(fontSize: 10, color: AppColors.verifiedGreen),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.directions, color: AppColors.accentCyan),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening Google Maps navigation to ${plant['name']}')),
              );
            },
          ),
        ],
      ),
    );
  }
}


// ---------------------------------------------------------------------------
// 4. QUOTATION COMPARISON SCREEN
// ---------------------------------------------------------------------------

class QuotationComparisonScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const QuotationComparisonScreen({super.key, this.onBack});

  @override
  State<QuotationComparisonScreen> createState() => _QuotationComparisonScreenState();
}

class _QuotationComparisonScreenState extends State<QuotationComparisonScreen> {
  int _selectedRfpIndex = 0;
  bool _awardSuccess = false;

  final List<Map<String, dynamic>> _rfps = [
    {
      'rfpId': 'RFP-2026-881',
      'rfpTitle': 'Crawler Excavator 20-Ton (Qty: 4 Units)',
      'category': 'Heavy Machinery',
      'budget': 1850000.0,
      'currency': 'AED',
      'closingDate': '18 Oct 2026',
      'quotations': [
        {
          'id': 'Q-101',
          'supplierName': 'Al Futtaim Heavy Equipment',
          'supplierCountry': 'UAE',
          'countryFlag': 'ًں‡¦ًں‡ھ',
          'totalPrice': 1780000.0,
          'currency': 'AED',
          'deliveryDays': 7,
          'qualityScore': 95,
          'reliabilityIndex': 94,
          'warranty': '3 Years Comprehensive',
          'paymentTerms': '20% Advance, 80% on Site Receiving',
          'certifications': ['ISO 9001', 'CE Certified', 'RTA Approved'],
          'isAiRecommended': true,
          'recommendationReason': 'Best overall balance of price, 3-year warranty, and 7-day fast delivery in UAE.',
        },
        {
          'id': 'Q-102',
          'supplierName': 'Gulf Machinery Trading LLC',
          'supplierCountry': 'KSA',
          'countryFlag': 'ًں‡¸ًں‡¦',
          'totalPrice': 1690000.0,
          'currency': 'AED',
          'deliveryDays': 14,
          'qualityScore': 88,
          'reliabilityIndex': 86,
          'warranty': '1 Year Standard',
          'paymentTerms': '30% Advance, 70% LC',
          'certifications': ['ISO 9001', 'SASO Certified'],
          'isAiRecommended': false,
          'recommendationReason': 'Lowest price point but longer delivery lead time (14 days) across borders.',
        },
        {
          'id': 'Q-103',
          'supplierName': 'Caterpillar Middle East FZCO',
          'supplierCountry': 'UAE',
          'countryFlag': 'ًں‡¦ًں‡ھ',
          'totalPrice': 1920000.0,
          'currency': 'AED',
          'deliveryDays': 5,
          'qualityScore': 98,
          'reliabilityIndex': 98,
          'warranty': '5 Years Extended',
          'paymentTerms': '10% Advance, 90% Milestone',
          'certifications': ['ISO 9001', 'ISO 14001', 'CE', 'RTA Approved'],
          'isAiRecommended': false,
          'recommendationReason': 'Highest quality & 5-year warranty, but exceeds baseline budget by 3.7%.',
        },
      ],
    },
    {
      'rfpId': 'RFP-2026-904',
      'rfpTitle': 'Ordinary Portland Cement (OPC) - 2,500 Tons',
      'category': 'Bulk Building Materials',
      'budget': 950000.0,
      'currency': 'AED',
      'closingDate': '22 Oct 2026',
      'quotations': [
        {
          'id': 'Q-201',
          'supplierName': 'Emirates Cement Factory (RAK)',
          'supplierCountry': 'UAE',
          'countryFlag': 'ًں‡¦ًں‡ھ',
          'totalPrice': 910000.0,
          'currency': 'AED',
          'deliveryDays': 3,
          'qualityScore': 96,
          'reliabilityIndex': 95,
          'warranty': 'BS EN 197-1 Compliant',
          'paymentTerms': 'Net 30 Days',
          'certifications': ['ESMA Certified', 'ISO 9001', 'Green ICV 92%'],
          'isAiRecommended': true,
          'recommendationReason': 'Local RAK plant ensures 3-day site delivery, ESMA certified, and high Green ICV score.',
        },
        {
          'id': 'Q-202',
          'supplierName': 'Oman Cement Co. SAOG',
          'supplierCountry': 'Oman',
          'countryFlag': 'ًں‡´ًں‡²',
          'totalPrice': 865000.0,
          'currency': 'AED',
          'deliveryDays': 10,
          'qualityScore': 90,
          'reliabilityIndex': 89,
          'warranty': 'Standard Batch QC',
          'paymentTerms': '50% Advance, 50% on Delivery',
          'certifications': ['ISO 9001', 'GCC Conformity'],
          'isAiRecommended': false,
          'recommendationReason': 'Lower unit price, but customs clearance and 10-day transport add project risk.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentRfp = _rfps[_selectedRfpIndex];
    final quotes = (currentRfp['quotations'] as List).cast<Map<String, dynamic>>();

    Map<String, dynamic>? lowestPriceQuote;
    Map<String, dynamic>? bestValueQuote;
    for (final q in quotes) {
      if (lowestPriceQuote == null || (q['totalPrice'] as double) < (lowestPriceQuote['totalPrice'] as double)) {
        lowestPriceQuote = q;
      }
      if (q['isAiRecommended'] == true) {
        bestValueQuote = q;
      }
    }
    bestValueQuote ??= lowestPriceQuote;

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
              'Smart Quotation Comparison',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'AI-Driven Side-by-Side Tender Evaluation',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          // RFP Selector Chips
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Active Tender / RFP',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_rfps.length, (index) {
                    final rfp = _rfps[index];
                    final isSelected = _selectedRfpIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => setState(() {
                          _selectedRfpIndex = index;
                          _awardSuccess = false;
                        }),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.accentCyan.withValues(alpha: 0.18) : AppColors.darkCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppColors.accentCyan : AppColors.darkBorder.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                const Icon(Icons.check, size: 14, color: AppColors.accentCyan),
                                const SizedBox(width: 6),
                              ],
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    rfp['rfpId'] as String,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: isSelected ? AppColors.accentCyan : Colors.white,
                                    ),
                                  ),
                                  Text(
                                    rfp['rfpTitle'] as String,
                                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tender Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentRfp['rfpId'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.accentCyan),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        currentRfp['category'] as String,
                        style: const TextStyle(color: AppColors.accentCyan, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  currentRfp['rfpTitle'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Divider(color: AppColors.darkBorder.withValues(alpha: 0.3), height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Allocated Budget', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 2),
                        Text(
                          '${(currentRfp['budget'] as double).toStringAsFixed(0)} ${currentRfp['currency']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Bid Submissions', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        const SizedBox(height: 2),
                        Text(
                          '${quotes.length} Verified Quotations',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.verifiedGreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // AI Smart Recommendations Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.accentCyan, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Orion B AI Tender Intelligence Insights',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.accentCyan),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (bestValueQuote != null)
                  Row(
                    children: [
                      // Best Value Card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.darkCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ًںڈ† Best Value Choice',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentCyan),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                bestValueQuote['supplierName'] as String,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${(bestValueQuote['totalPrice'] as double).toStringAsFixed(0)} ${bestValueQuote['currency']}',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.verifiedGreen),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Lowest Price Card
                      if (lowestPriceQuote != null)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.darkCard,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ًںڈ·ï¸ڈ Lowest Price',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  lowestPriceQuote['supplierName'] as String,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${(lowestPriceQuote['totalPrice'] as double).toStringAsFixed(0)} ${lowestPriceQuote['currency']}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                if (bestValueQuote != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'ًں’، AI Recommendation: ${bestValueQuote['recommendationReason']}',
                    style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quotation List Header
          const Text(
            'Side-by-Side Supplier Quotation Matrix',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),

          // Quotation Cards
          ...quotes.map((quote) => _buildQuotationCard(quote)),
        ],
      ),
    );
  }

  Widget _buildQuotationCard(Map<String, dynamic> quote) {
    final isAi = quote['isAiRecommended'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isAi ? AppColors.accentCyan.withValues(alpha: 0.08) : AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAi ? AppColors.accentCyan : AppColors.darkBorder.withValues(alpha: 0.5),
          width: isAi ? 1.8 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Banner
          if (isAi)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.18),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 14, color: AppColors.accentCyan),
                      SizedBox(width: 6),
                      Text(
                        'AI Recommended Choice',
                        style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ],
                  ),
                  Text(
                    'BEST VALUE',
                    style: TextStyle(color: AppColors.accentCyan, fontWeight: FontWeight.w900, fontSize: 10),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Icon + Supplier Name + Country
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.accentCyan.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.business, color: AppColors.accentCyan, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quote['supplierName'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                '${quote['countryFlag']} ${quote['supplierCountry']}',
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'â€¢ Reliability: ${quote['reliabilityIndex']}/100',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Divider(color: AppColors.darkBorder.withValues(alpha: 0.4), height: 1),
                const SizedBox(height: 12),

                // Key Metrics Grid (3 Boxes)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Price', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              '${(quote['totalPrice'] as double).toStringAsFixed(0)} ${quote['currency']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery Time', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              '${quote['deliveryDays']} Days',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quality Score', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                            const SizedBox(height: 2),
                            Text(
                              '${quote['qualityScore']}%',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.verifiedGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Warranty & Payment Terms
                Text(
                  'ًں›،ï¸ڈ Warranty: ${quote['warranty']}',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  'ًں’³ Terms: ${quote['paymentTerms']}',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),

                const SizedBox(height: 8),

                // Certifications Chips
                Row(
                  children: [
                    Text('Certs: ', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 4,
                      children: (quote['certifications'] as List<String>).map((cert) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(cert, style: const TextStyle(fontSize: 9, color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isAi ? AppColors.accentCyan : AppColors.darkSurface,
                      foregroundColor: isAi ? Colors.black : Colors.white,
                      side: isAi ? null : const BorderSide(color: AppColors.accentCyan),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                    ),
                    onPressed: () {
                      _showAwardTenderDialog(quote);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 16, color: isAi ? Colors.black : AppColors.accentCyan),
                        const SizedBox(width: 8),
                        Text(
                          'Select & Award Contract to ${quote['supplierName']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAwardTenderDialog(Map<String, dynamic> quote) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.darkCard,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: const Row(
              children: [
                Icon(Icons.verified, color: AppColors.verifiedGreen, size: 22),
                SizedBox(width: 8),
                Text('Confirm Contract Award', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_awardSuccess) ...[
                  const Text(
                    'ًںژ‰ Contract successfully awarded!',
                    style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Purchase Order #PO-2026-994 has been generated and dispatched to ${quote['supplierName']} ERP & Escrow account.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ] else ...[
                  Text(
                    'You are about to award this tender to:',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'â€¢ Supplier: ${quote['supplierName']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
                  ),
                  Text(
                    'â€¢ Amount: ${(quote['totalPrice'] as double).toStringAsFixed(0)} ${quote['currency']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan, fontSize: 13),
                  ),
                  Text(
                    'â€¢ Delivery Terms: ${quote['deliveryDays']} Days | Warranty: ${quote['warranty']}',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This action will notify the finance department to lock escrow funds and issue the formal Letter of Award (LOA).',
                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
            actions: [
              if (!_awardSuccess)
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.verifiedGreen, foregroundColor: Colors.black),
                onPressed: () {
                  if (_awardSuccess) {
                    Navigator.pop(ctx);
                  } else {
                    setDialogState(() {
                      _awardSuccess = true;
                    });
                    setState(() {
                      _awardSuccess = true;
                    });
                  }
                },
                child: Text(_awardSuccess ? 'Done' : 'Confirm Award & Lock Escrow'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// 5. SUPPLIERS DIRECTORY SCREEN (1:1 PARITY WITH SuppliersCompaniesDirectoryScreen.kt)
// ---------------------------------------------------------------------------

class SuppliersDirectoryScreen extends StatefulWidget {
  const SuppliersDirectoryScreen({super.key});

  @override
  State<SuppliersDirectoryScreen> createState() => _SuppliersDirectoryScreenState();
}

class _SuppliersDirectoryScreenState extends State<SuppliersDirectoryScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  final TextEditingController _searchCtrl = TextEditingController();

  final List<Map<String, dynamic>> _suppliers = [
    {
      'id': 'SUP-001',
      'nameAr': 'ط´ط±ظƒط© ط§ظ„ط¥ظ…ط§ط±ط§طھ ظ„ظ„ط­ط¯ظٹط¯ ظˆط§ظ„طµظ„ط¨ (ط£ط±ظƒط§ظ†)',
      'nameEn': 'Emirates Steel Arkan PJSC',
      'category': 'Steel & Rebar',
      'catKey': 'Steel',
      'rating': 4.9,
      'reviews': 248,
      'region': 'Abu Dhabi - ICAD 1',
      'address': 'Industrial City Abu Dhabi, Plot 14-B',
      'certs': 'ISO 9001:2015 â€¢ DM Certified â€¢ UK CARES',
      'priceRangeAed': '2,420 - 2,510 AED / Ton',
      'contactPhone': '+971 2 555 8888',
      'verified': true,
    },
    {
      'id': 'SUP-002',
      'nameAr': 'ظٹظˆظ†ظٹط¨طھظˆظ† ظ„ظ„ط®ط±ط³ط§ظ†ط© ط§ظ„ط¬ط§ظ‡ط²ط© ط°.ظ….ظ…',
      'nameEn': 'Unibeton Ready Mix LLC',
      'category': 'Ready-Mix Concrete',
      'catKey': 'Concrete',
      'rating': 4.9,
      'reviews': 312,
      'region': 'Dubai - Al Quoz Industrial 3',
      'address': 'Plot 369-142, Latifa Bint Hamdan St',
      'certs': 'RTA Approved â€¢ DEWA Accredited â€¢ Green Concrete DCL',
      'priceRangeAed': '225 - 260 AED / mآ³',
      'contactPhone': '+971 4 338 8888',
      'verified': true,
    },
    {
      'id': 'SUP-003',
      'nameAr': 'ط³ظٹظ…ظƒط³ ط§ظ„ط®ظ„ظٹط¬ ظ„ظ„ط®ط±ط³ط§ظ†ط© ظˆط§ظ„ط¥ط³ظپظ„طھ',
      'nameEn': 'CEMEX Supermix UAE',
      'category': 'Asphalt & Roads',
      'catKey': 'Asphalt',
      'rating': 4.8,
      'reviews': 185,
      'region': 'Dubai - Jebel Ali Industrial 1',
      'address': 'Roundabout 8, JAFZA North Access',
      'certs': 'Dubai Municipality Grade A â€¢ RTA Asphalt Spec 2024',
      'priceRangeAed': '170 - 195 AED / Ton',
      'contactPhone': '+971 4 880 1234',
      'verified': true,
    },
    {
      'id': 'SUP-004',
      'nameAr': 'ط¯ظˆظƒط§ ط§ظ„ط®ظ„ظٹط¬ ظ„ط£ظ†ط¸ظ…ط© ط§ظ„ط´ط¯ط§طھ ظˆط§ظ„ط³ظ‚ط§ظ„ط§طھ',
      'nameEn': 'Doka Gulf FZE',
      'category': 'Fasteners & Formwork',
      'catKey': 'Fasteners',
      'rating': 4.8,
      'reviews': 142,
      'region': 'Dubai - JAFZA South',
      'address': 'Jebel Ali Free Zone, FZS2 AB05',
      'certs': 'EN 1065 / EN 13374 Compliant â€¢ Trakhees Class 1',
      'priceRangeAed': '85 - 130 AED / mآ² Rental',
      'contactPhone': '+971 4 870 8700',
      'verified': true,
    },
    {
      'id': 'SUP-005',
      'nameAr': 'ظƒظٹظ…ط§ظˆظٹط§طھ ط§ظ„ط¨ظ†ط§ط، ط³ظٹظƒط§ ط§ظ„ط´ط±ظ‚ ط§ظ„ط£ظˆط³ط·',
      'nameEn': 'Sika Middle East LLC',
      'category': 'Chemicals & Waterproofing',
      'catKey': 'Chemicals',
      'rating': 4.9,
      'reviews': 198,
      'region': 'Dubai - Dubai Investment Park (DIP 1)',
      'address': 'Plot 598-1123, Street 44',
      'certs': 'ASTM C494 / C260 â€¢ DM Green Building Regulations',
      'priceRangeAed': '45 - 95 AED / Drum / mآ²',
      'contactPhone': '+971 4 812 3700',
      'verified': true,
    },
    {
      'id': 'SUP-006',
      'nameAr': 'ط¯ط§ظ†ظپظˆط³ ط§ظ„ط´ط±ظ‚ ط§ظ„ط£ظˆط³ط· ظ„ظ„طھط¬ظ‡ظٹط²ط§طھ ط§ظ„ظƒظ‡ط±ظˆظ…ظٹظƒط§ظ†ظٹظƒظٹط©',
      'nameEn': 'Danfoss Middle East FZE',
      'category': 'MEP & Valves',
      'catKey': 'Fasteners',
      'rating': 4.7,
      'reviews': 96,
      'region': 'Dubai - Dubai Science Park',
      'address': 'HQ Building, Tower B, Level 8',
      'certs': 'DEWA Certified â€¢ ASHRAE 90.1 â€¢ AHRI Compliant',
      'priceRangeAed': '350 - 4,800 AED / Unit',
      'contactPhone': '+971 4 456 1200',
      'verified': true,
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showAiMatchDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.accentCyan, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'AI Supplier Matchmaker',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B192C),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accentCyan.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.insights, color: AppColors.accentCyan, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Project: Downtown Dubai Luxury Tower (PRJ-2026-001)',
                        style: TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Top 3 Approved UAE Suppliers matched with project structural specs & Dubai Municipality codes:',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 10),
              _buildAiRecRow('1. Emirates Steel Arkan PJSC', '99% Match â€¢ High-Yield B500B Rebar â€¢ 2,420 AED/Ton', AppColors.verifiedGreen),
              const SizedBox(height: 8),
              _buildAiRecRow('2. Unibeton Ready Mix LLC', '98% Match â€¢ C40/50 Self-Compacting â€¢ 235 AED/mآ³', AppColors.accentCyan),
              const SizedBox(height: 8),
              _buildAiRecRow('3. Sika Middle East LLC', '96% Match â€¢ SikaBit Pro Sub-Structure Waterproofing', AppColors.goldEmirates),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: const Color(0xFF0B192C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.send, size: 14),
            label: const Text('Issue Instant RFQ to All 3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.verifiedGreen,
                  content: Text('Auto-RFQ dispatched to Emirates Steel, Unibeton, and Sika!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAiRecRow(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }

  void _showRfqDialog(Map<String, dynamic> supplier) {
    final qtyCtrl = TextEditingController(text: '500');
    final noteCtrl = TextEditingController(text: 'Urgent delivery to Downtown Dubai Site Gate 4');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: AppColors.accentCyan, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Request Quotation (RFQ) - ${supplier['nameEn']}',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price Range: ${supplier['priceRangeAed']}', style: const TextStyle(color: AppColors.accentCyan, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Estimated Quantity Required',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              maxLines: 2,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Delivery Site / Notes',
                labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: const Color(0xFF0B192C),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.verifiedGreen,
                  content: Text('RFQ successfully transmitted to ${supplier['nameEn']} procurement team.'),
                ),
              );
            },
            child: const Text('Send RFQ Now', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _suppliers.where((s) {
      final matchesCat = _selectedCategory == null || s['catKey'] == _selectedCategory;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          (s['nameEn'] as String).toLowerCase().contains(q) ||
          (s['nameAr'] as String).toLowerCase().contains(q) ||
          (s['category'] as String).toLowerCase().contains(q) ||
          (s['region'] as String).toLowerCase().contains(q) ||
          (s['certs'] as String).toLowerCase().contains(q);
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        title: const Text('Verified Materials Suppliers & Vendors'),
        backgroundColor: const Color(0xFF0F172A),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: AppColors.accentCyan),
            tooltip: 'AI Match',
            onPressed: _showAiMatchDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          // Top Header Container
          Container(
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.verified, color: AppColors.accentCyan, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Approved Vendors & Suppliers Directory',
                              style: TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ط¯ظ„ظٹظ„ ط§ظ„ظ…ظˆط±ط¯ظٹظ† ظˆط´ط±ظƒط§طھ ظ…ظˆط§ط¯ ط§ظ„ط¨ظ†ط§ط، ط§ظ„ظ…ط¹طھظ…ط¯ط©',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentCyan,
                        foregroundColor: const Color(0xFF0B192C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      icon: const Icon(Icons.auto_awesome, size: 14),
                      label: const Text('AI Match', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      onPressed: _showAiMatchDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Live Price Index Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1B30),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accentCyan.withOpacity(0.2)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ظ…ط¤ط´ط± ط£ط³ط¹ط§ط± ط§ظ„ظ…ظˆط§ط¯ ط§ظ„ظ…ط¨ط§ط´ط± ظپظٹ ط§ظ„ط¥ظ…ط§ط±ط§طھ (Live Price Index):',
                        style: TextStyle(color: AppColors.accentCyan, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'ط­ط¯ظٹط¯ ط§ظ„طھط³ظ„ظٹط­: 2,480 AED/ط·ظ† â€¢ ط§ظ„ط®ط±ط³ط§ظ†ط© C40: 235 AED/ظ…آ³ â€¢ ط§ظ„ط¥ط³ظپظ„طھ: 178 AED/ط·ظ†',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Search Bar
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search company, material, ISO, region...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: const Icon(Icons.search, color: AppColors.accentCyan, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accentCyan)),
                  ),
                ),
              ],
            ),
          ),

          // Categories Filter Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                _buildFilterChip('All Vendors (ط§ظ„ظƒظ„)', null),
                _buildFilterChip('Steel & Rebar (ط­ط¯ظٹط¯)', 'Steel'),
                _buildFilterChip('Ready-Mix (ط®ط±ط³ط§ظ†ط©)', 'Concrete'),
                _buildFilterChip('Asphalt & Roads (ط¥ط³ظپظ„طھ)', 'Asphalt'),
                _buildFilterChip('Fasteners & Formwork (ط´ط¯ط§طھ)', 'Fasteners'),
                _buildFilterChip('Chemicals (ط¹ظˆط§ط²ظ„)', 'Chemicals'),
              ],
            ),
          ),

          // Suppliers List Cards
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text('No suppliers matched your search query', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...filtered.map((s) => _buildSupplierCard(s)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? catKey) {
    final isSelected = _selectedCategory == catKey;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selectedColor: AppColors.accentCyan,
        backgroundColor: const Color(0xFF1E293B),
        labelStyle: TextStyle(color: isSelected ? const Color(0xFF0B192C) : Colors.white70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (val) => setState(() => _selectedCategory = val ? catKey : null),
      ),
    );
  }

  Widget _buildSupplierCard(Map<String, dynamic> supplier) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151F32),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.verifiedGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified, color: AppColors.verifiedGreen, size: 11),
                        SizedBox(width: 3),
                        Text('ظ…ظˆط±ط¯ ظ…ط¹طھظ…ط¯', style: TextStyle(color: AppColors.verifiedGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      supplier['category'] as String,
                      style: const TextStyle(color: AppColors.accentCyan, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.goldEmirates, size: 13),
                  const SizedBox(width: 3),
                  Text(
                    '${supplier['rating']} (${supplier['reviews']})',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Titles
          Text(
            supplier['nameEn'] as String,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            supplier['nameAr'] as String,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 6),

          // Address & Region
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.accentCyan, size: 12),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${supplier['region']} â€¢ ${supplier['address']}',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Certifications
          Text(
            'ًں“œ ${supplier['certs']}',
            style: const TextStyle(color: AppColors.goldEmirates, fontSize: 10, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),

          // Price & Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price Index / ظ…ط¤ط´ط± ط§ظ„ط³ط¹ط±', style: TextStyle(color: Colors.grey, fontSize: 9)),
                  Text(
                    supplier['priceRangeAed'] as String,
                    style: const TextStyle(color: AppColors.accentCyan, fontSize: 12, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentCyan,
                      side: const BorderSide(color: AppColors.accentCyan),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.call, size: 13),
                    label: const Text('Call', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${supplier['nameEn']} at ${supplier['contactPhone']}')),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      foregroundColor: const Color(0xFF0B192C),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.receipt_long, size: 13),
                    label: const Text('RFQ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () => _showRfqDialog(supplier),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. GCC TENDERS AI SCREEN (1:1 PARITY WITH GccTendersAiScreen.kt)
// ---------------------------------------------------------------------------

class GccTendersScreen extends StatefulWidget {
  const GccTendersScreen({super.key});

  @override
  State<GccTendersScreen> createState() => _GccTendersScreenState();
}

class _GccTendersScreenState extends State<GccTendersScreen> {
  String _searchQuery = '';
  String? _selectedTypeFilter;
  final TextEditingController _searchCtrl = TextEditingController();

  final List<Map<String, dynamic>> _tenders = [
    {
      'tenderNo': 'RTA-2026-T881',
      'titleEn': 'Corridor Expansion & Road Widening R-1082 Package',
      'titleAr': 'طھظˆط³ظٹط¹ ظˆطھط·ظˆظٹط± ظ…ط³ط§ط± ط§ظ„ط¨ظ†ظٹط© ط§ظ„طھط­طھظٹط© ظ„ط­ط²ظ…ط© ط§ظ„ط·ط±ظ‚ R-1082',
      'authorityEn': 'Roads & Transport Authority (RTA Dubai)',
      'authorityAr': 'ظ‡ظٹط¦ط© ط§ظ„ط·ط±ظ‚ ظˆط§ظ„ظ…ظˆط§طµظ„ط§طھ - ط¯ط¨ظٹ',
      'type': 'SUBCONTRACTING',
      'typeLabel': 'Subcontracting',
      'budgetAed': 14500000.0,
      'deadlineDays': 18,
      'locationEn': 'Dubai - Sheikh Mohammed Bin Zayed Road',
      'locationAr': 'ط¯ط¨ظٹ - ط´ط§ط±ط¹ ط§ظ„ط´ظٹط® ظ…ط­ظ…ط¯ ط¨ظ† ط²ط§ظٹط¯',
      'categoryEn': 'Highway Engineering & Asphalt Works',
      'categoryAr': 'ط£ط¹ظ…ط§ظ„ ط§ظ„ط·ط±ظ‚ ظˆط§ظ„ط¬ط³ظˆط± ظˆط§ظ„ط£ط³ظپظ„طھ',
      'scopeEn': 'Full depth reclamation, utility relocation, asphalt laying, and storm drainage network along 8.4 km corridor.',
      'scopeAr': 'ط¥ط¹ط§ط¯ط© طھط£ظ‡ظٹظ„ ط·ط¨ظ‚ط§طھ ط§ظ„ط£ط³ط§ط³ ظˆظ†ظ‚ظ„ ط®ط·ظˆط· ط§ظ„ط®ط¯ظ…ط§طھ ظˆظ…ط¯ ط§ظ„ط£ط³ظپظ„طھ ظˆط¥ظ†ط´ط§ط، ط´ط¨ظƒط© طھطµط±ظٹظپ ظ…ظٹط§ظ‡ ط§ظ„ط£ظ…ط·ط§ط± ط¨ط·ظˆظ„ 8.4 ظƒظ….',
      'feasibilityScore': 94,
      'targetMargin': '11.5%',
      'competition': 'Moderate',
      'standards': ['RTA Road Design Standards 2024', 'Dubai Municipality DCL Specification 104', 'FIDIC Red Book 2017 EPC'],
    },
    {
      'tenderNo': 'DEWA-2026-S440',
      'titleEn': 'Construction of 132/11 kV Substation at MBR Solar Park',
      'titleAr': 'ط¥ظ†ط´ط§ط، ظ…ط­ط·ط© طھط­ظˆظٹظ„ ط±ط¦ظٹط³ظٹط© 132/11 ظƒ.ظپ ظپظٹ ظ…ط¬ظ…ط¹ ظ…ط­ظ…ط¯ ط¨ظ† ط±ط§ط´ط¯ ظ„ظ„ط·ط§ظ‚ط© ط§ظ„ط´ظ…ط³ظٹط©',
      'authorityEn': 'Dubai Electricity & Water Authority (DEWA)',
      'authorityAr': 'ظ‡ظٹط¦ط© ظƒظ‡ط±ط¨ط§ط، ظˆظ…ظٹط§ظ‡ ط¯ط¨ظٹ (ط¯ظٹظˆط§)',
      'type': 'SUBCONTRACTING',
      'typeLabel': 'Subcontracting',
      'budgetAed': 38200000.0,
      'deadlineDays': 24,
      'locationEn': 'Dubai - Seih Al Dahal, MBR Solar Park Phase V',
      'locationAr': 'ط¯ط¨ظٹ - ط³ظٹط­ ط§ظ„ط¯ط­ظ„طŒ ظ…ط¬ظ…ط¹ ظ…ط­ظ…ط¯ ط¨ظ† ط±ط§ط´ط¯ ظ„ظ„ط·ط§ظ‚ط©',
      'categoryEn': 'Substation Electrical & Civil EPC Package',
      'categoryAr': 'ط£ط¹ظ…ط§ظ„ ظ…ط¯ظ†ظٹط© ظˆظƒظ‡ط±ط¨ط§ط¦ظٹط© ظ…طھظƒط§ظ…ظ„ط© ظ„ظ„ظ…ط­ط·ط§طھ',
      'scopeEn': 'Civil building erection, gas-insulated switchgear (GIS) bay foundations, transformer blast walls, and SCADA cabling.',
      'scopeAr': 'طھط´ظٹظٹط¯ ط§ظ„ظ…ط¨ظ†ظ‰ ط§ظ„ط¥ظ†ط´ط§ط¦ظٹ ظ„ظ„ظ…ط­ط·ط© ظˆظ‚ظˆط§ط¹ط¯ ط§ظ„ظ‚ظˆط§ط·ط¹ ط§ظ„ظ…ط¹ط²ظˆظ„ط© ط¨ط§ظ„ط؛ط§ط² ظˆط¬ط¯ط±ط§ظ† ط§ظ„ط­ظ…ط§ظٹط© ظ„ظ„ظ…ط­ظˆظ„ط§طھ ظˆط´ط¨ظƒط© ط§ظ„ظ…ط±ط§ظ‚ط¨ط© ظˆط§ظ„طھط­ظƒظ….',
      'feasibilityScore': 89,
      'targetMargin': '13.2%',
      'competition': 'High',
      'standards': ['DEWA Substation Civil Specs Rev 7', 'IEC 62271-203 Standards', 'Dubai Civil Defence NFPA 850'],
    },
    {
      'tenderNo': 'ALDAR-2026-EPC12',
      'titleEn': 'Yas Island Luxury Waterfront Residences Concrete Package',
      'titleAr': 'ط­ط²ظ…ط© ط§ظ„ط®ط±ط³ط§ظ†ط© ط§ظ„ظ…ط³ظ„ط­ط© ظˆط§ظ„ظ‡ظٹظƒظ„ ط§ظ„ط¥ظ†ط´ط§ط¦ظٹ ظ„ظ…ط´ط±ظˆط¹ ط£ط¨ط±ط§ط¬ ط¬ط²ظٹط±ط© ظٹط§ط³ ط§ظ„ظپط§ط®ط±ط©',
      'authorityEn': 'Aldar Properties PJSC',
      'authorityAr': 'ط´ط±ظƒط© ط§ظ„ط¯ط§ط± ط§ظ„ط¹ظ‚ط§ط±ظٹط© ط´.ظ….ط¹',
      'type': 'MATERIAL_SUPPLY',
      'typeLabel': 'Material Supply',
      'budgetAed': 27800000.0,
      'deadlineDays': 6,
      'locationEn': 'Abu Dhabi - Yas Island North Bay',
      'locationAr': 'ط£ط¨ظˆط¸ط¨ظٹ - ط¬ط²ظٹط±ط© ظٹط§ط³طŒ ط§ظ„ظˆط§ط¬ظ‡ط© ط§ظ„ط´ظ…ط§ظ„ظٹط©',
      'categoryEn': 'High-Strength Concrete & Post-Tensioning',
      'categoryAr': 'ط®ط±ط³ط§ظ†ط© ط¹ط§ظ„ظٹط© ط§ظ„ظ…ظ‚ط§ظˆظ…ط© ظˆط£ظ†ط¸ظ…ط© ط§ظ„ط´ط¯ ط§ظ„ظ„ط§ط­ظ‚',
      'scopeEn': 'Supply of 65,000 mآ³ C60/75 micro-silica concrete, sulphate resisting cement foundations, and post-tension strand bundles.',
      'scopeAr': 'طھظˆط±ظٹط¯ 65,000 ظ…آ³ ط®ط±ط³ط§ظ†ط© ظ…ظ‚ط§ظˆظ…ط© ظ„ظ„ط£ظ…ظ„ط§ط­ C60/75 ظˆظƒط§ط¨ظ„ط§طھ ط§ظ„ط´ط¯ ط§ظ„ظ„ط§ط­ظ‚ ظ„ظ„ط£ط³ظ‚ظپ ظ…ط¹ ط§ظ„ظپط­طµ ط§ظ„ظ…ط®ط¨ط±ظٹ ط§ظ„ظ…ط³طھظ…ط±.',
      'feasibilityScore': 96,
      'targetMargin': '10.8%',
      'competition': 'Low (Niche)',
      'standards': ['Abu Dhabi Municipality Estidama 2-Pearl', 'BS 8500 / BS 8110 Structural Codes', 'ASTM C1240 Micro-Silica'],
    },
    {
      'tenderNo': 'TRAK-2026-EQ901',
      'titleEn': 'Heavy Earthmoving Fleet Rental for Logistics Port Terminal',
      'titleAr': 'ط¹ظ‚ط¯ طھط£ط¬ظٹط± ط£ط³ط·ظˆظ„ ظ…ط¹ط¯ط§طھ ط§ظ„ط­ظپط± ط§ظ„ط«ظ‚ظٹظ„ط© ظ„ظ„ظ…ظٹظ†ط§ط، ط§ظ„ظ„ظˆط¬ط³طھظٹ',
      'authorityEn': 'DP World & Trakhees Authorities',
      'authorityAr': 'ظ…ظˆط§ظ†ط¦ ط¯ط¨ظٹ ط§ظ„ط¹ط§ظ„ظ…ظٹط© ظˆط¯ط§ط¦ط±ط© طھط±ط§ط®ظٹطµ',
      'type': 'EQUIPMENT_RENTAL',
      'typeLabel': 'Equipment Rental',
      'budgetAed': 6400000.0,
      'deadlineDays': 31,
      'locationEn': 'Dubai - JAFZA South Container Terminal 4',
      'locationAr': 'ط¯ط¨ظٹ - ط§ظ„ظ…ظ†ط·ظ‚ط© ط§ظ„ط­ط±ط© ظ„ط¬ط¨ظ„ ط¹ظ„ظٹطŒ ظ…ط­ط·ط© ط§ظ„ط­ط§ظˆظٹط§طھ 4',
      'categoryEn': 'Excavators, Dozers & Articulated Dump Trucks',
      'categoryAr': 'ط­ظپط§ط±ط§طھ ظˆط¬ط±ط§ظپط§طھ ظˆط´ط§ط­ظ†ط§طھ ظ‚ظ„ط§ط¨ ظ…ظپطµظ„ظٹط©',
      'scopeEn': 'Long-term 12-month dry and wet lease of 16 CAT 349 excavators and Komatsu D155 dozers with certified operators.',
      'scopeAr': 'طھط£ط¬ظٹط± ط·ظˆظٹظ„ ط§ظ„ط£ط¬ظ„ ظ„ظ…ط¯ط© 12 ط´ظ‡ط±ط§ظ‹ ظ„ط¹ط¯ط¯ 16 ط­ظپط§ط±ط© ظƒط§طھط±ط¨ظٹظ„ط± 349 ظˆط¬ط±ط§ظپط§طھ ظƒظˆظ…ط§طھط³ظˆ ظ…ط¹ ظ…ط´ط؛ظ„ظٹظ† ظ…ط¹طھظ…ط¯ظٹظ† ظ…ظ† طھط±ط§ط®ظٹطµ.',
      'feasibilityScore': 91,
      'targetMargin': '16.0%',
      'competition': 'Moderate',
      'standards': ['Trakhees EHS Safety Regulations', 'UAE Federal Traffic Fleet Licensing', 'ISO 45001 Occupational Safety'],
    },
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showAiFeasibilityBottomSheet(Map<String, dynamic> tender) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.78,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollCtrl) {
            final standards = tender['standards'] as List<String>;
            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: AppColors.accentCyan, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Gemini AI Tender Feasibility Analysis',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  tender['titleEn'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  '${tender['tenderNo']} â€¢ ${tender['authorityEn']}',
                  style: const TextStyle(color: AppColors.accentCyan, fontSize: 11),
                ),
                const SizedBox(height: 14),

                // KPI Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accentCyan.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Feasibility Score', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 2),
                          Text('${tender['feasibilityScore']}%', style: const TextStyle(color: AppColors.verifiedGreen, fontSize: 16, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Target Margin', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 2),
                          Text('${tender['targetMargin']}', style: const TextStyle(color: AppColors.accentCyan, fontSize: 16, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Competition', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 2),
                          Text('${tender['competition']}', style: const TextStyle(color: AppColors.goldEmirates, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Grounded Intelligence Report
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF081220),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accentCyan.withOpacity(0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Contractual & Commercial Feasibility Summary:',
                        style: TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '1. Qualification Fit: Contractor license Class 1 meets all mandatory tender prerequisites for ${tender['authorityEn']}.\n'
                        '2. Cashflow & Bonding: 5% initial bid bond required (${NumberFormat('#,###').format((tender['budgetAed'] as double) * 0.05)} AED). Bank facility coverage is adequate.\n'
                        '3. Material Pricing: High synergy with existing concrete and rebar contracts in the corridor, reducing overhead by ~4.2%.\n'
                        '4. Milestone Risk: Liquidated damages capped at 10% under FIDIC 2017 conditions.',
                        style: const TextStyle(color: Colors.white, fontSize: 11, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Grounded Standards
                const Text(
                  'Grounded Standards & Regulatory References:',
                  style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                ...standards.map((st) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text('â€¢ $st', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                    )),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentCyan,
                    foregroundColor: const Color(0xFF0B192C),
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.send, size: 16),
                  label: const Text('Submit Technical & Financial Bid', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showBidSubmissionDialog(tender);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBidSubmissionDialog(Map<String, dynamic> tender) {
    final defaultBid = ((tender['budgetAed'] as double) * 0.94).round();
    final bidCtrl = TextEditingController(text: NumberFormat('#,###').format(defaultBid));
    final durationCtrl = TextEditingController(text: '180');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.assignment, color: AppColors.accentCyan, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Submit Bid Proposal',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tender['titleEn'] as String,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Tender Budget: ${NumberFormat('#,###').format(tender['budgetAed'])} AED',
                style: const TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: bidCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'Proposed Bid Amount (AED)',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'Execution Duration (Days)',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Company trade profile, pre-qualification certificates & 5% automated bank guarantee bond will be officially attached to the submission ledger.',
                  style: TextStyle(color: Colors.grey, fontSize: 10, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: const Color(0xFF0B192C),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _showBidSuccessDialog(tender);
            },
            child: const Text('Submit Bid Officially', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showBidSuccessDialog(Map<String, dynamic> tender) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.verifiedGreen, size: 22),
            SizedBox(width: 8),
            Text(
              'Bid Submitted Successfully!',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Your technical & financial bid for ${tender['tenderNo']} has been logged with immutable timestamp in the GCC procurement ledger.',
          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCyan,
              foregroundColor: const Color(0xFF0B192C),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _tenders.where((t) {
      final matchesType = _selectedTypeFilter == null || t['type'] == _selectedTypeFilter;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          (t['titleEn'] as String).toLowerCase().contains(q) ||
          (t['titleAr'] as String).toLowerCase().contains(q) ||
          (t['authorityEn'] as String).toLowerCase().contains(q) ||
          (t['tenderNo'] as String).toLowerCase().contains(q) ||
          (t['scopeEn'] as String).toLowerCase().contains(q);
      return matchesType && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B111E),
      appBar: AppBar(
        title: const Text('GCC Government Tenders & AI Bidding'),
        backgroundColor: const Color(0xFF0F172A),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          // Header section
          Container(
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: AppColors.accentCyan, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'GCC Tenders & AI Bidding Intelligence',
                              style: TextStyle(color: AppColors.accentCyan, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ط¨ظˆط§ط¨ط© ط§ظ„ظ…ظ†ط§ظ‚طµط§طھ ط§ظ„ط­ظƒظˆظ…ظٹط© ظˆط§ظ„ط°ظƒط§ط، ط§ظ„ط§طµط·ظ†ط§ط¹ظٹ',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldEmirates.withOpacity(0.15),
                        border: Border.all(color: AppColors.goldEmirates.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'GCC LIVE',
                        style: TextStyle(color: AppColors.goldEmirates, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // AI Tenders Overview Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C192E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accentCyan.withOpacity(0.35)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.gavel, color: AppColors.accentCyan, size: 22),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Live tracking of tenders from GCC Municipalities & Authorities',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'AI RFP breakdown â€¢ Bid feasibility & margin calculation â€¢ License eligibility',
                              style: TextStyle(color: Colors.grey, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Search Bar
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search tender no, authority, scope...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                    prefixIcon: const Icon(Icons.search, color: AppColors.accentCyan, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.accentCyan)),
                  ),
                ),
              ],
            ),
          ),

          // Tender Types Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                _buildTenderFilterChip('All Tenders (ظƒظ„ ط§ظ„ظ…ظ†ط§ظ‚طµط§طھ)', null),
                _buildTenderFilterChip('Subcontracting (ظ…ظ‚ط§ظˆظ„ط§طھ ط¨ط§ط·ظ†)', 'SUBCONTRACTING'),
                _buildTenderFilterChip('Equipment Rental (طھط£ط¬ظٹط± ظ…ط¹ط¯ط§طھ)', 'EQUIPMENT_RENTAL'),
                _buildTenderFilterChip('Material Supply (طھظˆط±ظٹط¯ ظ…ظˆط§ط¯)', 'MATERIAL_SUPPLY'),
              ],
            ),
          ),

          // Tenders Cards
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text('No tenders match your filter', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            ...filtered.map((tender) => _buildTenderCard(tender)),
        ],
      ),
    );
  }

  Widget _buildTenderFilterChip(String label, String? typeKey) {
    final isSelected = _selectedTypeFilter == typeKey;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selectedColor: AppColors.accentCyan,
        backgroundColor: const Color(0xFF1E293B),
        labelStyle: TextStyle(color: isSelected ? const Color(0xFF0B192C) : Colors.white70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (val) => setState(() => _selectedTypeFilter = val ? typeKey : null),
      ),
    );
  }

  Widget _buildTenderCard(Map<String, dynamic> tender) {
    final deadlineDays = tender['deadlineDays'] as int;
    final isUrgent = deadlineDays <= 7;
    final deadlineColor = isUrgent ? AppColors.cautionAmber : AppColors.verifiedGreen;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151F32),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tender['tenderNo'] as String,
                      style: const TextStyle(color: AppColors.accentCyan, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tender['authorityEn'] as String,
                    style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: deadlineColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: deadlineColor, size: 12),
                    const SizedBox(width: 3),
                    Text(
                      '$deadlineDays days left',
                      style: TextStyle(color: deadlineColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Titles
          Text(
            tender['titleEn'] as String,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, height: 1.3),
          ),
          Text(
            tender['titleAr'] as String,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 6),

          // Location & Category
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.accentCyan, size: 12),
              const SizedBox(width: 4),
              Text(
                tender['locationEn'] as String,
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
              const SizedBox(width: 8),
              const Text('â€¢', style: TextStyle(color: Colors.grey, fontSize: 10)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tender['categoryEn'] as String,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Scope
          Text(
            tender['scopeEn'] as String,
            style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          // Budget & Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estimated Budget / ط§ظ„ظ…ظٹط²ط§ظ†ظٹط©', style: TextStyle(color: Colors.grey, fontSize: 9)),
                  Text(
                    '${NumberFormat('#,###').format(tender['budgetAed'])} AED',
                    style: const TextStyle(color: AppColors.accentCyan, fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.auto_awesome, size: 13, color: AppColors.accentCyan),
                    label: const Text('AI Feasibility', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () => _showAiFeasibilityBottomSheet(tender),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan,
                      foregroundColor: const Color(0xFF0B192C),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.send, size: 13),
                    label: const Text('Bid', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: () => _showBidSubmissionDialog(tender),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. ORDERS PROCUREMENT SCREEN (EXISTING PORT)
// ---------------------------------------------------------------------------

class OrdersProcurementScreen extends StatefulWidget {
  const OrdersProcurementScreen({super.key});
  @override
  State<OrdersProcurementScreen> createState() => _OrdersProcurementScreenState();
}

class _OrdersProcurementScreenState extends State<OrdersProcurementScreen> {
  int _mode = 0;
  int _poFilter = 0;
  String? _qrOrderId;

  bool _poMatch(String statusName) => switch (_poFilter) {
        1 => statusName == 'submitted' || statusName == 'approved',
        2 => statusName == 'inTransit' || statusName == 'outForDelivery',
        3 => statusName == 'delivered',
        _ => true,
      };

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<AppLocalization>();
    final repo = context.watch<ProcurementRepository>();
    return Scaffold(
      appBar: AppBar(title: Text(loc.t('screen.orders'))),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 0, label: Text(loc.t('ord.mode_materials'))),
              ButtonSegment(value: 1, label: Text(loc.t('ord.mode_pos'))),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
          ),
        ),
        Expanded(
          child: _mode == 0
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: MaterialProcurementView(
                    orders: repo.orders,
                    onAddOrder: repo.addOrder,
                    onUpdateStatus: (id, status, progress) => repo.updateOrderProgress(id, progress),
                    onDeleteOrder: repo.deleteOrder,
                  ),
                )
              : _poList(context, loc, repo),
        ),
      ]),
    );
  }

  Widget _poList(BuildContext context, AppLocalization loc, ProcurementRepository repo) {
    final filters = [
      loc.t('ord.f_all'),
      loc.t('ord.f_awaiting'),
      loc.t('ord.f_transit'),
      loc.t('ord.f_done'),
    ];
    final orders = repo.orders.where((o) => _poMatch(o.status.name)).toList();
    return Column(children: [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
            children: List.generate(
                filters.length,
                (i) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6),
                    child: ChoiceChip(
                        label: Text(filters[i]),
                        selected: _poFilter == i,
                        onSelected: (_) => setState(() => _poFilter = i))))),
      ),
      Expanded(
        child: orders.isEmpty
            ? Center(child: Text(loc.t('ord.empty_pos')))
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (_, i) {
                  final o = orders[i];
                  return Card(
                    child: ListTile(
                      title: Text('${o.poNumber.isEmpty ? o.id : o.poNumber} â€¢ ${loc.tr(o.materialNameAr, o.materialNameEn)}'),
                      subtitle: Text('${o.supplierName} â€¢ ${loc.t('ord.escrow')}: ${loc.formatAed(o.grandTotalAed)}'),
                      trailing: ElevatedButton(
                        onPressed: () => setState(() => _qrOrderId = o.id),
                        child: Text(loc.t('ord.delivery_qr')),
                      ),
                    ),
                  );
                },
              ),
      ),
      if (_qrOrderId != null)
        AlertDialog(
          title: Text(loc.t('ord.qr_title')),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.qr_code_2, size: 120),
            Text(loc.t('ord.qr_body')),
            Text(_qrOrderId!),
          ]),
          actions: [
            TextButton(onPressed: () => setState(() => _qrOrderId = null), child: Text(loc.t('common.cancel'))),
          ],
        ),
    ]);
  }
}
