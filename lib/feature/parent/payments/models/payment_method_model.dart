class PaymentMethodModel {
  final String id;
  final String name;
  final String description;
  final double balance;

  const PaymentMethodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.balance,
  });
}