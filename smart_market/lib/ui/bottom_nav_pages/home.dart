import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_market/const/AppColors.dart';
import 'package:smart_market/ui/search_screen.dart';
import '../product_details_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //link store list
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  List _products = [];

  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn1 = await _firestoreInstance.collection("products").get();
    qn1.docs.forEach((element) {
      print(element);
      _products.add({
        "uid": element.id,
        "name": element["product-name"],
        "description": element["product-description"],
        "price": element["product-price"],
        "stock": element["product-stock"],
        "weight": element["product-weight"],
        "img": element["product-img"],
        "id": element["product-id"],
      });
    });
    print(_products);
  }

  @override
  void initState() {
    fetchCarouselImages();
    fetchProducts();
    super.initState();
  }

  //TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: TextFormField(
                    readOnly: true,
                   // controller: _searchController,
                    decoration: InputDecoration(
                        fillColor: Colors.blue[100],
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                            color: AppColors.black_pink,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(0)),
                          borderSide: BorderSide(
                            color: AppColors.black_pink,
                          ),
                        ),
                        hintText: 'Search products here',
                        hintStyle: TextStyle(fontSize: 17.spMax)),
                    onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (_)=>SearchScreen())),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                AspectRatio(
                  aspectRatio: 3.5,
                  child: CarouselSlider(
                      items: _carouselImages
                          .map((item) => Padding(
                                padding: const EdgeInsets.only(left: 3, right: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(item),
                                          fit: BoxFit.fitWidth)),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          onPageChanged: (val, carouselPageChangedReason) {
                            setState(() {
                              _dotPosition = val;
                            });
                          })),
                ),
                SizedBox(
                  height: 10.h,
                ),
                DotsIndicator(
                  dotsCount:
                      _carouselImages.length == 0 ? 1 : _carouselImages.length,
                  position: _dotPosition.toDouble(),
                  decorator: DotsDecorator(
                    activeColor: AppColors.black_pink,
                    color: AppColors.black_pink.withOpacity(0.5),
                    spacing: EdgeInsets.all(2),
                    activeSize: Size(8, 8),
                    size: Size(6, 6),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     print(_products);
                //     //fetchProducts();
                //   },
                //   child: Text('Print Products'),
                // ),
                Expanded(
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1),
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        //onTap: ()=>print(_products[index]),
                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> ProductDetails(_products[index]))),
                        child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              AspectRatio(
                                  aspectRatio: 2,
                                  child: Container(
                                      color: Colors.lime[100],
                                      child: Image.network(
                                        _products[index]["img"],
                                      ))),
                              Text("${_products[index]["name"]}",style: TextStyle(color: Colors.teal[900],fontWeight: FontWeight.bold
                              )),
                              Text("${'Weight: ' + _products[index]["weight"].toString()}"),
                              Text("${'Price: ' + _products[index]["price"].toString()}"),
                              Text("${'Stock: ' + _products[index]["stock"].toString()}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }
}
