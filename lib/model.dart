class UserData {
  String fullName;
  String email;
  String password;
  String confirmPassword;

  UserData({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

enum TransactionCategory {
  earnings,
  expenses,
}

class Transactions {
  final TransactionCategory category;
  final double amount;
  final String transactionName;
  final DateTime date;

  Transactions ({
    required this.category,
    required this.amount,
    required this.transactionName,
    required this.date
});
}

enum SortOption {
  newest,
  oldest,
  highAmount,
  lowAmount,
}