import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'view.dart';
import 'controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spend Wise Navigation',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 3;
  late SignUpController _controller;

  // Extend _widgetOptions to include SignUpPage at index 3
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const BalancePage(),
    const AddTransactionPage(),
    // ignore: non_constant_identifier_names
    SignUpPage(signUpCallback: (UserData ) {  },), // Placeholder for SignUpPage
  ];

  @override
  void initState() {
    super.initState();
    _controller = SignUpController();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Update SignUpPage in _widgetOptions based on _selectedIndex
    // ignore: non_constant_identifier_names
    _widgetOptions[3] = _selectedIndex == 3
        ? SignUpPage(signUpCallback: (userData) {
      _controller.signUp(context, userData);
    })
        : SignUpPage(signUpCallback: (UserData) {});

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spend Wise', style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 24)),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Balance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigoAccent,
        onTap: _onItemTapped,
      ),
    );
  }}