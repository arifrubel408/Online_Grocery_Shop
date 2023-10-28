import 'package:flutter/cupertino.dart';

class Counter extends ChangeNotifier{
  int value =0;

  increment(){
    value = value+1;
    notifyListeners();
  }
  decrement(){
    value = value-1;
    notifyListeners();
  }
}