
import 'package:flutter/material.dart';
import '../../../../../app_theme.dart';

class PaymentKpiGrid extends StatelessWidget {
  final double totalPaid;
  final double totalPending;
  final int paidCount;
  final int pendingCount;
  final VoidCallback onPayAllTap;

  const PaymentKpiGrid({
    super.key,
    required this.totalPaid,
    required this.totalPending,
    required this.paidCount,
    required this.pendingCount,
    required this.onPayAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'اجمالي المبلغ المستحق',
                    style: TextStyle(fontFamily: 'Cairo', color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${totalPending.toStringAsFixed(0)} ل.س',
                style: const TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryColor,
                    elevation: 0,
                    minimumSize: const Size(120, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: totalPending > 0 ? onPayAllTap : null,
                  child: const Text(
                    'دفع الكل',
                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildSubKpiCard(
                context: context,
                title: 'فواتير معلقة',
                value: '$pendingCount فواتير',
                icon: Icons.monetization_on_outlined,
                baseColor: Colors.orange,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSubKpiCard(
                context: context,
                title: 'الفواتير المدفوعة',
                value: '$paidCount مدفوعة',
                icon: Icons.account_balance_wallet_outlined,
                baseColor: Colors.green,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSubKpiCard(
                context: context,
                title: 'المدفوع للشهر',
                value: '${totalPaid.toStringAsFixed(0)} ل.س',
                icon: Icons.trending_up_rounded,
                baseColor: Colors.blue,
                isDark: isDark,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSubKpiCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color baseColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor, width: 1.2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: baseColor.withOpacity(0.3), width: 1),
            ),
            child: Icon(icon, color: baseColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: 'Cairo', color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Cairo', color: baseColor, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

