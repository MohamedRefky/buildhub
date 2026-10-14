// Clean Architecture: Procurement & Heavy Machinery Market — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// MachineryMarketplaceScreen, ConstructionOpenMarketScreen, GpsMaterialLocatorScreen,
// QuotationComparisonScreen, OrdersProcurementScreen, SuppliersCompaniesDirectoryScreen,
// GccTendersAiScreen.

import 'package:flutter/material.dart';
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
      'location': 'Abu Dhabi – Musaffah Ind.',
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
      'price': '45 AED / m³ Pumped',
      'monthly': 'Min. 120 m³ / Pour',
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
                items: const [DropdownMenuItem(value: 'FOR_RENT', child: Text('For Rent (للإيجار)')), DropdownMenuItem(value: 'FOR_SALE', child: Text('For Sale (للبيع)'))],
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
                label: const Text('All (الكل)'),
                selected: _selectedType == 'ALL',
                onSelected: (_) => setState(() => _selectedType = 'ALL'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('For Rent (للإيجار)'),
                selected: _selectedType == 'FOR_RENT',
                onSelected: (_) => setState(() => _selectedType = 'FOR_RENT'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('For Sale (للبيع)'),
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
                      Text('${m['price']} • ${m['monthly']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
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
                          Text('${m['hours']} • Telematics: ${m['telematics']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
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
      {'title': 'Doka Frami Xlife Shuttering Panels & Clamps (400 m²)', 'desc': 'Used on single tower project. Good re-usable condition.', 'price': '65,000 AED (Lot)', 'seller': 'Arabtec Liquidation Lot', 'verified': true},
      {'title': 'Schedule 40 Carbon Steel Chilled Water Pipes 6-inch', 'desc': 'Unused surplus 240 meters. Factory epoxy coated.', 'price': '18,500 AED', 'seller': 'Drake & Scull Excess Inventory', 'verified': true},
      {'title': 'Porcelain Floor Tiles 60x60 RAK Ceramics (1,200 m²)', 'desc': 'Calacatta White finish, Grade 1 premium.', 'price': '32 AED / m²', 'seller': 'Sobha Projects Surplus', 'verified': true},
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

class GpsLocatorScreen extends StatelessWidget {
  const GpsLocatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Concrete Truck Transit Radar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simulated radar rings
                Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.3)))),
                Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.4)))),
                const Icon(Icons.location_on, color: AppColors.criticalRed, size: 30),
                const Positioned(
                  bottom: 12,
                  child: Text('Dubai Marina Site Center (Geofence Gate 2)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ),
                // Truck ping
                Positioned(
                  top: 40,
                  right: 60,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: AppColors.accentCyan, shape: BoxShape.circle),
                        child: const Icon(Icons.local_shipping, size: 16, color: Colors.black),
                      ),
                      const Text('Truck #04 (4.2 km)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mixer Truck DXB-77291 (Unibeton Ready Mix)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('ETA: 14 Min', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                    ],
                  ),
                  const Divider(height: 20),
                  const Text('• Batch Slump Time Elapsed: 38 min / 90 min max permissible (ASTM C94)', style: TextStyle(fontSize: 12)),
                  const Text('• Slump Target: 150 mm ± 25 mm (C40 Self-Compacting Mix)', style: TextStyle(fontSize: 12)),
                  const Text('• Concrete Batching Temperature: 28.5°C (Ice water injected)', style: TextStyle(fontSize: 12)),
                  const Text('• Driver: Tariq Mahmood • Phone: +971 55 982 1104', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.call, size: 16),
                          label: const Text('Call Mixer Driver'),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                          icon: const Icon(Icons.verified, size: 16),
                          label: const Text('Open Gate & Prepare Pour'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. QUOTATION COMPARISON SCREEN
// ---------------------------------------------------------------------------

class QuotationComparisonScreen extends StatelessWidget {
  const QuotationComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quotes = [
      {'supplier': 'Al Naboodah Steel LLC', 'price': '2,420 AED / Ton', 'total': '84,700 AED', 'techScore': '94%', 'delivery': '2 Days', 'isBest': true},
      {'supplier': 'Emirates Steel Arkan Direct', 'price': '2,450 AED / Ton', 'total': '85,750 AED', 'techScore': '98%', 'delivery': '3 Days', 'isBest': false},
      {'supplier': 'Gulf Steel Industries', 'price': '2,480 AED / Ton', 'total': '86,800 AED', 'techScore': '90%', 'delivery': '4 Days', 'isBest': false},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Quotation Comparison & Bid Analysis')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Requisition #MR-2026-081: 35 Tons Deformed Rebar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          ...quotes.map((q) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: (q['isBest'] as bool) ? AppColors.verifiedGreen : Colors.transparent, width: 1.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(q['supplier'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          if (q['isBest'] as bool)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.verifiedGreen.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                              child: const Text('RECOMMENDED BID', style: TextStyle(color: AppColors.verifiedGreen, fontWeight: FontWeight.bold, fontSize: 10)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Unit Rate: ${q['price']}'),
                          Text('Total: ${q['total']}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Technical Compliance: ${q['techScore']} • Lead Time: ${q['delivery']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: (q['isBest'] as bool) ? AppColors.verifiedGreen : Colors.white12),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PO Draft created for ${q['supplier']}')));
                          },
                          child: const Text('Generate PO & Award'),
                        ),
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
// 5. SUPPLIERS DIRECTORY SCREEN
// ---------------------------------------------------------------------------

