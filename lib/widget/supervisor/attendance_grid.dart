import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/app_localizations.dart';
import '../../cubit/supervisor/cubit_supervisor/attendance_filter_cubit.dart';
import 'attendance_types.dart';

class AttendanceGrid<TItem, TStatus> extends StatelessWidget {
  final List<TItem> items;
  final TStatus Function(TItem item) statusOf;
  final List<AttendanceFilterConfig<TStatus>> filters;
  final Widget Function(BuildContext context, TItem item, TStatus status)
  itemBuilder;
  final bool isTablet;
  final double mainAxisExtent;
  final String emptyTextKey;

  const AttendanceGrid({
    super.key,
    required this.items,
    required this.statusOf,
    required this.filters,
    required this.itemBuilder,
    required this.isTablet,
    required this.mainAxisExtent,
    required this.emptyTextKey,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = isTablet ? 20.0 : 14.0;

    // ✅ null = فلتر "الكل" الافتراضي، ما في enum منفصل نهائياً
    return BlocProvider(
      create: (_) => AttendanceFilterCubit<TStatus?>(null),
      child: BlocBuilder<AttendanceFilterCubit<TStatus?>, TStatus?>(
        builder: (context, activeFilter) {
          final cs = Theme.of(context).colorScheme;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          final filteredItems = activeFilter == null
              ? items
              : items.where((it) => statusOf(it) == activeFilter).toList();

          return Column(
            children: [
              // ─── شريط الفلترة ───
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final item = filters[i];
                    final isSelected = activeFilter == item.status;
                    final count = item.status == null
                        ? items.length
                        : items.where((it) => statusOf(it) == item.status).length;

                    return GestureDetector(
                      onTap: () => context
                          .read<AttendanceFilterCubit<TStatus?>>()
                          .setFilter(item.status),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? item.color.withOpacity(isDark ? 0.22 : 0.1)
                              : (isDark ? cs.surfaceContainer : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? item.color.withOpacity(0.8)
                                : cs.outlineVariant
                                .withOpacity(isDark ? 0.6 : 0.5),
                            width: isSelected ? 1.2 : 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(context.tr(item.labelKey),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? item.color
                                      : cs.onSurfaceVariant,
                                )),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? item.color.withOpacity(0.18)
                                    : cs.onSurfaceVariant
                                    .withOpacity(isDark ? 0.15 : 0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('$count',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? item.color
                                        : cs.onSurfaceVariant,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              // ─── الـ Grid ───
              Expanded(
                child: filteredItems.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_list_off_rounded,
                          size: 36,
                          color: cs.onSurfaceVariant.withOpacity(0.5)),
                      const SizedBox(height: 10),
                      Text(context.tr(emptyTextKey),
                          style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 13,
                              color: cs.onSurfaceVariant)),
                    ],
                  ),
                )
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth > 900 ? 3 : 2;
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: hPad, vertical: 4),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisExtent: mainAxisExtent,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final it = filteredItems[index];
                        return itemBuilder(context, it, statusOf(it));
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}