import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_market/ui/bottom_nav_pages/order_all.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection("order-details")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something is wrong"),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              //snapshot.data == null ? 0 : snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderAll(orderId: _documentSnapshot.id),
                        ),
                      );
                    },
                    leading: Text(
                      (index + 1).toString(),
                      style: TextStyle(color: Colors.teal),
                    ),
                    title: Text(
                      "Order ID: ${_documentSnapshot.id}",
                      style: TextStyle(color: Colors.teal),
                    ),
                    subtitle: Text(
                      'Order Item Count: ' +
                          "${_documentSnapshot['items'].length.toString()}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
