import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/Business-logic/carttotal_provider.dart';
import 'package:smart_market/const/AppColors.dart';
import 'package:smart_market/ui/check_out.dart';



class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    double cartTotal = 0;

    void calcCartTotal() {
      final docRef = FirebaseFirestore.instance
          .collection("users-cart-items")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("items");
      docRef.get().then((QuerySnapshot doc) => {
            for (var docSnapshot in doc.docs)
              {cartTotal += double.parse(docSnapshot["subTotal"])}
          });
    }

    return Scaffold(

      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-cart-items")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if (snapshot.hasError) {
              return const Center(
                child: Text("Something is wrong"),
              );
            }
            return ListView.builder(
                itemCount:
                    snapshot.data == null ? 0 : snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot _documentSnapshot =
                      snapshot.data!.docs[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Image.network(
                        "${_documentSnapshot['img']}",
                        height: 50,
                        width: 50,
                      ),
                      title: Text(
                        _documentSnapshot['name'],
                        style: const TextStyle(color: Colors.teal),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            'Price: ' + "${_documentSnapshot['price']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              int q = int.parse(_documentSnapshot['qty']);
                              if (q > 1) {
                                q--;
                                int s = _documentSnapshot['price'] * q;
                                FirebaseFirestore.instance
                                    .collection("users-cart-items")
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .collection("items")
                                    .doc(_documentSnapshot.id)
                                    .update({
                                  "qty": q.toString(),
                                  "subTotal": s.toString()
                                });
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            _documentSnapshot['qty'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () {
                              int q = int.parse(_documentSnapshot['qty']) + 1;
                              int s = _documentSnapshot['price'] * q;
                              FirebaseFirestore.instance
                                  .collection("users-cart-items")
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection("items")
                                  .doc(_documentSnapshot.id)
                                  .update({
                                "qty": q.toString(),
                                "subTotal": s.toString()
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _documentSnapshot['subTotal'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("users-cart-items")
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .collection("items")
                                  .doc(_documentSnapshot.id)
                                  .delete();
                            },
                            icon: const Icon(Icons.delete, size: 30),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                child: ListTile(
              title: Text(
                "Total:",
                style: TextStyle(fontSize: 20, color: Colors.teal),
              ),
              subtitle: Consumer<CarttotalProvider>(
                builder: (context, value, child) {
                  return Text(
                    '${value.cartTotal.toString()} tk',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 25,
                    ),
                  );
                },
              ),
            )),
            Expanded(
                child: MaterialButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const CheckOut())));
              },
              color: AppColors.deep_pink,
              child: const Text(
                "Check Out",
                style: TextStyle(color: Colors.white),

              ),
            ))
          ],
        ),
      ),
    );
  }
}
