import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CarttotalProvider extends ChangeNotifier {
  double _cartTotal = 0;

  double get cartTotal => _cartTotal;

  CarttotalProvider() {
    updateCarttotal();
  }

  void updateCarttotal() async {
    FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .snapshots()
        .listen((event) {
      _cartTotal = 0;
      for (var doc in event.docs) {
        _cartTotal += double.parse(doc["subTotal"]);
      }
      notifyListeners();
    });
  }
}
