class Person {
  final String id;
  final String name;
  final List<Transaction> transactions;

  Person({
    required this.id,
    required this.name,
    required this.transactions,
  });

  double get totalAmount {
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  bool get isSettled => totalAmount == 0.0;
  bool get owesYou => totalAmount < 0;
  bool get youOwe => totalAmount > 0;

  Person copyWith({
    String? id,
    String? name,
    List<Transaction>? transactions,
  }) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'transactions': transactions.map((t) => t.toJson()).toList(),
    };
  }

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as String,
      name: json['name'] as String,
      transactions: (json['transactions'] as List<dynamic>)
          .map((t) => Transaction.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Transaction {
  final String id;
  final double amount; // positive = you gave money, negative = you received money
  final String description;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: json['amount'] as double,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
