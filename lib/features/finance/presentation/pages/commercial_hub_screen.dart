import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/finance/presentation/pages/finance_pages.dart';
import '../../../../features/procurement/presentation/pages/procurement_pages.dart';

/// Commercial Hub Screen that seamlessly integrates:
/// 1. Finance & Claims Hub (FIDIC IPC, Burn Rate, VAT Engine, VO Tracker)
/// 2. Smart Quotation Comparison & Bid Analysis (Side-by-side RFP tenders)
/// 3. Smart Petty Cash Wallet (EMV corporate engineer card)
/// 4. Cost to Complete & EVM Predictions
class CommercialHubScreen extends StatefulWidget {
  final int initialSubTab;
  const CommercialHubScreen({super.key, this.initialSubTab = 0});

  @override
  State<CommercialHubScreen> createState() => _CommercialHubScreenState();
}

class _CommercialHubScreenState extends State<CommercialHubScreen> {
  late int _selectedSubTab;

  @override
  void initState() {
    super.initState();
    _selectedSubTab = widget.initialSubTab;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Industrial Sub-Tab Bar
        Container(
          color: AppColors.darkSurface,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSubTabItem(0, 'المطالبات والمالية (Claims & IPC)', Icons.account_balance),
                _buildSubTabItem(1, 'مقارنة العطاءات (Tenders & RFPs)', Icons.compare_arrows),
                _buildSubTabItem(2, 'العهدة النقدية (Petty Cash)', Icons.credit_card),
                _buildSubTabItem(3, 'تكلفة الإنجاز (Cost to Complete)', Icons.trending_up),
              ],
            ),
          ),
        ),

        // Active Content
        Expanded(
          child: IndexedStack(
            index: _selectedSubTab,
            children: const [
              FinanceClaimsFullScreen(),
              QuotationComparisonScreen(),
              PettyCashFullScreen(),
              CostToCompleteFullScreen(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabItem(int index, String label, IconData icon) {
    final isSelected = _selectedSubTab == index;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () => setState(() => _selectedSubTab = index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentCyan : AppColors.darkCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.accentCyan : AppColors.darkBorder.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isSelected ? const Color(0xFF0B111E) : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xFF0B111E) : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
