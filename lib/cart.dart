import 'dart:convert';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/checkout.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget{
   const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}
  var user = FirebaseAuth.instance.currentUser;
  DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
class _CartState extends State<Cart> {

  List budgetRecommendation = [];
  int usedIndex = 0;
  bool foundInCart = false;
  double value = 0;
  String foundedItemInCart = "";
  double defaultPrice = 0;


  Future<List> getBudgetRecommendation(String itemName)async{
    List x = [];
    var url = Uri.https('smartapplication.pythonanywhere.com', '/recbudget/10/$itemName');
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    x.addAll(responseBody);
    print("====================== Budget Recommendation ==============================");
    print(x);
    return x;
  }

  Widget comparePrice(int index, var snapshot){
    final provider = ProviderController.of(context);
    defaultPrice = provider.cartItems[usedIndex]["Price"] / provider.cartItems[usedIndex]["Selected Quantity"];
    if(snapshot.data!.docs[index]["Price"] < defaultPrice){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.green,
            child: const Text("Recommended",style: TextStyle(color: Colors.black),),
          )
      ],);
    }
    else{
      return Container();
    }
  }

  Widget setPrice(int index){
    final provider = ProviderController.of(context);
    double value = double.parse((provider.cartItems[index]["Price"]).toStringAsFixed(2));
    return Padding(
      padding: const EdgeInsets.only(left:20),
      child: Text("$value EGP",
      style: Theme.of(context).textTheme.headline2,),
    );
  }

  Widget getSubTotal(){
    final provider = ProviderController.of(context);
    double subtotal = 0;
    provider.cartItems.forEach((element) {
      subtotal += element["Price"];
    });
    subtotal = double.parse((subtotal).toStringAsFixed(2));
    provider.subtotal = double.parse((subtotal).toStringAsFixed(2));
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 8),
      child: Text("$subtotal EGP",style: Theme.of(context).textTheme.headline2,),
    );
  }

  Widget checkBudget(){
    final provider = ProviderController.of(context);
    if(provider.budget == 0){
      return Container();
    }
    else if(provider.subtotal+20 > provider.budget){
      return const Padding(
        padding: EdgeInsets.only(bottom:10.0),
        child: Text("Total price is heigher than your budget we recommended items for your budget, see our recommendation from save money",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    else{
      return Container();
    }
  }

  Widget checkIemDiscount(int index,var snapshot){
    if(snapshot.data!.docs[index]["Discount"] == 0){
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0,top: 5),
            child: Text("${snapshot.data!.docs[index]["Price"] } EGP",
            style: Theme.of(context).textTheme.headline4,),
            ),
        ],
      );
    }
    else{
      double value = double.parse((snapshot.data!.docs[index]["Price"]-(snapshot.data!.docs[index]["Price"] * snapshot.data!.docs[index]["Discount"]/100)).toStringAsFixed(2));
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text("${snapshot.data!.docs[index]["Price"] } EGP",
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
  
  Widget setBudgetRecommendation(int index){
    final provider = ProviderController.of(context);
    if(provider.budget == 0){
      return Container();
    }
    else if(provider.subtotal+20 > provider.budget){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        Padding(
          padding:const EdgeInsets.only(right: 8,top:8),
          child: InkWell(
            onTap: () async{
              usedIndex = provider.cartItems.indexWhere((element) => element["Item Name"] == provider.cartItems[index]["Item Name"]);
                  showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AnimatedSplashScreen(
                            disableNavigation: true,
                            splashIconSize: 150,
                            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                            splash:
                            Lottie.asset("assets/lotties/1620-simple-dots-loading.json"),
                            animationDuration: const Duration(seconds: 2),
                            splashTransition: SplashTransition.fadeTransition,
                            nextScreen: const Cart());
                          },
                       );
                       await provider.getSubCategoryNameForBudgetRecommendation(provider.cartItems[index]["Item Name"]);
                       await provider.getSubCategoryIdForBudgetRecommenadtion(provider.subCategoryNameForBudgetRecommendation);
                       budgetRecommendation = await getBudgetRecommendation(provider.cartItems[index]["Item Name"]);
                       CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList").doc(provider.subCategoryId).collection("Items");
                       // ignore: use_build_context_synchronously
                       Navigator.pop(context);

              // ignore: use_build_context_synchronously
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                )),
                context: context,
                 builder:(context) {
                   return StreamBuilder(
                    stream: collectionReference.where("Item Name", whereIn: budgetRecommendation).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        return GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 380,crossAxisSpacing: 8,mainAxisSpacing: 8),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      offset: const Offset(1.5, 1.5),
                                      spreadRadius: 0.5,
                                      color: Theme.of(context).shadowColor)
                                ]
                              ),
                              child: Column(
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
                                                  image: AssetImage('assets/images/${snapshot.data!.docs[index]["Image"]}'),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ],
                                    ),
                                    Positioned(  
                                      child: Container(
                                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                                        child:snapshot.data!.docs[index]["Discount"] > 0 ?  Text(
                                              " - ${snapshot.data!.docs[index]["Discount"]}%",
                                              style:Theme.of(context).textTheme.subtitle2 
                                            ):Container()
                                      ),
                                    ),
                                    comparePrice(index,snapshot),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                            snapshot.data!.docs[index]["Quantity"] > 0?"":"Out of stock",
                                            style: const TextStyle(fontSize: 15.5,color: Color.fromRGBO(198, 48, 48, 1),),
                                          ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top:8,),
                                      child: Text(
                                        snapshot.data!.docs[index]["Item Name"],
                                        style: Theme.of(context).textTheme.headline4,maxLines: 2,overflow: TextOverflow.ellipsis,
                                        ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top:2,left: 5,right: 5),
                                  child: Text(
                                    snapshot.data!.docs[index]["Description"],
                                    style: Theme.of(context).textTheme.headline3,maxLines: 2,overflow: TextOverflow.ellipsis,
                                    ),
                                ),
                                checkIemDiscount(index,snapshot),
                                    MaterialButton(onPressed: snapshot.data!.docs[index]["Quantity"] == 0? null : (){
                                       value = double.parse((snapshot.data!.docs[index]["Price"]-(snapshot.data!.docs[index]["Price"] * snapshot.data!.docs[index]["Discount"]/100)).toStringAsFixed(2));
                                       foundInCart = provider.cartItems.any((element) {
                                        if(element["Item Name"] == snapshot.data!.docs[index]["Item Name"]){
                                          foundedItemInCart = element["Item Name"];
                                          print("Founded in cart");
                                          print("Founded Item name: $foundedItemInCart");
                                          return true;
                                        }
                                        else{
                                          return false;
                                        }
                                      },);
                                      if(!foundInCart){
                                        setState(() {
                                        provider.cartItems.removeAt(usedIndex);
                                        if(snapshot.data!.docs[index]["Discount"] == 0){
                                          provider.cartItems.insert(usedIndex,{
                                            "Item Name":snapshot.data!.docs[index]["Item Name"],
                                            "Description":snapshot.data!.docs[index]["Description"],
                                            "Item Images":snapshot.data!.docs[index]["Item Images"],
                                            "Rates":snapshot.data!.docs[index]["Rates"],
                                            "Sales":snapshot.data!.docs[index]["Sales"],
                                            "Default Quantity":snapshot.data!.docs[index]["Default Quantity"],
                                            "Discount":snapshot.data!.docs[index]["Discount"],
                                            "Image":snapshot.data!.docs[index]["Image"],
                                            "Selected Quantity":provider.defaultQuantity,
                                            "Price":snapshot.data!.docs[index]["Price"],
                                            "Default Price":snapshot.data!.docs[index]["Price"],
                                            "Total Quantity":snapshot.data!.docs[index]["Quantity"],
                                            });
                                          Fluttertoast.showToast(
                                            msg: "Successfully swaped",
                                            backgroundColor: Colors.black54,
                                            toastLength:Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM
                                            );
                                        }
                                        else{
                                          provider.cartItems.insert(usedIndex,{
                                            "Item Name":snapshot.data!.docs[index]["Item Name"],
                                            "Description":snapshot.data!.docs[index]["Description"],
                                            "Item Images":snapshot.data!.docs[index]["Item Images"],
                                            "Rates":snapshot.data!.docs[index]["Rates"],
                                            "Sales":snapshot.data!.docs[index]["Sales"],
                                            "Default Quantity":snapshot.data!.docs[index]["Default Quantity"],
                                            "Discount":snapshot.data!.docs[index]["Discount"],
                                            "Image":snapshot.data!.docs[index]["Image"],
                                            "Selected Quantity":provider.defaultQuantity,
                                            "Price":value,
                                            "Default Price":value,
                                            "Total Quantity":snapshot.data!.docs[index]["Quantity"],
                                          });
                                          Fluttertoast.showToast(
                                            msg: "Successfully swaped",
                                            backgroundColor: Colors.black54,
                                            toastLength:Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM
                                            );
                                          }
                                        });
                                      }
                                      else{
                                        setState(() {
                                          for(int i = 0; i < provider.cartItems.length; i++){
                                            if(provider.cartItems[i]["Item Name"] == foundedItemInCart){
                                              provider.cartItems[i]["Selected Quantity"] ++;
                                              provider.cartItems[index]["Price"] = provider.cartItems[index]["Default Price"] 
                                              * provider.cartItems[index]["Selected Quantity"];
                                              provider.cartItems.removeAt(usedIndex);
                                              Fluttertoast.showToast(
                                                msg: "Successfully swaped",
                                                backgroundColor: Colors.black54,
                                                toastLength:Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM
                                              );
                                            }
                                          }
                                        });
                                      }
                                      
                                    },
                                    color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                                    textColor: Colors.white,
                                    child: const Text("Swap Item",style: TextStyle(fontFamily: "Lato",fontSize: 17),),)
                              ],),
                            );
                        },);
                      }
                      else{
                        return Container();
                      }
                    },);
                 },
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text("Save Money",style: TextStyle(
                    decoration: TextDecoration.underline,
                    color:Color.fromRGBO(198, 48, 48, 1),
                  )),
                ),
              ],
            ),
          ),
        )
      ],);
    }
    else{
      return Container();
    }
  }



  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context);
    return Scaffold(
      appBar:AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Cart",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
          body: StreamBuilder(
            initialData: provider.connectivtyResult,
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if(snapshot.data == ConnectivityResult.wifi || snapshot.data == ConnectivityResult.mobile){
                return provider.cartItems.isEmpty? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  height: 300,
                  child: const Image(image: AssetImage('assets/images/Empty Cart.jpg'),)) ,
                const Text("Your cart is empty!",style: TextStyle(fontSize: 16),),
              ],
            ),
          )
          : ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
            padding: const EdgeInsets.only(left: 10, top: 5),
            width: double.infinity,
            height: 30,
            color: Theme.of(context).colorScheme.onBackground,
            child: const Text(
              "CART SUMMARY",
              style: TextStyle(
               fontSize: 15,
               fontWeight: FontWeight.bold,
               fontFamily: "Lato",),
            )
          ), 
          
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 30),
               child: SizedBox(
                child: Row(
                  children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8,bottom: 8 ),
                              child: Text("Subtotal",style: Theme.of(context).textTheme.headline4,),
                            ),
                            const SizedBox(width: 8,),
                            getSubTotal(),
                          ],
                        ),
                        checkBudget(),
                        
                      ],
                    ),
                  ),  
                ],),
                         ),
             ),
          
          Padding(
            padding: const EdgeInsets.only(left: 10,bottom: 10,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width-80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color:const Color.fromRGBO(198, 48, 48, 1)),
                    child: Material(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      color: Colors.transparent,
                      child: InkWell(onTap:() {
                        userref.update({"Custom Country":""});
                        userref.update({"Custom City":""});
                        userref.update({"Custom Subcity":""});
                        userref.update({"Custom Street":""});
                        userref.update({"Custom Thoroughfare":""});
                        provider.customAddressFlag = false;
                        provider.cardNumber = "";
                        provider.expiryDate ="";
                        provider.cardHolderName ="";
                        provider.cvvCode ="";
                        provider.checkConnectivity();
                        Navigator.of(context).push(SlideLeftAnimationRoute(Page: const Checkout()));
                      },
                       customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const Icon(Icons.shopping_cart_checkout_outlined,color: Colors.white,),
                          const SizedBox(width: 8,),
                          const Text("Proceed to buy ",
                          style: TextStyle(fontFamily: "Poppins",fontSize: 17,color: Colors.white),),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text("(Items: ${provider.cartItems.length})",
                            style: const TextStyle(fontFamily: "Poppins",fontSize: 14,color: Colors.white),),
                          )
                        ],)
                          ),
                    ),
                 ),
              ],
            ),
          ),
              Container(
            padding: const EdgeInsets.only(left: 10, top: 5),
            width: double.infinity,
            height: 30,
            color: Theme.of(context).colorScheme.onBackground,
            child: Row(children: [
               const Text(
              "CART",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lato",),
            ),
            const SizedBox(width: 5,),
            Text("(${provider.cartItems.length})")
            ],)
          ),
              ListView.builder( 
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.cartItems.length,
                    itemBuilder: (context, index) {
                    return Dismissible(
                      key: ValueKey(provider.cartItems[index]),
                      direction: DismissDirection.endToStart,
                      onDismissed: ((direction) {
                        setState(() {
                          provider.cartItems.removeAt(index);
                        });
                      }),
                      background: Container(
                        height: 72,
                        color: const Color.fromRGBO(198, 48, 48, 1),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              trailing: Icon(
                              Icons.delete_rounded,
                              size: 30,
                              color: Colors.white,
                              ),
                       ),
                          ],
                        )),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10,left: 10),
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/${provider.cartItems[index]["Image"]}'),
                                      fit: BoxFit.cover)),
                                ),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      setBudgetRecommendation(index),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20,top: 5),
                                      child: Text(provider.cartItems[index]["Item Name"],
                                      style: Theme.of(context).textTheme.headline2,),
                                    ),
                                    
                                    setPrice(index),
                                    Row(children: [
                                      Container(
                                      margin: const EdgeInsets.all(6),
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      color: provider.cartItems[index]["Selected Quantity"] == 1 ? Colors.grey:const Color.fromRGBO(198, 48, 48, 1),),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: provider.cartItems[index]["Selected Quantity"] == 1 ? null : () {
                                            setState(() {
                                              provider.cartItems[index]["Selected Quantity"]--;
                                              provider.cartItems[index]["Price"] = provider.cartItems[index]["Default Price"] 
                                              * provider.cartItems[index]["Selected Quantity"];
                                            });
                                          },
                                          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        child:  const Center(child: Icon(Icons.remove,color: Colors.white,size: 18,))),
                                      ),
                                    ),
                                    Container(
                                      width: 150,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(color: Colors.grey)),
                                      child: Center(child: Text("Qty: ${provider.cartItems[index]["Selected Quantity"].toString()}",style:Theme.of(context).textTheme.bodyText1))),
                                    Container(
                                      margin: const EdgeInsets.all(6),
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      color: provider.cartItems[index]["Selected Quantity"] == provider.cartItems[index]["Total Quantity"]  ? Colors.grey:const Color.fromRGBO(198, 48, 48, 1),),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: provider.cartItems[index]["Selected Quantity"] == provider.cartItems[index]["Total Quantity"] ? null : () {
                                            setState(() {
                                              provider.cartItems[index]["Selected Quantity"]++;
                                              provider.cartItems[index]["Price"] = provider.cartItems[index]["Default Price"] 
                                              * provider.cartItems[index]["Selected Quantity"];
                                            });
                                            
                                          },
                                          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                        child:  const Center(child: Icon(Icons.add,color: Colors.white,size: 18,))),
                                      ),
                                    ),
                                    ],)
                                  ],),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
                            child: Container(
                              width: double.infinity,
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    );
                  },),
            ],
          );
              }
              else{
                return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(image: AssetImage("assets/images/No Connection.jpg")),
                ),
                SizedBox(height: 10,),
                Text("Whoops!",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                SizedBox(height: 5,),
                Text("No internet connection found! check your connection please.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),)
              ],
            );
              }
            },
          )
    );
  }
}