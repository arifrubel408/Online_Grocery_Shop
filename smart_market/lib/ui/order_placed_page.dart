import 'package:flutter/material.dart';
import 'package:smart_market/ui/bottom_nav_controller.dart';

class OrderPlacedPage extends StatefulWidget {
  const OrderPlacedPage({super.key});

  @override
  State<OrderPlacedPage> createState() => _OrderPlacedPageState();
}

class _OrderPlacedPageState extends State<OrderPlacedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(

          children: [
            SizedBox(height: 200,),
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 20, 0, 40),
              child: const Center(

                child: Text("Order placed Successfully", style: TextStyle(
                  fontSize: 40,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: ((context) => BottomNavController())));
               // Navigator.pop(context);
              },
              child: Text("Back to Home", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),),
            ),
          ],
        ),

      ),
    );
  }
}
