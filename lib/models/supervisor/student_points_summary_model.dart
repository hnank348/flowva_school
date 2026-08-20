class StudentPointsSummaryModel {
  final int positive;
  final int negative;
  final int total;
  final List<PointCategoryBreakdown> byCategory;

  StudentPointsSummaryModel({
    required this.positive,
    required this.negative,
    required this.total,
    required this.byCategory,
  });

  factory StudentPointsSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawCategory = json['by_category'];
    List<PointCategoryBreakdown> list = [];
    if (rawCategory is List) {
      list = rawCategory.map((e) => PointCategoryBreakdown.fromJson(e)).toList();
    }

    return StudentPointsSummaryModel(
      positive: json['positive'] ?? 0,
      negative: json['negative'] ?? 0,
      total: json['total'] ?? 0,
      byCategory: list,
    );
  }
}

class PointCategoryBreakdown {
  final String category;
  final String type;
  final int total;

  PointCategoryBreakdown({
    required this.category,
    required this.type,
    required this.total,
  });

  factory PointCategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return PointCategoryBreakdown(
      category: (json['category'] ?? '').toString().trim(),
      type: (json['type'] ?? 'positive').toString().trim(),
      total: int.tryParse(json['total']?.toString() ?? '0') ?? 0,
    );
  }

  bool get isPositive => type.toLowerCase() == 'positive';
}