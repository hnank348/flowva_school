
import 'package:flowva_school/feature/parent/payments/data/mock_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_theme.dart';
import '../cubit/payments_cubit.dart';
import '../cubit/payments_state.dart';
import '../widgets/payment_kpi_grid.dart';
import '../widgets/wallet_payment_card.dart';
import '../widgets/pending_invoices_list.dart';
import '../widgets/paid_invoices_list.dart';

class QuickPaymentScreen extends StatelessWidget {
  const QuickPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : AppColors.primaryText;

    return BlocProvider(
      create: (context) => PaymentsCubit(MockPaymentService())..fetchPaymentData(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Builder(
              builder: (innerContext) {
                return BlocBuilder<PaymentsCubit, PaymentsState>(
                  builder: (context, state) {
                    if (state is PaymentsLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal,
                        ),
                      );
                    }

                    if (state is PaymentsSuccess) {
                      return CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            floating: false,
                            elevation: 0,
                            scrolledUnderElevation: 0,
                            toolbarHeight: 70,
                            leadingWidth: 50,
                            backgroundColor: isDark ? AppColors.darkSurface : AppColors.backgroundColor,
                            leading: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor, size: 20),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'الدفع السريع',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                    height: 1.2,
                                  ),
                                ),
                                const Text(
                                  'إدارة الفواتير والمدفوعات لجميع الأبناء',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SliverPadding(
                            padding: const EdgeInsets.only(
                              left: AppSizes.paddingMedium,
                              right: AppSizes.paddingMedium,
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            sliver: SliverToBoxAdapter(
                              child: PaymentKpiGrid(
                                totalPaid: state.totalPaid,
                                totalPending: state.totalPending,
                                paidCount: state.paidCount,
                                pendingCount: state.pendingCount,
                                onPayAllTap: () => innerContext.read<PaymentsCubit>().payAllPendingInvoices(),
                              ),
                            ),
                          ),

                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium, vertical: 4.0),
                            sliver: SliverToBoxAdapter(
                              child: WalletPaymentCard(wallet: state.wallet),
                            ),
                          ),

                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 14.0, bottom: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.receipt_long_rounded, color: Colors.orange, size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'الفواتير المعلقة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                            sliver: PendingInvoicesList(
                              invoices: state.invoices,
                              onPaySingle: (id) => innerContext.read<PaymentsCubit>().paySingleInvoice(id),
                            ),
                          ),

                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0, bottom: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'الفواتير المدفوعة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.primaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                            sliver: PaidInvoicesList(invoices: state.invoices),
                          ),

                          const SliverToBoxAdapter(child: SizedBox(height: 16)),
                        ],
                      );
                    }

                    if (state is PaymentsError) {
                      return Center(
                        child: Text(
                          state.errorMessage,
                          style: const TextStyle(fontFamily: 'Cairo', color: AppColors.errorRed),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
