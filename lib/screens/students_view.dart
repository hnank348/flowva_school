import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import '../data/mock_data.dart';
import '../models/student.dart';
import 'student_evaluation_view.dart';
import 'performance_reports_view.dart';
// removed unused imports

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final students = MockData.getStudents();
    final excellentStudents = students.where((s) => s.isExcellent).toList();
    final needsAttention = students.where((s) => s.needsAttention).toList();

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [colorScheme.primary, colorScheme.primaryContainer],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الطلاب',
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      style: TextStyle(color: colorScheme.onPrimary),
                      decoration: InputDecoration(
                        hintText: 'البحث عن طالب...',
                        hintStyle: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        filled: true,
                        fillColor: colorScheme.onPrimary.withOpacity(0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.onPrimary.withOpacity(0.16),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.onPrimary.withOpacity(0.16),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.onPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Tabs
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              tabs: [
                Tab(text: 'الكل (${students.length})'),
                Tab(text: 'متفوقون (${excellentStudents.length})'),
                Tab(text: 'يحتاج متابعة (${needsAttention.length})'),
              ],
            ),
          ),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStudentsList(students, colorScheme),
                _buildStudentsList(excellentStudents, colorScheme),
                _buildStudentsList(needsAttention, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList(List<Student> students, ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: colorScheme.primary.withOpacity(
                            0.12,
                          ),
                          child: Text(
                            student.name[0],
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: student.isExcellent
                                    ? colorScheme.primaryContainer
                                    : colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                student.isExcellent ? 'متفوق' : 'جيد',
                                style: TextStyle(
                                  color: student.isExcellent
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LabeledProgressBar(label: 'الدرجات', value: student.grade),
                const SizedBox(height: 8),
                LabeledProgressBar(label: 'الحضور', value: student.attendance),
                const SizedBox(height: 8),
                LabeledProgressBar(label: 'الأداء', value: student.performance),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentEvaluationView(student: student),
                            ),
                          );
                        },
                        icon: const Icon(Icons.star_outline, size: 18),
                        label: const Text('تقييم'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PerformanceReportsView(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.bar_chart, size: 18),
                        label: const Text('التقارير'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // `_buildProgressBar` replaced by `LabeledProgressBar` in `common_widgets.dart`
}
