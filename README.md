# Money Management App

This is a simple Flutter application designed to help you manage money owed to or by individuals. It allows you to track transactions with different people and settle balances.

## Features

- **Add Persons**: Easily add new individuals to track money with.
- **Record Transactions**: Add positive or negative transactions for each person.
  - Positive amount: You gave money to the person.
  - Negative amount: You received money from the person.
- **View Balances**: See the total amount owed to or by each person at a glance.
- **Settle Debts**: Mark a person's balance as settled, adding a transaction to bring their total to zero.
- **Data Persistence**: All data is saved locally on your device using `shared_preferences`.

## Getting Started

### Prerequisites

- Flutter SDK (version 3.x.x or higher)
- A code editor like VS Code or Android Studio

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Siddhantshukla1657/money_management.git
   cd money_management
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

- `lib/main.dart`: The entry point of the application.
- `lib/models/person.dart`: Defines the `Person` and `Transaction` data models.
- `lib/screens/`: Contains the UI screens of the application.
  - `home_screen.dart`: Displays the list of persons and their balances, and handles adding/settling transactions.
  - `add_person_screen.dart`: Screen for adding a new person.
  - `person_detail_screen.dart`: Displays detailed transaction history for a person.
- `lib/services/storage_service.dart`: Handles local data persistence using `shared_preferences`.

## How to Use

1. **Add a Person**: Tap the `+` button on the home screen and enter the person's name.
2. **Add a Transaction**: Tap on a person's card, then tap the `+` button to add a new transaction. Enter the amount and a description.
3. **Settle a Debt**: On the person's card, tap the "Settle" button to clear their balance.
4. **View Details**: Tap on a person's card to see a detailed list of all transactions with them.

## Technologies Used

- Flutter
- Dart
- `shared_preferences` for local storage
- `uuid` for generating unique IDs

## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details. (Note: A `LICENSE` file is not present in the provided context, this is a placeholder.)
