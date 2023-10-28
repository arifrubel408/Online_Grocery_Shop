import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_market/const/AppColors.dart';
import 'package:smart_market/ui/bottom_nav_pages/cart.dart';
import 'package:smart_market/ui/bottom_nav_pages/favourite.dart';
import 'package:smart_market/ui/bottom_nav_pages/flutter-provider.dart';
import 'package:smart_market/ui/bottom_nav_pages/home.dart';
import 'package:smart_market/ui/bottom_nav_pages/order_all.dart';
import 'package:smart_market/ui/bottom_nav_pages/profile.dart';
import 'package:smart_market/ui/login_screen.dart';

class BottomNavController extends StatefulWidget {
  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  final _pages = [
    Home(),
    Favourite(),
    Cart(),
    Profile(),
   // FlutterProvider(),
  ];
  var _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BottomNavController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Smart Market",
          style: TextStyle(color: AppColors.black_pink, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () async{
            final SharedPreferences spr = await SharedPreferences.getInstance();
            await spr.remove('user');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
            LoginScreen(),
            ));
          },
              icon: Icon(Icons.logout, color: Colors.red,)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: AppColors.deep_orang,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
            TextStyle(color: AppColors.black_pink, fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
       label: "Favourite",
    ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
           label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
          label: "Person",
          ),

          // BottomNavigationBarItem(
          //   icon: Icon(Icons.portrait_rounded),
          //   label: "Provider",
          // ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
