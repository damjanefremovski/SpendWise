import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/view.dart';

import 'model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUpController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');


  late BuildContext _context;


  Future<void> signUp(BuildContext context, UserData userData) async {
    _context = context;

    try {

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );


      await _usersCollection.doc(userCredential.user!.uid).set({
        'fullName': userData.fullName,
      });

      print('User registered successfully');


      Navigator.of(_context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print('Error registering user: $e');

    }
  }
}

class FinancialManager {
  static double totalBalance = 0.0;
  static List<Transactions> recentTransactions = [];

  static void addTransaction(Transactions transaction) {
    if (transaction.category == TransactionCategory.earnings) {
      totalBalance += transaction.amount;
    } else if (transaction.category == TransactionCategory.expenses) {
      totalBalance -= transaction.amount;
    }
    recentTransactions.add(transaction);
  }
}

class TransactionController {
  final CollectionReference _transactionsCollection =
  FirebaseFirestore.instance.collection('transactions');

  Future<void> addTransaction(String userId, Transactions transaction) async {
    try {
      await _transactionsCollection.doc(userId).collection('user_transactions').add({
        'category': transaction.category.toString().split('.').last,
        'amount': transaction.amount,
        'transactionName': transaction.transactionName,
        'date': transaction.date,
      });
    } catch (e) {
      print('Error adding transaction: $e');
      throw Exception('Failed to add transaction');
    }
  }
}