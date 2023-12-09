import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/provider_controller.dart';

class test0 extends StatefulWidget{
  @override
  State<test0> createState() => _test0State();
}

class _test0State extends State<test0> {

  List s = [
    {
      "Item Name":"Fish",
      "Description":"White fish fillet 4 pieces/kg",
      "Image":"fishItem.jpg",
      "Discount": 0,
      "Price": 114.9,
      "Quantity": 5,
      "Rates": [{0:5},{0:0},{0:15},{0:4},{0:5}]
    }
  ];
  var recommendedItemsLiked = [];
  Widget checkSimilarIemsDiscount(int index,var snapshot){
    if(snapshot.data!["Viewed Items"][index]["Discount"] == 0){
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0,top: 5),
            child: Text("${snapshot.data!["Viewed Items"][index]["Price"]} EGP",
            style: Theme.of(context).textTheme.headline4,),
            ),
        ],
      );
    }
    else{
      double value = double.parse((snapshot.data!["Viewed Items"][index]["Price"]-(snapshot.data!["Viewed Items"][index]["Price"] * snapshot.data!["Viewed Items"][index]["Discount"]/100)).toStringAsFixed(2));
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text("${snapshot.data!["Viewed Items"][index]["Price"]} EGP",
                style: const TextStyle(fontFamily: "Lato",fontSize: 15,decoration: TextDecoration.lineThrough),),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0,top: 2),
                child: Text("$value EGP",
                style: Theme.of(context).textTheme.headline4,softWrap: true,),
              ),
            ],
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context);
    var user = FirebaseAuth.instance.currentUser;
    DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: userref.snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!["Viewed Items"].length,
                            itemBuilder: (context, index) {
                            for(int i = 0;i<snapshot.data!["Viewed Items"].length;i++){
                              recommendedItemsLiked.add(false);
                            }
                            return Row(children: [
                              Column(
                                children: [
                                  InkWell(
                                onTap: () async{
                                  
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  width: 170,
                                  height: 330,
                                  decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: Theme.of(context).colorScheme.onPrimary,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 1,
                                                  offset: const Offset(1.5, 1.5),
                                                  spreadRadius: 0.5,
                                                  color: Theme.of(context).shadowColor)
                                            ]),
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(top: 10),
                                                      height: 150,
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          image: DecorationImage(
                                                              image: AssetImage('assets/images/${snapshot.data!["Viewed Items"][index]["Image"]}'),
                                                              fit: BoxFit.cover)),
                                                    ),
                                                  ],
                                                ),
                                                Positioned(  
                                                  child: Container(
                                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                                    child:snapshot.data!["Viewed Items"][index]["Discount"] > 0 ?  Text(
                                                          " - ${snapshot.data!["Viewed Items"][index]["Discount"]}%",
                                                          style:Theme.of(context).textTheme.subtitle2 
                                                        ):Container()
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8),
                                                  child: Text(
                                                        snapshot.data!["Viewed Items"][index]["Quantity"] > 0?"":"Out of stock",
                                                        style: const TextStyle(fontSize: 15.5,color: Color.fromRGBO(198, 48, 48, 1),),
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only( top:8,left: 5,right: 5),
                                              child: Text(
                                                        snapshot.data!["Viewed Items"][index]["Description"],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline3,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                      ),
                                            ),
                                            checkSimilarIemsDiscount(index,snapshot),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              Container(
                                                color:snapshot.data!["Viewed Items"][index]["Quantity"] == 0 ? Colors.grey[350]:const Color.fromRGBO(198, 48, 48, 1),
                                                width: 100,
                                                height: 35,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(onTap: snapshot.data!["Viewed Items"][index]["Quantity"] == 0 ? null :() {
                                                  double value = double.parse((snapshot.data!["Viewed Items"][index]["Price"]-(snapshot.data!["Viewed Items"][index]["Price"] * snapshot.data!["Viewed Items"][index]["Discount"]/100)).toStringAsFixed(2));
                                                  bool foundInCart = provider.cartItems.any((element) => element["Item Name"] == snapshot.data!.get("Item Name"),);
                                              if(!foundInCart){
                                                if(snapshot.data!["Viewed Items"][index]["Discount"] == 0){
                                                    provider.cartItems.add({
                                                      "Item Name":snapshot.data!["Viewed Items"][index]["Item Name"],
                                                      "Image":snapshot.data!["Viewed Items"][index]["Image"],
                                                      "Selected Quantity":provider.defaultQuantity,
                                                      "Price":snapshot.data!["Viewed Items"][index]["Price"],
                                                      "Default Price":snapshot.data!["Viewed Items"][index]["Price"],
                                                      "Total Quantity":snapshot.data!["Viewed Items"][index]["Quantity"],
                                                      });
                                                }
                                                else{
                                                  provider.cartItems.add({
                                                    "Item Name":snapshot.data!["Viewed Items"][index]["Item Name"],
                                                    "Image":snapshot.data!["Viewed Items"][index]["Image"],
                                                    "Selected Quantity":provider.defaultQuantity,
                                                    "Price":value,
                                                    "Default Price":value,
                                                    "Total Quantity":snapshot.data!["Viewed Items"][index]["Quantity"],
                                                  });
                                                  }
                                              }
                                              Fluttertoast.showToast(
                                                    msg: "Successfully added",
                                                    backgroundColor: Colors.black54,
                                                    toastLength:Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM
                                                    );
                                                  },
                                                  child:Center(child: snapshot.data!["Viewed Items"][index]["Quantity"] == 0 ? 
                                                  Text("Sold out",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontSize: MediaQuery.of(context).devicePixelRatio*6),)
                                                  :Text("Add to cart",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontSize: MediaQuery.of(context).devicePixelRatio*5.6),)
                                                  ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(onPressed: (() {
                                                setState(() {
                                                  recommendedItemsLiked[index] = !recommendedItemsLiked[index];
                                                });
                                              })
                                              , icon:Icon(recommendedItemsLiked[index] == false? Icons.favorite_border_outlined:Icons.favorite,color: const Color.fromRGBO(198, 48, 48, 1),size: 30,) )
                                              ],)  
                                            ]
                                ),
                              ))
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                width: 18,
                              )
                            ]);
                            },
              );
            }
            else{
              return const CircularProgressIndicator();
            }
            
          },
        )
      ),
    );
  }
}