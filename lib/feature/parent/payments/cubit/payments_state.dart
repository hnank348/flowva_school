import 'package:equatable/equatable.dart';
import '../models/invoice_model.dart';
import '../models/payment_method_model.dart';

abstract class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object?> get props => [];
}

class PaymentsInitial extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsSuccess extends PaymentsState {
  final List<InvoiceModel> invoices;
  final PaymentMethodModel wallet;
  final double totalPaid;
  final double totalPending;
  final int paidCount;
  final int pendingCount;
  final bool isWalletExpanded;

  const PaymentsSuccess({
    required this.invoices,
    required this.wallet,
    required this.totalPaid,
    required this.totalPending,
    required this.paidCount,
    required this.pendingCount,
    this.isWalletExpanded = false, 
  });

  PaymentsSuccess copyWith({
    List<InvoiceModel>? invoices,
    PaymentMethodModel? wallet,
    double? totalPaid,
    double? totalPending,
    int? paidCount,
    int? pendingCount,
    bool? isWalletExpanded,
  }) {
    return PaymentsSuccess(
      invoices: invoices ?? this.invoices,
      wallet: wallet ?? this.wallet,
      totalPaid: totalPaid ?? this.totalPaid,
      totalPending: totalPending ?? this.totalPending,
      paidCount: paidCount ?? this.paidCount,
      pendingCount: pendingCount ?? this.pendingCount,
      isWalletExpanded: isWalletExpanded ?? this.isWalletExpanded,
    );
  }

  @override
  List<Object?> get props => [
        invoices,
        wallet,
        totalPaid,
        totalPending,
        paidCount,
        pendingCount,
        isWalletExpanded,
      ];
}

class PaymentsError extends PaymentsState {
  final String errorMessage;

  const PaymentsError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}