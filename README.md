# 💰 Money Management App

**An offline Flutter application for seamless money tracking between friends and contacts.**

Manage your personal finances by tracking who owes you money and who you owe money to. Perfect for splitting bills, lending money to friends, or keeping track of shared expenses!

## ✨ Key Features

### 👥 **Person Management**
- **Add Contacts**: Easily add new individuals to track money with
- **Contact Overview**: See all your contacts with their current balance at a glance
- **Smart Status Indicators**: Visual indicators showing who owes you (green) vs who you owe (red)
- **Delete Contacts**: Remove contacts you no longer need to track

### 💳 **Transaction Management**
- **Record Transactions**: Add transactions with custom amounts and descriptions
  - **Positive amount (+)**: Money you gave them (they owe you)
  - **Negative amount (-)**: Money they gave you (you owe them)
- **Transaction History**: View detailed transaction history for each person
- **Delete Transactions**: Remove individual transactions with confirmation
- **Smart Calculations**: Automatic balance calculations across all transactions

### 🧾 **Bill Splitting**
- **Split Bills Effortlessly**: Split any bill among multiple people
- **You're Included by Default**: Automatically includes you in the split calculation
- **Smart Rounding**: Custom rounding logic for decimal amounts
  - 0.01-0.09 → rounds up to next integer
  - 0.1-0.99 → rounds up to next integer
- **Mixed Contact Sources**: 
  - Select from existing contacts
  - Add new people on-the-fly during bill splitting
- **Real-time Calculations**: See split amounts update in real-time
- **Automatic Transaction Creation**: Automatically creates transactions for each person

### 💰 **Debt Settlement**
- **One-Click Settlement**: Settle all debts with a person instantly
- **Settlement Transactions**: Automatically creates settlement transaction records
- **Balance Clearing**: Brings the total balance to exactly zero

### 💾 **Data & Storage**
- **Offline First**: Works completely offline - no internet required
- **Local Data Storage**: All data saved securely on your device
- **Data Persistence**: Your data is automatically saved and restored
- **No Cloud Dependency**: Complete privacy - your data never leaves your device

## Getting Started

### Prerequisites

- Flutter SDK (version 3.x.x or higher)
- A code editor like VS Code or Android Studio

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Siddhantshukla1657/Money_Management.git
   cd Money_Management
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 📱 Screenshots

*Add screenshots here showing:*
- Home screen with person cards
- Bill splitting interface
- Transaction history view
- Add person/transaction screens

## 🏧 Project Structure

```
lib/
├── main.dart                     # App entry point
├── models/
│   ├── person.dart              # Person & Transaction models
│   └── bill_split.dart          # Bill splitting models
├── screens/
│   ├── home_screen.dart         # Main dashboard with person cards
│   ├── add_person_screen.dart   # Add new contact screen
│   ├── person_detail_screen.dart # Transaction history & details
│   └── bill_split_screen.dart   # Bill splitting interface
└── services/
    └── storage_service.dart     # Local data persistence
```

## 🚀 How to Use

### 👥 **Managing Contacts**
1. **Add a Person**: Tap the blue `+` button on the home screen and enter the person's name
2. **View Person Details**: Tap the info icon (ℹ️) on any person card to see detailed transaction history
3. **Delete a Person**: Tap the delete icon (🗑️) on any person card with confirmation

### 💳 **Recording Transactions**
1. **Add Individual Transaction**: 
   - On the home screen, find the person's card
   - Enter amount in the "Amount" field:
     - **Positive number** (e.g., `100`): You gave them ₹100 (they owe you)
     - **Negative number** (e.g., `-50`): They gave you ₹50 (you owe them)
   - Add optional description
   - Tap "Add Transaction"

2. **Delete Transaction**:
   - Go to person details (tap info icon)
   - Tap the delete icon (🗑️) next to any transaction
   - Confirm deletion

### 🧾 **Splitting Bills**
1. **Start Bill Split**: Tap the green receipt icon (🧾) on the home screen
2. **Enter Bill Details**:
   - Total bill amount (e.g., ₹1000)
   - Description (e.g., "Dinner at Restaurant")
3. **Select People**:
   - **You're automatically included** (cannot be removed)
   - Check existing contacts you want to include
   - Add new people using "Add New Person" button
4. **Review Split**: See real-time calculation showing:
   - Each person's share
   - Total amount others owe you
5. **Split Bill**: Tap "Split Bill" to automatically create transactions

**Example**: 
- Bill: ₹1000, People: You + 4 friends = 5 total
- Each pays: ₹200
- Others owe you: ₹800 (4 × ₹200)

### 💰 **Settling Debts**
1. **Settle All**: On any person card, tap the "Settle" button to clear their entire balance
2. **Automatic Settlement**: Creates a settlement transaction that brings balance to zero

## 🛠️ Technologies Used

- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language
- **shared_preferences** - Local data persistence
- **uuid** - Unique ID generation for transactions
- **intl** - Date formatting and internationalization

## 🎆 Key Highlights

- ✅ **100% Offline** - No internet connection required
- ✅ **Privacy First** - All data stays on your device
- ✅ **Smart Bill Splitting** - Handles complex splits with custom rounding
- ✅ **Intuitive UI** - Clean, user-friendly interface
- ✅ **Real-time Updates** - Instant balance calculations
- ✅ **Data Safety** - Automatic local data persistence
- ✅ **Transaction Management** - Full CRUD operations on transactions

## 📝 Use Cases

- **Friend Groups**: Track shared expenses, dinners, trips
- **Roommates**: Split utilities, rent, groceries
- **Family**: Track loans, shared purchases
- **Small Business**: Simple client payment tracking
- **Personal Finance**: Track money lent to friends

## 🚀 Future Enhancements

- [ ] Export data to CSV/PDF
- [ ] Backup & restore functionality
- [ ] Multiple currency support
- [ ] Expense categories
- [ ] Recurring transactions
- [ ] Photo attachments for receipts
- [ ] Group expense tracking

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🐛 Issues & Support

If you encounter any issues or have questions:
1. Check existing issues on GitHub
2. Create a new issue with detailed description
3. Include steps to reproduce the problem

## 📜 License

This project is licensed under the MIT License - see the `LICENSE` file for details.

---

**Made with ❤️ using Flutter**

*Perfect for anyone who needs a simple, reliable way to track money between friends and family!*
