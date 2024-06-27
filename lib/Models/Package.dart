class Package {
  final String packageID;
  final int packageDuration;
  final String level;
  final double amount;

  Package({
    required this.packageID,
    required this.packageDuration,
    required this.level,
    required this.amount,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      packageID: json['packageID'],
      packageDuration: json['packageDuration'],
      level: json['level'],
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageID': packageID,
      'packageDuration': packageDuration,
      'level': level,
      'amount': amount,
    };
  }

  String getReadableDuration() {
    if (packageDuration >= 365) {
      int years = packageDuration ~/ 365;
      return years == 1 ? '$years year' : '$years years';
    } else if (packageDuration >= 30) {
      int months = packageDuration ~/ 30;
      return months == 1 ? '$months month' : '$months months';
    } else {
      return '$packageDuration days';
    }
  }
}
