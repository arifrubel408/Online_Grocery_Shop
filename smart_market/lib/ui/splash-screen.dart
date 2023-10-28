import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_market/const/AppColors.dart';
import 'package:smart_market/ui/bottom_nav_pages/home.dart';
import 'package:smart_market/ui/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState(){
     Timer(Duration(seconds: 4),() => Navigator.push(context, CupertinoPageRoute(builder: (_)=>LoginScreen())));
    // super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_pink,
      body:SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Smart Market', style: TextStyle(
                color: Colors.white,fontWeight: FontWeight.bold, fontSize: 40.sp,
              ),),
           SizedBox(height: 20.h,),
           CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
