// Clean Architecture: Finance — Complete Feature-Rich Presentation.
// Faithful Flutter port of original Kotlin Jetpack Compose screens:
// FinanceClaimsScreen, SmartPettyCashWalletScreen, CostToCompleteScreen,
// FinancialAiScreen, ProjectBusinessPlanScreen.

import 'package:flutter/material.dart';
import 'package:buildhub/core/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// 1. FINANCE CLAIMS & COMMERCIAL HUB SCREEN
// ---------------------------------------------------------------------------

class FinanceClaimsFullScreen extends StatefulWidget {
  const FinanceClaimsFullScreen({super.key});

  @override
  State<FinanceClaimsFullScreen> createState() => _FinanceClaimsFullScreenState();
}

class _FinanceClaimsFullScreenState extends State<FinanceClaimsFullScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
            Text('Commercial & Finance Control', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('Burn Rate • IPCs • Variations • 5% VAT • FIDIC Claims', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.accentCyan,
          tabs: const [
            Tab(text: 'Burn Rate & Budget'),
            Tab(text: 'Interim IPCs'),
            Tab(text: 'Variations (VO)'),
            Tab(text: 'UAE 5% VAT'),
            Tab(text: 'FIDIC Claims (20.1)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBurnRateTab(),
          _buildIpcTab(),
          _buildVoTab(),
          _buildVatTab(),
          _buildFidicClaimsTab(),
        ],
      ),
    );
  }

  Widget _buildBurnRateTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall Budget Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.accentCyan.withValues(alpha: 0.15), Colors.blue.withValues(alpha: 0.1)]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentCyan),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Contract Value (AED)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              SizedBox(height: 6),
              Text('45,000,000 AED', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Certified to Date: 28,450,000 AED (63.2%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  Text('Retention (10%): 2,845,000 AED', style: TextStyle(fontSize: 11, color: AppColors.goldEmirates)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(child: _FinCard(title: 'Monthly Burn Rate', val: '2.1M AED', col: AppColors.accentCyan)),
            Expanded(child: _FinCard(title: 'Remaining Budget', val: '16.5M AED', col: AppColors.verifiedGreen)),
            Expanded(child: _FinCard(title: 'Variance at Completion', val: '+450K AED', col: AppColors.cautionAmber)),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cost Variance by Discipline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                _varianceRow('Substructure & Piling', '9.2M AED', 'Target: 9.0M', AppColors.verifiedGreen),
                _varianceRow('Superstructure Concrete', '14.8M AED', 'Target: 14.2M (+600K)', AppColors.cautionAmber),
                _varianceRow('MEP Services', '12.0M AED', 'Target: 12.5M (-500K)', AppColors.verifiedGreen),
                _varianceRow('Façade & Glazing', '6.5M AED', 'Target: 6.8M', AppColors.verifiedGreen),
                _varianceRow('Finishing Works', '2.5M AED', 'Target: 2.5M', Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIpcTab() {
    final ipcs = [
      {'no': 'IPC-06 (Latest)', 'month': 'September 2026', 'gross': '3,450,000 AED', 'net': '3,105,000 AED', 'status': 'CERTIFIED & PAID', 'color': AppColors.verifiedGreen},
      {'no': 'IPC-05', 'month': 'August 2026', 'gross': '2,980,000 AED', 'net': '2,682,000 AED', 'status': 'PAID', 'color': AppColors.verifiedGreen},
      {'no': 'IPC-04', 'month': 'July 2026', 'gross': '3,120,000 AED', 'net': '2,808,000 AED', 'status': 'PAID', 'color': AppColors.verifiedGreen},
      {'no': 'IPC-07 (Draft)', 'month': 'October 2026', 'gross': '3,800,000 AED', 'net': '3,420,000 AED', 'status': 'UNDER ENGINEER REVIEW', 'color': AppColors.cautionAmber},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Interim Payment Certificates (IPCs)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Create New IPC Draft'),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...ipcs.map((ipc) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.receipt_long, color: AppColors.accentCyan),
                title: Text(ipc['no'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('${ipc['month']} • Gross: ${ipc['gross']} • Net Payable: ${ipc['net']}'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: (ipc['color'] as Color).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                  child: Text(ipc['status'] as String, style: TextStyle(color: ipc['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildVoTab() {
    final vos = [
      {'no': 'VO-01', 'title': 'Additional Foundation Piles at Axis C', 'val': '+320,000 AED', 'eot': '+12 Days EOT', 'status': 'APPROVED BY CLIENT', 'color': AppColors.verifiedGreen},
      {'no': 'VO-02', 'title': 'Chilled Water Pipe Spec Upgrade to Class 150', 'val': '+185,000 AED', 'eot': '+5 Days EOT', 'status': 'APPROVED BY CLIENT', 'color': AppColors.verifiedGreen},
      {'no': 'VO-03', 'title': 'Façade Acoustic Glazing Enhancement for Sound Insulation', 'val': '+450,000 AED', 'eot': '+18 Days EOT', 'status': 'PENDING CLIENT APPROVAL', 'color': AppColors.cautionAmber},
      {'no': 'VO-04', 'title': 'Emergency Site Dewatering during heavy storm', 'val': '+95,000 AED', 'eot': '+3 Days EOT', 'status': 'UNDER ENGINEER ASSESSMENT', 'color': AppColors.cautionAmber},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Variation Orders (VO Register)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 12),
        ...vos.map((v) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(v['no'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: (v['color'] as Color).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(v['status'] as String, style: TextStyle(color: v['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(v['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('Cost Impact: ${v['val']} • Schedule: ${v['eot']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildVatTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.goldEmirates.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.goldEmirates),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('UAE Federal Tax Authority (FTA) 5% VAT Reconciliation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.goldEmirates)),
              SizedBox(height: 8),
              Text('Tax Registration Number (TRN): 100485219100003', style: TextStyle(fontSize: 12)),
              Text('Tax Period: Q3 2026 • Status: Reconciled & Ready for Filing', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(child: _FinCard(title: 'Output VAT (Billed)', val: '1,422,500 AED', col: AppColors.verifiedGreen)),
            Expanded(child: _FinCard(title: 'Input VAT (Recoverable)', val: '890,200 AED', col: AppColors.accentCyan)),
            Expanded(child: _FinCard(title: 'Net Payable to FTA', val: '532,300 AED', col: AppColors.cautionAmber)),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.picture_as_pdf, color: AppColors.goldEmirates),
            title: const Text('Download FTA VAT 201 Return Summary Form', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            subtitle: const Text('Audited against all contractor tax invoices'),
            trailing: const Icon(Icons.download),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildFidicClaimsTab() {
    final claims = [
      {
        'no': 'CLM-2026-001',
        'clause': 'FIDIC Red Book Sub-Clause 20.1 & 8.4',
        'title': 'Unforeseeable Physical Conditions at Basement Piling (Sub-surface obstructions)',
        'eot': '28 Days EOT',
        'amount': '680,000 AED',
        'timebar': 'Time Bar Notice Served on Day 14 (Compliant < 28d)',
        'status': 'CONSULTANT DETERMINATION',
        'color': AppColors.cautionAmber,
      },
      {
        'no': 'CLM-2026-002',
        'clause': 'FIDIC Sub-Clause 8.4(c) Exceptionally Adverse Climatic Conditions',
        'title': 'Midday Ban heat index extension and crane wind gust hold days',
        'eot': '14 Days EOT',
        'amount': '195,000 AED',
        'timebar': 'Notice Served on Day 7',
        'status': 'APPROVED BY ENGINEER',
        'color': AppColors.verifiedGreen,
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.criticalRed.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.criticalRed)),
          child: const Row(
            children: [
              Icon(Icons.gavel, color: AppColors.criticalRed),
              SizedBox(width: 10),
              Expanded(
                child: Text('28-Day Strict Time Bar Radar (Sub-Clause 20.1): Zero notices lapsed. All potential claims logged within statutory deadlines.', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...claims.map((c) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(c['no'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: (c['color'] as Color).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                          child: Text(c['status'] as String, style: TextStyle(color: c['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(c['clause'] as String, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Text(c['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Extension: ${c['eot']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Cost: ${c['amount']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.accentCyan)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(c['timebar'] as String, style: const TextStyle(fontSize: 10, color: AppColors.verifiedGreen)),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _varianceRow(String title, String val, String target, Color col) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: col)),
              Text(target, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinCard extends StatelessWidget {
  final String title;
  final String val;
  final Color col;
  const _FinCard({required this.title, required this.val, required this.col});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(val, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: col)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. SMART PETTY CASH WALLET SCREEN
// ---------------------------------------------------------------------------

class PettyCashFullScreen extends StatefulWidget {
  const PettyCashFullScreen({super.key});

  @override
  State<PettyCashFullScreen> createState() => _PettyCashFullScreenState();
}

class _PettyCashFullScreenState extends State<PettyCashFullScreen> {
  double _balance = 10720.0;
  final double _limit = 15000.0;

  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Site Office Pantry & Drinking Water', 'cat': 'Pantry', 'amount': 345.0, 'vat': 17.25, 'date': '2026-09-28', 'status': 'APPROVED', 'icon': Icons.local_cafe},
    {'title': 'Emergency Shuttering Nails & Wire', 'cat': 'Hardware', 'amount': 620.0, 'vat': 31.00, 'date': '2026-09-27', 'status': 'APPROVED', 'icon': Icons.build},
    {'title': 'Large Format Drawings Plotting & Copying', 'cat': 'Printing', 'amount': 480.0, 'vat': 24.00, 'date': '2026-09-26', 'status': 'APPROVED', 'icon': Icons.print},
    {'title': 'Site Pickup Truck Diesel & Salik Tolls', 'cat': 'Fuel/Transport', 'amount': 550.0, 'vat': 27.50, 'date': '2026-09-25', 'status': 'PENDING PM REVIEW', 'icon': Icons.local_gas_station},
  ];

  void _newExpenseDialog() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String category = 'Hardware';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Record New Petty Cash Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Expense Description', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: ['Hardware', 'Pantry', 'Printing', 'Fuel/Transport', 'Gas Cylinders']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => category = v!,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount in AED (Excl. VAT)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black),
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text) ?? 0.0;
              if (amt > 0) {
                final vat = amt * 0.05;
                final total = amt + vat;
                setState(() {
                  _balance -= total;
                  _transactions.insert(0, {
                    'title': titleCtrl.text.isEmpty ? 'Site Expense' : titleCtrl.text,
                    'cat': category,
                    'amount': amt,
                    'vat': vat,
                    'date': '2026-09-28',
                    'status': 'PENDING PM REVIEW',
                    'icon': Icons.receipt,
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Expense submitted! 5% VAT calculated (${vat.toStringAsFixed(2)} AED)')),
                );
              }
            },
            child: const Text('Submit Claim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Engineer Petty Cash & Digital Card')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Digital Corporate Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF0F172A)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan.withValues(alpha: 0.5)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ORION CORPORATE CARD', style: TextStyle(letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Icon(Icons.contactless, color: AppColors.accentCyan),
                  ],
                ),
                const SizedBox(height: 18),
                Text('${_balance.toStringAsFixed(2)} AED', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 6),
                Text('Available Balance of ${_limit.toStringAsFixed(0)} AED Monthly Limit', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Eng. Abdelfattah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    Text('•••• 4821', style: TextStyle(fontFamily: 'monospace', fontSize: 14, color: AppColors.accentCyan)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentCyan, foregroundColor: Colors.black, minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Scan Receipt (OCR) & Submit Claim'),
            onPressed: _newExpenseDialog,
          ),
          const SizedBox(height: 20),
          const Text('Recent Petty Cash Claims', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 10),
          ..._transactions.map((t) {
            final isAppr = t['status'] == 'APPROVED';
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.accentCyan.withValues(alpha: 0.15),
                  child: Icon(t['icon'] as IconData, color: AppColors.accentCyan, size: 20),
                ),
                title: Text(t['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: Text('${t['cat']} • ${t['date']} • 5% VAT: ${(t['vat'] as double).toStringAsFixed(2)} AED'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${(t['amount'] as double).toStringAsFixed(2)} AED', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(t['status'] as String, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isAppr ? AppColors.verifiedGreen : AppColors.cautionAmber)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. COST TO COMPLETE SCREEN
// ---------------------------------------------------------------------------

class CostToCompleteFullScreen extends StatelessWidget {
  const CostToCompleteFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cost-to-Complete AI & Earned Value')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Earned Value Analysis (EVM)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  _evmRow('Budget at Completion (BAC)', '45,000,000 AED'),
                  _evmRow('Earned Value (EV)', '28,450,000 AED'),
                  _evmRow('Actual Cost (AC)', '27,980,000 AED'),
                  _evmRow('Cost Performance Index (CPI)', '1.02 (Under Budget)', col: AppColors.verifiedGreen),
                  _evmRow('Schedule Performance Index (SPI)', '0.98 (Slight Lag)', col: AppColors.cautionAmber),
                  const Divider(height: 20),
                  _evmRow('Estimate at Completion (EAC)', '44,117,647 AED', col: AppColors.accentCyan),
                  _evmRow('Estimate to Complete (ETC)', '16,137,647 AED'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _evmRow(String label, String val, {Color? col}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(val, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: col)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. FINANCIAL AI SCREEN
// ---------------------------------------------------------------------------

class FinancialAiFullScreen extends StatelessWidget {
  const FinancialAiFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial AI Advisor')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accentCyan),
            ),
            child: const Row(
              children: [
                Icon(Icons.smart_toy, color: AppColors.accentCyan, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cash Flow Gap Prediction (Next 60 Days)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.accentCyan)),
                      Text('AI anticipates a temporary 1.2M AED liquidity dip in November before IPC-07 release. Escrow drawdown advised.', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance, color: AppColors.goldEmirates),
              title: const Text('Escrow Account Compliance (Dubai Law No. 8)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('DLD Escrow inspection passed • 18.5M AED locked for contractor milestone releases'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. PROJECT BUSINESS PLAN SCREEN
// ---------------------------------------------------------------------------

class BusinessPlanFullScreen extends StatelessWidget {
  const BusinessPlanFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Commercial Business Plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Project Financial Viability & Feasibility', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Internal Rate of Return (IRR):'),
                      Text('18.4%', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.verifiedGreen)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Net Present Value (NPV):'),
                      Text('12.8M AED', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.accentCyan)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payback Period:'),
                      Text('3.2 Years', style: TextStyle(fontWeight: FontWeight.bold)),
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
