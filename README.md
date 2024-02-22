# Spend Wise
Spend Wise
Spend Wise is a mobile application built with Flutter that helps users manage their financial transactions effectively. 
The app provides features for user authentication, adding transactions, viewing recent transactions, and tracking balance in real-time. 
Spend Wise integrates Firebase for user authentication and Firestore for storing transaction data securely.

# Features
- User Authentication: Secure user registration and login functionality using Firebase authentication.
* Real-time Balance Updates: Display total balance in real-time as transactions are added or removed.
+ Add Transactions: Allow users to add new transactions including transaction name, category, and amount.
- Categorize Transactions: Transactions can be categorized as earnings or expenses for better organization.
- View Recent Transactions: Display a list of recent transactions for quick reference.
- Filter and Sort Transactions: Users can filter transactions by category and sort them by date or amount.
- Intuitive UI: User-friendly interface designed using Flutter's Material Design principles for smooth navigation and interaction.
# Technologies Used
- Flutter: A cross-platform UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- Firebase Authentication: Provides easy-to-use authentication services for secure user sign-up and sign-in.
- Cloud Firestore: A flexible, scalable database for mobile, web, and server development, used for storing transaction data.
- Dart Programming Language: The primary programming language used for building Flutter applications.
# Screens
Home Page
- Display user's full name and welcome message.
- Show total balance and recent transactions.
- Navigate to add new transactions.
Balance Page
- Display credit card balance.
- Filter transactions by category and sort them based on user preferences.
Add Transaction Page
- Allow users to add new transactions with details like transaction name, category, and amount.
- Real-time validation and error handling for transaction inputs.
Sign-Up Page

# Design Patterns
Spend Wise implements several design patterns to enhance code structure, maintainability, and scalability:
- Component-Based Architecture: All UI elements are organized into reusable components, promoting code reusability and maintainability.
- Singleton Pattern: Utilized for managing application state and user authentication to ensure consistency and security.
- MVC (Model-View-Controller) Architecture: Promotes separation of concerns by dividing the application into three interconnected components, facilitating easier maintenance and testing.

# Review of Controller and Model Pages
SignUpController
- Manages user sign-up functionality by interacting with Firebase authentication and Firestore.
- Handles user registration and navigation to the home page upon successful sign-up.
- Provides error handling for weak passwords and existing email accounts.
FinancialManager
- Manages the total balance and recent transactions of the user.
- Updates the total balance based on the type of transaction (earnings or expenses) and adds transactions to the recent transaction list.
TransactionController
- Handles the addition of transactions to Firestore under the user's collection.
- Stores transaction details including category, amount, transaction name, and date.
UserData
- Represents user data including full name, email, password, and confirmed password.
Transactions
- Represents individual transactions with attributes such as category, amount, transaction name, and date.
SortOption
- Enumerates options for sorting transactions, including newest, oldest, high amount, and low amount.


