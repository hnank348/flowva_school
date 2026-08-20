class PointCategoryModel {
  final int id;
  final String name;
  final String nameAr;
  final String type; // 'positive' or 'negative'
  final int defaultPoints;
  final String icon;
  final String color;
  final bool isActive;
  final bool autoAssign;

  PointCategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.type,
    required this.defaultPoints,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.autoAssign,
  });

  factory PointCategoryModel.fromJson(Map<String, dynamic> json) {
    return PointCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      type: json['type'] ?? 'positive',
      defaultPoints: json['default_points'] ?? 0,
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#3B82F6',
      isActive: json['is_active'] ?? true,
      autoAssign: json['auto_assign'] ?? false,
    );
  }

  bool get isPositive => type.toLowerCase() == 'positive';

  String getDisplayName(bool isArabic) {
    if (isArabic && nameAr.isNotEmpty) return nameAr;
    return name.isNotEmpty ? name : nameAr;
  }
}