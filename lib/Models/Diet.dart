
class Diet {
  final String dietID;
  final String period;
  final int quantity;
  final String food;

  Diet({
    required this.dietID,
    required this.period,
    required this.quantity,
    required this.food,
  });

  factory Diet.fromJson(Map<String, dynamic> json) {
    return Diet(
      dietID: json['dietID'],
      period: json['period'],
      quantity: json['quantity'],
      food: json['food'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dietID': dietID,
      'period': period,
      'quantity': quantity,
      'food': food,
    };
  }
}
