import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/person.dart';
import '../services/storage_service.dart';
import '../screens/person_detail_screen.dart';
import '../screens/add_person_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Person> persons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPersons();
  }

  Future<void> loadPersons() async {
    try {
      final loadedPersons = await StorageService.loadPersons();
      setState(() {
        persons = loadedPersons;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> savePersons() async {
    try {
      await StorageService.savePersons(persons);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  void addPerson(String name) {
    final newPerson = Person(
      id: Uuid().v4(),
      name: name,
      transactions: [],
    );
    setState(() {
      persons.add(newPerson);
    });
    savePersons();
  }

  void addTransaction(Person person, double amount, String description) {
    final newTransaction = Transaction(
      id: Uuid().v4(),
      amount: amount,
      description: description,
      date: DateTime.now(),
    );
    
    final updatedTransactions = [...person.transactions, newTransaction];
    final updatedPerson = person.copyWith(transactions: updatedTransactions);
    
    setState(() {
      final index = persons.indexWhere((p) => p.id == person.id);
      persons[index] = updatedPerson;
    });
    savePersons();
  }

  void settlePerson(Person person) {
    final settleTransaction = Transaction(
      id: Uuid().v4(),
      amount: -person.totalAmount,
      description: 'Settlement',
      date: DateTime.now(),
    );
    
    final updatedTransactions = [...person.transactions, settleTransaction];
    final updatedPerson = person.copyWith(transactions: updatedTransactions);
    
    setState(() {
      final index = persons.indexWhere((p) => p.id == person.id);
      persons[index] = updatedPerson;
    });
    savePersons();
  }

  void deletePerson(Person person) {
    setState(() {
      persons.removeWhere((p) => p.id == person.id);
    });
    savePersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Management'),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : persons.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No people added yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap + to add your first person',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index];
                    return PersonCard(
                      person: person,
                      onAddTransaction: (amount, description) =>
                          addTransaction(person, amount, description),
                      onSettle: () => settlePerson(person),
                      onViewDetails: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonDetailScreen(person: person),
                        ),
                      ),
                      onDelete: () => deletePerson(person),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPersonScreen()),
          );
          if (result != null) {
            addPerson(result);
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class PersonCard extends StatefulWidget {
  final Person person;
  final Function(double, String) onAddTransaction;
  final VoidCallback onSettle;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const PersonCard({
    Key? key,
    required this.person,
    required this.onAddTransaction,
    required this.onSettle,
    required this.onViewDetails,
    required this.onDelete,
  }) : super(key: key);

  @override
  _PersonCardState createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final person = widget.person;
    final totalAmount = person.totalAmount;
    final isPositive = totalAmount >= 0;
    final color = totalAmount == 0 ? Colors.green : (isPositive ? Colors.green : Colors.red);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    person.name,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: widget.onViewDetails,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(context),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Amount: ${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              totalAmount == 0
                  ? 'Settled'
                  : totalAmount > 0
                      ? 'They owe you: ${totalAmount.toStringAsFixed(2)}'
                      : 'You owe them: ${(-totalAmount).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount (+they gave you/-you gave them)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _addTransaction(),
                    icon: Icon(Icons.add),
                    label: Text('Add Transaction'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: totalAmount == 0 ? null : () => widget.onSettle(),
                    icon: Icon(Icons.check),
                    label: Text('Settle'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: totalAmount == 0 ? Colors.grey : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addTransaction() {
    final amountText = _amountController.text.trim();
    final description = _descriptionController.text.trim();

    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    widget.onAddTransaction(amount, description.isEmpty ? 'Transaction' : description);
    _amountController.clear();
    _descriptionController.clear();
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Person'),
          content: Text('Are you sure you want to delete ${widget.person.name}? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
