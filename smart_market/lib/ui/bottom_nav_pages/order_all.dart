import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_market/const/AppColors.dart';

class OrderAll extends StatefulWidget {
  final String orderId;

  const OrderAll({super.key, required this.orderId});

  @override
  State<OrderAll> createState() => _OrderAllState();
}

class _OrderAllState extends State<OrderAll> {
  final TextEditingController _addressController = TextEditingController();

  String _name = "";
  String _address = "";
  List<Map<String, dynamic>> _items = [];
  double _subTotal = 0;
  double _deliveryCharge = 0;
  double _total = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("order-details")
        .doc(widget.orderId)
        .get()
        .then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        _name = data["name"];
        _address = data["address"];
        _addressController.text = data["address"];
        _subTotal = data["subTotal"];
        _deliveryCharge = data["deliveryCharge"];
        _total = data["total"];
        for(Map<String, dynamic> item in data["items"]) {
          _items.add(item);
        }
        setState(() {

        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        centerTitle: true,
        title: Text("Check Out Details",

        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 0)),
                  Text(
                    'Order :',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      _name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      'Address: ',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      _address,
                      style: Theme.of(context).textTheme.headline5,
                    )
                  ],
                ),

                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                //   child: TextField(
                //     decoration: InputDecoration(
                //         border: OutlineInputBorder(), labelText: 'Address:'),
                //   ),
                // ),
                // Center(
                //   child: Card(
                //     child: SizedBox(
                //       width: 380,
                //       height: 70,
                //
                //       child: Center(child: Text('Elevated Card')),
                //     ),
                //   ),
                // ),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_items[index]["name"]),
                    subtitle: Text("${_items[index]["price"].toString()} x ${_items[index]["qty"]}"),
                    trailing: Text(_items[index]["subTotal"]),
                  );
                },),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Divider(thickness: 2),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal:',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(
                              _subTotal.toString(),
                              style: Theme.of(context).textTheme.headline5,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Charge:',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(
                              _deliveryCharge.toString(),
                              style: Theme.of(context).textTheme.headline5,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(50),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width - 10,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total =',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                  Text(
                                    _total.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
