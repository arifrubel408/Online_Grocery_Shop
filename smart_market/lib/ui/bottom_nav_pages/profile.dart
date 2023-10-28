import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_market/ui/orders.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nameController = TextEditingController();
  TextEditingController? _phoneController = TextEditingController();
  TextEditingController? _dobController = TextEditingController();
  TextEditingController? _genderController = TextEditingController();
  TextEditingController? _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  setDataToTextField(data) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Name:'),
          controller: _nameController = TextEditingController(text: data['name']),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Mobile No:'),
          controller: _phoneController =
              TextEditingController(text: data['phone']),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Gender'),
          controller: _genderController =
              TextEditingController(text: data['gender']),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Date of Birth:'),
          controller: _dobController = TextEditingController(text: data['dob']),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Age'),
          controller: _ageController = TextEditingController(text: data['age']),
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(onPressed: () => updateData(), child: Text("Update"))
      ],
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
      "gender": _genderController!.text,
      "dob": _dobController!.text
    }).then((value) => print("Updated Successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Name'),
              accountEmail: Text("sundar@appmaking.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/47.jpg"),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://appmaking.co/wp-content/uploads/2021/08/android-drawer-bg.jpeg",
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text("Profile"),
              onTap: () {

              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Orders(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.grid_3x3_outlined),
            //   title: Text("Products"),
            //   onTap: () {},
            // ),

          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [


              SizedBox(height: 25,),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users-form-data")
                    .doc(FirebaseAuth.instance.currentUser!.email)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  var data = snapshot.data;
                  if (data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return setDataToTextField(data);
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
