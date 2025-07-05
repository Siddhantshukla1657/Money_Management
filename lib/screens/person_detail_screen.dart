import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/person.dart';

class PersonDetailScreen extends StatefulWidget {
  final Person person;
  final Function(String transactionId)? onDeleteTransaction;

  const PersonDetailScreen({
    Key? key, 
    required this.person,
    this.onDeleteTransaction,
  }) : super(key: key);

  @override
  _PersonDetailScreenState createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = [...widget.person.transactions];
    sortedTransactions.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
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
                        '${widget.person.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.person.totalAmount == 0
                              ? Colors.green
                              : widget.person.totalAmount > 0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.person.totalAmount == 0
                        ? 'All settled'
                        : widget.person.totalAmount > 0
                            ? 'They owe you: ${widget.person.totalAmount.toStringAsFixed(2)}'
                            : 'You owe them: ${(-widget.person.totalAmount).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total Transactions:', style: TextStyle(fontSize: 16)),
                      Text(
                        '${widget.person.transactions.length}',
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
            child: widget.person.transactions.isEmpty
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
                      return TransactionCard(
                        transaction: transaction,
                        onDelete: widget.onDeleteTransaction != null
                            ? () => _deleteTransaction(transaction.id)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _deleteTransaction(String transactionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Transaction'),
          content: Text('Are you sure you want to delete this transaction? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDeleteTransaction!(transactionId);
                Navigator.of(context).pop(); // Go back to home screen
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onDelete;

  const TransactionCard({
    Key? key, 
    required this.transaction,
    this.onDelete,
  }) : super(key: key);

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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$prefix${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (onDelete != null) ...[
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red),
                onPressed: onDelete,
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(4),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
