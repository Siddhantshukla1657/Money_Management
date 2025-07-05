import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/person.dart';
import '../models/bill_split.dart';

class BillSplitScreen extends StatefulWidget {
  final List<Person> existingPersons;
  final Function(BillSplit) onSplitCreated;

  const BillSplitScreen({
    Key? key,
    required this.existingPersons,
    required this.onSplitCreated,
  }) : super(key: key);

  @override
  _BillSplitScreenState createState() => _BillSplitScreenState();
}

class _BillSplitScreenState extends State<BillSplitScreen> {
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newPersonController = TextEditingController();
  
  List<SplitPerson> selectedPersons = [];
  bool _showNewPersonField = false;
  
  @override
  void initState() {
    super.initState();
    // Add "You" as default person
    selectedPersons.add(SplitPerson(
      id: 'user_self',
      name: 'You',
      isFromContacts: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Split Bill'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Total Amount Field
            TextField(
              controller: _totalAmountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Total Bill Amount',
                border: OutlineInputBorder(),
                hintText: 'Enter total amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              onChanged: (value) => setState(() {}), // Update UI when amount changes
            ),
            SizedBox(height: 16),
            
            // Description Field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                hintText: 'e.g., Dinner at Restaurant',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            SizedBox(height: 24),
            
            // Select People Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select People',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    
                    // Existing Contacts
                    if (widget.existingPersons.isNotEmpty) ...[
                      Text(
                        'From Contacts:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      ...widget.existingPersons.map((person) => 
                        CheckboxListTile(
                          title: Text(person.name),
                          value: selectedPersons.any((p) => p.id == person.id),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedPersons.add(SplitPerson(
                                  id: person.id,
                                  name: person.name,
                                  isFromContacts: true,
                                ));
                              } else {
                                selectedPersons.removeWhere((p) => p.id == person.id);
                              }
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                    
                    // Add New Person Button
                    if (!_showNewPersonField)
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _showNewPersonField = true),
                        icon: Icon(Icons.person_add),
                        label: Text('Add New Person'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    
                    // New Person Field
                    if (_showNewPersonField) ...[
                      TextField(
                        controller: _newPersonController,
                        decoration: InputDecoration(
                          labelText: 'New Person Name',
                          border: OutlineInputBorder(),
                          hintText: 'Enter name',
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.green),
                                onPressed: _addNewPerson,
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel, color: Colors.red),
                                onPressed: () => setState(() {
                                  _showNewPersonField = false;
                                  _newPersonController.clear();
                                }),
                              ),
                            ],
                          ),
                        ),
                        onSubmitted: (_) => _addNewPerson(),
                      ),
                      SizedBox(height: 16),
                    ],
                    
                    // Selected People List
                    if (selectedPersons.isNotEmpty) ...[
                      Text(
                        'Selected People (${selectedPersons.length}):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      ...selectedPersons.map((person) => 
                        ListTile(
                          leading: Icon(
                            person.id == 'user_self' 
                                ? Icons.account_circle 
                                : person.isFromContacts 
                                    ? Icons.contacts 
                                    : Icons.person,
                            color: person.id == 'user_self' 
                                ? Colors.green 
                                : person.isFromContacts 
                                    ? Colors.blue 
                                    : Colors.grey,
                          ),
                          title: Text(
                            person.name,
                            style: TextStyle(
                              fontWeight: person.id == 'user_self' ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: person.id == 'user_self' 
                              ? Icon(Icons.lock, color: Colors.grey)
                              : IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () => setState(() {
                                    selectedPersons.removeWhere((p) => p.id == person.id);
                                  }),
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Split Calculation Display
            if (selectedPersons.isNotEmpty && _totalAmountController.text.isNotEmpty) ...[
              SizedBox(height: 16),
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Split Calculation',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Total Bill: ₹${_totalAmountController.text}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'People: ${selectedPersons.length} (including you)',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Each person\'s share: ₹${_calculateAmountPerPerson().toInt()}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Others owe you: ₹${_calculateTotalOwed().toInt()}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                      if (selectedPersons.length > 1)
                        Text(
                          '(${selectedPersons.length - 1} people × ₹${_calculateAmountPerPerson().toInt()})',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            
            SizedBox(height: 24),
            
            // Split Bill Button
            ElevatedButton(
              onPressed: _canSplitBill() ? _splitBill : null,
              child: Text('Split Bill'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewPerson() {
    final name = _newPersonController.text.trim();
    
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a name')),
      );
      return;
    }
    
    // Check if person already exists
    if (selectedPersons.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Person already added')),
      );
      return;
    }
    
    setState(() {
      selectedPersons.add(SplitPerson(
        id: Uuid().v4(),
        name: name,
        isFromContacts: false,
      ));
      _newPersonController.clear();
      _showNewPersonField = false;
    });
  }

  double _calculateAmountPerPerson() {
    final totalAmount = double.tryParse(_totalAmountController.text) ?? 0;
    if (selectedPersons.isEmpty) return 0;
    final exactAmount = totalAmount / selectedPersons.length;
    return _customRound(exactAmount);
  }
  
  double _customRound(double value) {
    final intPart = value.floor();
    final decimalPart = value - intPart;
    
    if (decimalPart >= 0.01 && decimalPart <= 0.09) {
      return intPart + 1.0;
    } else if (decimalPart > 0.09) {
      return intPart + 1.0;
    } else {
      return intPart.toDouble();
    }
  }
  
  double _calculateTotalOwed() {
    final amountPerPerson = _calculateAmountPerPerson();
    // Exclude yourself from the people who owe you
    final othersCount = selectedPersons.where((p) => p.id != 'user_self').length;
    return amountPerPerson * othersCount;
  }

  bool _canSplitBill() {
    return _totalAmountController.text.isNotEmpty &&
           selectedPersons.length > 1 && // Must have at least one other person besides yourself
           double.tryParse(_totalAmountController.text) != null;
  }

  void _splitBill() {
    final totalAmount = double.tryParse(_totalAmountController.text)!;
    final description = _descriptionController.text.trim();
    
    final billSplit = BillSplit(
      id: Uuid().v4(),
      totalAmount: totalAmount,
      description: description.isEmpty ? 'Bill Split' : description,
      splitPersons: selectedPersons,
      date: DateTime.now(),
    );
    
    widget.onSplitCreated(billSplit);
    
    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bill Split Successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Bill: ₹${totalAmount.toInt()}'),
            Text('People: ${selectedPersons.length} (including you)'),
            Text('Each person\'s share: ₹${_calculateAmountPerPerson().toInt()}'),
            Text('Total others owe you: ₹${_calculateTotalOwed().toInt()}'),
            SizedBox(height: 16),
            Text('Transactions have been added to your contacts automatically.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close split screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _descriptionController.dispose();
    _newPersonController.dispose();
    super.dispose();
  }
}
