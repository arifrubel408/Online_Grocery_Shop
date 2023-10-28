import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_market/const/AppColors.dart';
import 'package:smart_market/ui/order_placed_page.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  List<Map<String, dynamic>> _items = [];
  double _subTotal = 0;
  final double _deliveryCharge = 120;
  double _total = 0;
  double _vat =0;


  @override
  void initState() {
    super.initState();
    _getCartData();
  }

  void _getCartData() async {
    final db = FirebaseFirestore.instance;

    db.collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          _items.add(docSnapshot.data());
          _subTotal += double.parse(docSnapshot["subTotal"]);
        }
        setState(() {
          _vat =  _subTotal * .15;
          _total = _subTotal + _vat +_deliveryCharge;
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void _placeOrder() async {
    final db = FirebaseFirestore.instance;
    await db
        .collection("orders")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("order-details")
        .add({
      "name": _nameController.text,
      "email": _emailController.text,
      "address": _addressController.text,
      "city": _cityController.text,
      "zip": _zipController.text,
      "items": _items,
      "subTotal": _subTotal,
      "deliveryCharge": _deliveryCharge,
      "total": _total,
      "vat": _vat,
    });

    db.collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .get()
        .then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> dd = docSnapshot.data();
          db.collection("users-cart-items")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items").doc(docSnapshot.id).delete();

          DocumentReference docRef = db.collection("products").doc(dd["uid"]);
          db.runTransaction((Transaction transaction) async {
            DocumentSnapshot snapshot = await transaction.get(docRef);
            if (snapshot.exists) {
              dynamic d = snapshot.data()!;
              int currentValue = d["product-stock"] ?? 0;
              int newValue = currentValue - int.parse(dd["qty"]);
              transaction.update(docRef, {"product-stock": newValue});
            }
          });

        }
      },
      onError: (e) => print("Error completing: $e"),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPlacedPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer Information',
                  style: Theme.of(context).textTheme.headline4),
              _buildTextFormField(_emailController, context, 'Email:'),
              _buildTextFormField(_nameController, context, 'Full name:'),
              Text('Delevery Information',
                  style: Theme.of(context).textTheme.headline4),
              _buildTextFormField(_addressController, context, 'Address:'),
              _buildTextFormField(_cityController, context, 'City:'),
              _buildTextFormField(_zipController, context, 'Zip Code:'),
              Text('Order Summery', style: Theme.of(context).textTheme.headline4),
              Column(
                children: [
                  Divider(thickness: 2),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                    padding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vat (15%):',

                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          _vat.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.headline5,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                                style:
                                    TextStyle(color: Colors.white, fontSize: 30),
                              ),
                              Text(
                                _total.toStringAsFixed(2),
                                style: TextStyle(color: Colors.white,fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _placeOrder();
                },
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Buy Now",
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.deep_pink,
                  elevation: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTextFormField(
    TextEditingController controller,
    BuildContext context,
    String labelText,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              labelText,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.only(left: 10),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
