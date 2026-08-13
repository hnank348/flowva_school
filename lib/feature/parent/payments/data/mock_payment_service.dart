import 'dart:async';
import '../models/invoice_model.dart';
import '../models/payment_method_model.dart';

class MockPaymentService {
  final List<InvoiceModel> _mockInvoices = [
    InvoiceModel(
      id: 'INV-2026-001',
      title: 'رسوم دراسية',
      subTitle: 'رسوم الفصل الدراسي الثاني والأقساط الأساسية',
      studentName: 'أحمد محمد علي',
      amount: 3200.0,
      dueDate: DateTime(2026, 07, 10),
      status: InvoiceStatus.pending,
      barcode: 'BC-99210-X',
      isOrangeOverride: true,
    ),
    InvoiceModel(
      id: 'INV-2026-002',
      title: 'خدمات النقل والمواصلات',
      subTitle: 'اشتراك الحافلة المدرسية للفترة الثانية',
      studentName: 'أحمد محمد علي',
      amount: 450.0,
      dueDate: DateTime(2026, 06, 30),
      status: InvoiceStatus.pending,
      barcode: 'BC-99211-Y',
      isOrangeOverride: true,
    ),
    InvoiceModel(
      id: 'INV-2026-003',
      title: 'الأنشطة والرحلات المدرسية',
      subTitle: 'المعسكر التعليمي الصيفي وتطوير المهارات',
      studentName: 'أحمد محمد علي',
      amount: 150.0,
      dueDate: DateTime(2026, 06, 15),
      status: InvoiceStatus.pending,
      barcode: 'BC-99212-Z',
      isOrangeOverride: true,
    ),
    InvoiceModel(
      id: 'INV-2026-004',
      title: 'رسوم الكتب الدراسية والملخصات',
      subTitle: 'الحزمة الشاملة للمنهج الوزاري المطور',
      studentName: 'سارة محمد علي',
      amount: 600.0,
      dueDate: DateTime(2026, 05, 12),
      status: InvoiceStatus.pending,
      barcode: 'BC-99213-W',
      isOrangeOverride: false,
    ),
    InvoiceModel(
      id: 'INV-2026-005',
      title: 'رسوم الاختبارات الدولية والمعمل',
      subTitle: 'رسوم التسجيل لاختبارات تقييم مستوى النطق واللغة',
      studentName: 'سارة محمد علي',
      amount: 800.0,
      dueDate: DateTime(2026, 05, 01),
      status: InvoiceStatus.pending,
      barcode: 'BC-99214-M',
      isOrangeOverride: false, 
    ),
    InvoiceModel(
      id: 'INV-2026-006',
      title: 'الزي المدرسي الموحد',
      subTitle: 'الطقم الصيفي الرسمي والرياضي المعتمد',
      studentName: 'أحمد محمد علي',
      amount: 350.0,
      dueDate: DateTime(2026, 04, 10),
      status: InvoiceStatus.paid,
      barcode: 'BC-99201-P',
    ),
  ];

  final PaymentMethodModel _mockWallet = const PaymentMethodModel(
    id: 'W-01',
    name: 'المحفظة الإلكترونية الرقمية',
    description: 'وسيلة الدفع الفورية المعتمدة للحساب',
    balance: 750000.0,
  );

  Future<Map<String, dynamic>> getPaymentData() async {
    await Future.delayed(const Duration(milliseconds: 600)); 
    return {
      'invoices': List<InvoiceModel>.from(_mockInvoices),
      'wallet': _mockWallet,
    };
  }

  Future<List<InvoiceModel>> payInvoice(String id, List<InvoiceModel> currentInvoices) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return currentInvoices.map((invoice) {
      if (invoice.id == id) {
        return InvoiceModel(
          id: invoice.id,
          title: invoice.title,
          subTitle: invoice.subTitle,
          studentName: invoice.studentName,
          amount: invoice.amount,
          dueDate: invoice.dueDate,
          status: InvoiceStatus.paid,
          barcode: invoice.barcode,
          isOrangeOverride: invoice.isOrangeOverride,
        );
      }
      return invoice;
    }).toList();
  }
}