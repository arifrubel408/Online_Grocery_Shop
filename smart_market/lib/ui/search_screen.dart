import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search product',
      ),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
decoration: InputDecoration(
hintText: 'Search by exact name with specific letter case',
  hintStyle: TextStyle(
    fontSize: 14.sp,
    color: Colors.grey[400],

  ),
          ),

                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },

              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("products")
                          .where("product-name", isEqualTo: inputText).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Something went wrong"),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Text("Loading"),
                          );
                        }

                        return ListView(
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                            return Card(
                              elevation: 3,
                              child: ListTile(
                                title: Text(data['product-name'],style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.bold),),
                                leading: Image.network(data['product-img']),
                                trailing: Text("Quantiry: "+data['product-quantity'].toString(),style: TextStyle(color: Colors.teal[900],fontWeight: FontWeight.bold),),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
