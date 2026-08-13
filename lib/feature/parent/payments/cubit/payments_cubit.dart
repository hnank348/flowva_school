
import 'package:flowva_school/feature/parent/payments/data/mock_payment_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payments_state.dart';
import '../models/invoice_model.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  final MockPaymentService _paymentService;
  List<InvoiceModel> _invoices = [];

  PaymentsCubit(this._paymentService) : super(PaymentsInitial());

  Future<void> fetchPaymentData() async {
    emit(PaymentsLoading());
    try {
      final data = await _paymentService.getPaymentData();
      _invoices = data['invoices'];
      _calculateAndEmitSuccess(data['wallet']);
    } catch (e) {
      emit(const PaymentsError(errorMessage: 'فشل في جلب البيانات المالية، يرجى المحاولة لاحقاً'));
    }
  }

  Future<void> paySingleInvoice(String id) async {
    if (state is PaymentsSuccess) {
      final currentState = state as PaymentsSuccess;
      try {
        _invoices = await _paymentService.payInvoice(id, _invoices);
        _calculateAndEmitSuccess(currentState.wallet);
      } catch (e) {
        emit(const PaymentsError(errorMessage: 'فشل في إتمام عملية السداد'));
      }
    }
  }

  Future<void> payAllPendingInvoices() async {
    if (state is PaymentsSuccess) {
      final currentState = state as PaymentsSuccess;
      try {
        _invoices = _invoices.map((invoice) {
          return invoice.status == InvoiceStatus.pending
              ? InvoiceModel(
                  id: invoice.id,
                  title: invoice.title,
                  subTitle: invoice.subTitle,
                  studentName: invoice.studentName,
                  amount: invoice.amount,
                  dueDate: invoice.dueDate,
                  status: InvoiceStatus.paid,
                  barcode: invoice.barcode,
                  isOrangeOverride: invoice.isOrangeOverride,
                )
              : invoice;
        }).toList();
        _calculateAndEmitSuccess(currentState.wallet);
      } catch (e) {
        emit(const PaymentsError(errorMessage: 'فشل في سداد جميع الفواتير'));
      }
    }
  }

  void _calculateAndEmitSuccess(dynamic wallet) {
    double totalPaid = 0;
    double totalPending = 0;
    int paidCount = 0;
    int pendingCount = 0;

    for (final invoice in _invoices) {
      if (invoice.status == InvoiceStatus.paid) {
        totalPaid += invoice.amount;
        paidCount++;
      } else {
        totalPending += invoice.amount;
        pendingCount++;
      }
    }

    emit(PaymentsSuccess(
      invoices: _invoices,
      wallet: wallet,
      totalPaid: totalPaid,
      totalPending: totalPending,
      paidCount: paidCount,
      pendingCount: pendingCount,
    ));
  }
}
