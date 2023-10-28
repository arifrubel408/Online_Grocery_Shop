import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_market/Business-logic/counter.dart';

class FlutterProvider extends StatelessWidget {
  const FlutterProvider({super.key});

  @override
  Widget build(BuildContext context) {

    final _counter = Provider.of<Counter>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: (
        // Column(
        //   children: [
        //     Text(
        //       _counter.value.toString(),
        //       style: TextStyle(
        //       fontSize: 40,
        //     ),
        //     ),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         ElevatedButton(
        //             onPressed: ()=>_counter.increment(),
        //             child: Text("Increment")
        //         ),
        //         ElevatedButton(
        //             onPressed: ()=>_counter.decrement(),
        //             child: Text("Decrement")
        //         ),
        //       ],
        //     ),
        //   ],
        // )
            Row(
              children: [
                Text(
                  _counter.value.toString(),
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // ElevatedButton(
                    //     onPressed: ()=>_counter.increment(),
                    //     child: Text("Increment")
                    // ),
                    IconButton(onPressed: ()=>_counter.increment(),
                        icon: Icon(Icons.add_box_sharp, color: Colors.teal,),),
                    IconButton(onPressed: ()=>_counter.decrement(),
                        icon: Icon(Icons.maximize, color: Colors.red,)),

                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
