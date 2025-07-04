import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/person.dart';

class PersonDetailScreen extends StatelessWidget {
  final Person person;

  const PersonDetailScreen({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = [...person.transactions];
    sortedTransactions.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Summary Card
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Amount:', style: TextStyle(fontSize: 16)),
                      Text(
                        '${person.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: person.totalAmount == 0
                              ? Colors.green
                              : person.totalAmount > 0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    person.totalAmount == 0
                        ? 'All settled'
                        : person.totalAmount > 0
                            ? 'They owe you: ${person.totalAmount.toStringAsFixed(2)}'
                            : 'You owe them: ${(-person.totalAmount).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Transactions:', style: TextStyle(fontSize: 16)),
                      Text(
                        '${person.transactions.length}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Transaction History
          Expanded(
            child: person.transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add transactions from the main screen',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = sortedTransactions[index];
                      return TransactionCard(transaction: transaction);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.amount >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final prefix = isPositive ? '+' : '';

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          transaction.description,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy - HH:mm').format(transaction.date),
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '$prefix${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
