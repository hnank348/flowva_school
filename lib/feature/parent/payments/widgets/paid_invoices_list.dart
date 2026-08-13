
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app_theme.dart';
import '../models/invoice_model.dart';

class PaidInvoicesList extends StatelessWidget {
  final List<InvoiceModel> invoices;

  const PaidInvoicesList({super.key, required this.invoices});

  void _showReceiptModal(BuildContext context, InvoiceModel invoice) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'إيصال الدفع الرقمي المعتمد',
                  style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 20),
              Text('رقم الفاتورة: ${invoice.id}', style: const TextStyle(fontFamily: 'Cairo')),
              Text('البند المالي: ${invoice.title}', style: const TextStyle(fontFamily: 'Cairo')),
              Text('اسم المستفيد: ${invoice.studentName}', style: const TextStyle(fontFamily: 'Cairo')),
              Text('المبلغ المسدد كاملاً: ${invoice.amount} ر.س', style: const TextStyle(fontFamily: 'Cairo', color: Colors.green, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                  label: const Text('حفظ بصيغة PDF على الجهاز', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paidInvoices = invoices.where((i) => i.status == InvoiceStatus.paid).toList();
    const Color greenThemeColor = Colors.green;

    if (paidInvoices.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              'سجل المدفوعات فارغ حالياً',
              style: TextStyle(fontFamily: 'Cairo', color: Colors.grey, fontSize: 12),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final invoice = paidInvoices[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: greenThemeColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: greenThemeColor.withValues(alpha: 0.25),
                width: 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'رسوم دراسية',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: greenThemeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'مسددة',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: greenThemeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        invoice.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'اسم الطالب: ${invoice.studentName}',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6, 
                        runSpacing: 2, 
                        children: [
                          Icon(Icons.calendar_month_rounded, size: 13, color: isDark ? Colors.white70 : Colors.grey[600]),
                          Text(
                            'تاريخ السداد: ${DateFormat('yyyy-MM-dd').format(invoice.dueDate)}',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: isDark ? Colors.white70 : Colors.grey[700],
                              fontSize: 10, 
                            ),
                          ),
                          Text(
                            '| ID: ${invoice.id}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'المبلغ: ',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 11,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${invoice.amount.toStringAsFixed(0)} ر.س',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 15, 
                            color: greenThemeColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: const Size(90, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () => _showReceiptModal(context, invoice),
                      child: const Text(
                        'تحميل الإيصال',
                        style: TextStyle(fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        childCount: paidInvoices.length,
      ),
    );
  }
}