class SuppliersDirectoryScreen extends StatelessWidget {
  const SuppliersDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final suppliers = [
      {'name': 'Unibeton Ready Mix LLC', 'cat': 'Ready-mix Concrete & Grout', 'rating': 4.9, 'approvals': 'RTA • DEWA • DM Approved', 'loc': 'Al Quoz Ind. 3, Dubai', 'phone': '+971 4 338 8888'},
      {'name': 'Emirates Steel Arkan', 'cat': 'Structural Steel & Rebar', 'rating': 4.9, 'approvals': 'Federal Govt • Abu Dhabi Municipality', 'loc': 'ICAD 1, Abu Dhabi', 'phone': '+971 2 555 8888'},
      {'name': 'Doka Gulf FZE', 'cat': 'Formwork & Shuttering Systems', 'rating': 4.8, 'approvals': 'Trakhees • DM Class A', 'loc': 'JAFZA, Dubai', 'phone': '+971 4 870 8700'},
      {'name': 'Danfoss Middle East', 'cat': 'MEP Valves & HVAC VFDs', 'rating': 4.7, 'approvals': 'DEWA • ASHRAE Certified', 'loc': 'Dubai Science Park', 'phone': '+971 4 456 1200'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Approved Suppliers & Contractors')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...suppliers.map((s) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.white10, child: Icon(Icons.business, color: AppColors.accentCyan)),
                  title: Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${s['cat']} • ${s['loc']}'),
                      Text(s['approvals'] as String, style: const TextStyle(fontSize: 10, color: AppColors.verifiedGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: AppColors.accentCyan),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${s['name']} at ${s['phone']}')));
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. GCC TENDERS AI SCREEN
// ---------------------------------------------------------------------------

class GccTendersScreen extends StatelessWidget {
  const GccTendersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tenders = [
      {
        'title': 'RTA Dubai: Road Widening & Infrastructure Corridor Contract R-1082',
        'authority': 'Roads & Transport Authority (RTA)',
        'bond': '1,500,000 AED Tender Bond',
        'closing': '18 Days Remaining',
        'aiScore': '92% Contractor Fit Score',
      },
      {
        'title': 'DEWA: Construction of 132/11kV Substation at Mohammed bin Rashid Solar Park',
        'authority': 'Dubai Electricity & Water Authority (DEWA)',
        'bond': '2,200,000 AED Tender Bond',
        'closing': '24 Days Remaining',
        'aiScore': '88% Fit Score',
      },
      {
        'title': 'Aldar Abu Dhabi: Yas Island Luxury Residential Towers EPC Package',
        'authority': 'Aldar Properties PJSC',
        'bond': '3,000,000 AED Tender Bond',
        'closing': '32 Days Remaining',
        'aiScore': '95% Fit Score',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('GCC Tenders AI & Opportunities')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...tenders.map((t) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.accentCyan.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                            child: Text(t['authority'] as String, style: const TextStyle(fontSize: 10, color: AppColors.accentCyan, fontWeight: FontWeight.bold)),
                          ),
                          Text(t['closing'] as String, style: const TextStyle(color: AppColors.cautionAmber, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(t['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text('${t['bond']} • ${t['aiScore']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
                        icon: const Icon(Icons.auto_awesome, size: 16),
                        label: const Text('AI Tender Feasibility & BOQ Analysis'),
                        onPressed: () {},
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
                      title: Text('${o.poNumber.isEmpty ? o.id : o.poNumber} • ${loc.tr(o.materialNameAr, o.materialNameEn)}'),
                      subtitle: Text('${o.supplierName} • ${loc.t('ord.escrow')}: ${loc.formatAed(o.grandTotalAed)}'),
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
