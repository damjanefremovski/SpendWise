import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model.dart';
import 'controller.dart';

class SignUpPage extends StatefulWidget {
  final Function(UserData) signUpCallback;

  const SignUpPage({Key? key, required this.signUpCallback}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.signUpCallback(UserData(
                  fullName: fullNameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  confirmPassword: confirmPasswordController.text,
                ));
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}


class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController transactionNameController = TextEditingController();
  final TextEditingController transactionAmountController = TextEditingController();
  TransactionCategory _selectedCategory = TransactionCategory.expenses;

  final TransactionController _transactionController = TransactionController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(
              controller: transactionNameController,
              labelText: 'Transaction Name',
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Transaction Category:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton<TransactionCategory>(
                    value: _selectedCategory,
                    onChanged: (TransactionCategory? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      }
                    },
                    items: TransactionCategory.values.map((TransactionCategory category) {
                      return DropdownMenuItem<TransactionCategory>(
                        value: category,
                        child: Text(
                          category.toString().split('.').last,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInputField(
              controller: transactionAmountController,
              labelText: 'Transaction Amount',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Transactions transaction = Transactions(
                  category: _selectedCategory,
                  amount: double.parse(transactionAmountController.text),
                  transactionName: transactionNameController.text,
                  date: DateTime.now(),
                );

                try {
                  await _transactionController.addTransaction(
                    FirebaseAuth.instance.currentUser!.uid,
                    transaction,
                  );

                  FinancialManager.addTransaction(transaction);

                  transactionNameController.clear();
                  transactionAmountController.clear();
                } catch (e) {

                  print('Error adding transaction: $e');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add transaction')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                textStyle: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              child: const Text('Add Transaction', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            const CreditCardBalanceWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.purple),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          const Icon(Icons.attach_money, color: Colors.purple),
          const SizedBox(width: 10),
          Flexible(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreditCardBalanceWidget extends StatelessWidget {
  const CreditCardBalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
          const SizedBox(height: 50),

          Text(
            '\$${FinancialManager.totalBalance.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}





class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data!.exists) {
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final fullName = data['fullName'] as String?;
                    return Text(
                      'Welcome back, ${fullName ?? 'User'}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return Text('Welcome Back!');
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            const CreditCardBalanceWidget(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTransactionPage()),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 5),
                  Text('Add Transaction'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: FinancialManager.recentTransactions.length,
                itemBuilder: (context, index) {
                  Transactions transaction = FinancialManager.recentTransactions[index];
                  return ListTile(
                    title: Text(transaction.transactionName),
                    subtitle: Text(transaction.date.toString()),
                    trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {

              },
              child: const Text('See All'),
            ),
          ],
        ),
      ),
    );
  }
}

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {

  TransactionCategory _selectedCategory = TransactionCategory.expenses;
  SortOption _selectedSortOption = SortOption.newest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CreditCardBalanceWidget(),
          const SizedBox(height: 20),
          _buildFilterSection(),
          const SizedBox(height: 20),
          _buildTransactionList(),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<TransactionCategory>(
          value: _selectedCategory,
          onChanged: (TransactionCategory? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
          items: TransactionCategory.values.map((category) {
            return DropdownMenuItem<TransactionCategory>(
              value: category,
              child: Text(category.toString().split('.').last),
            );
          }).toList(),
        ),
        DropdownButton<SortOption>(
          value: _selectedSortOption,
          onChanged: (SortOption? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSortOption = newValue;
              });
            }
          },
          items: SortOption.values.map((option) {
            return DropdownMenuItem<SortOption>(
              value: option,
              child: Text(option.toString().split('.').last),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTransactionList() {

    List<Transactions> filteredTransactions = FinancialManager.recentTransactions
        .where((transaction) => transaction.category == _selectedCategory)
        .toList();


    switch (_selectedSortOption) {
      case SortOption.newest:
        filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.oldest:
        filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.highAmount:
        filteredTransactions.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortOption.lowAmount:
        filteredTransactions.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }


    return Expanded(
      child: ListView.builder(
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          Transactions transaction = filteredTransactions[index];
          return ListTile(
            title: Text(transaction.transactionName),
            subtitle: Text(transaction.date.toString()), // Customize as needed
            trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
