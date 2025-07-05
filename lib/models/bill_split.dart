class BillSplit {
  final String id;
  final double totalAmount;
  final String description;
  final List<SplitPerson> splitPersons;
  final DateTime date;

  BillSplit({
    required this.id,
    required this.totalAmount,
    required this.description,
    required this.splitPersons,
    required this.date,
  });

  double get amountPerPerson => totalAmount / splitPersons.length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'description': description,
      'splitPersons': splitPersons.map((p) => p.toJson()).toList(),
      'date': date.toIso8601String(),
    };
  }

  factory BillSplit.fromJson(Map<String, dynamic> json) {
    return BillSplit(
      id: json['id'] as String,
      totalAmount: json['totalAmount'] as double,
      description: json['description'] as String,
      splitPersons: (json['splitPersons'] as List<dynamic>)
          .map((p) => SplitPerson.fromJson(p as Map<String, dynamic>))
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class SplitPerson {
  final String id;
  final String name;
  final bool isFromContacts;

  SplitPerson({
    required this.id,
    required this.name,
    this.isFromContacts = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isFromContacts': isFromContacts,
    };
  }

  factory SplitPerson.fromJson(Map<String, dynamic> json) {
    return SplitPerson(
      id: json['id'] as String,
      name: json['name'] as String,
      isFromContacts: json['isFromContacts'] as bool? ?? false,
    );
  }
}
