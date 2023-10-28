import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_market/const/AppColors.dart';
import 'package:smart_market/ui/bottom_nav_controller.dart';
import 'package:smart_market/widgets/myTextField.dart';

class UserFormScreen extends StatefulWidget {
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {


  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];


  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }
  sendUserDataToDB()async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var  currentUser = _auth.currentUser;
    CollectionReference _collectionRef = FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(currentUser!.email).set({
      "name":_nameController.text,
      "phone":_phoneController.text,
      "dob":_dobController.text,
      "gender":_genderController.text,
      "age":_ageController.text,

    }).then((value) => Navigator.push(context, MaterialPageRoute(
        builder: (_)=>BottomNavController()))).catchError((error)=>print("something is wrong. $error"));
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(110, 0, 40, 0),
                  //   child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF9glqBG7DZR0bXeFYtfohLrpAcxTiXavYYQ&usqp=CAU",
                  //     height: 150, width: 150,
                  //   ),
                  // ),
                Center(
                  child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQF9glqBG7DZR0bXeFYtfohLrpAcxTiXavYYQ&usqp=CAU',

                    ),
                  ),
              ),
                ),

                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Submit the form to continue.",
                    style:
                    TextStyle(fontSize: 22.sp, color: AppColors.black_pink),
                  ),
                  Text(
                    "We will not share your information with anyone.",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFFBBBBBB),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  // TextField(
                  //   keyboardType: TextInputType.text,
                  //   controller: _nameController,
                  //   decoration: InputDecoration(hintText: "enter your name"),
                  // ),
                  // TextField(
                  //   keyboardType: TextInputType.number,
                  //   controller: _phoneController,
                  //   decoration:
                  //   InputDecoration(hintText: "enter your phone number"),
                  // ),
                   myTextField(
                      "enter your name", TextInputType.text, _nameController),
                   myTextField("enter your phone number", TextInputType.number,
                      _phoneController),
                  TextField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "date of birth",
                      suffixIcon: IconButton(
                        onPressed: () => _selectDateFromPicker(context),
                        icon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _genderController,
                    readOnly: true,
                    decoration: InputDecoration(
                      label: Text('Gender:'),
                      hintText: "choose your gender",
                      prefixIcon: DropdownButton<String>(
                        items: gender.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                            onTap: () {
                              setState(() {
                                _genderController.text = value;
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  // TextField(
                  //   keyboardType: TextInputType.number,
                  //   controller: _ageController,
                  //   decoration: InputDecoration(hintText: "enter your age"),
                  // ),
                   myTextField(
                     "enter your age", TextInputType.number, _ageController),

                  SizedBox(
                    height: 50.h,
                  ),

                  // elevated button
                  SizedBox(
                    width: 1.sw,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        sendUserDataToDB();
                        Fluttertoast.showToast(msg: "Successfully submitted the form.",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP_LEFT,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.black_pink,
                        elevation: 3,
                      ),
                    ),
                  ),
                 // customButton("Continue", () => sendUserDataToDB()),
                ],
              ),
            ),
          ),
        ),
      );
    }
}
