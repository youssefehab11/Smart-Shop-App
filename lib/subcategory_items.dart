
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:lottie/lottie.dart';
import 'item_details.dart';

class SubCategoryItems extends StatefulWidget{
  @override
  State<SubCategoryItems> createState() => SubCategoryItemsState();
}

class SubCategoryItemsState extends State<SubCategoryItems> {
  
  List<bool> recommendationliked = [];
  
  
  
  Widget checkIemDiscount(int index){
    final provider = ProviderController.of(context);
    if(provider.items[index]["Discount"] == 0){
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0,top: 5),
            child: Text("${provider.items[index]["Price"] } EGP",
            style: Theme.of(context).textTheme.headline4,),
            ),
        ],
      );
    }
    else{
      double value = double.parse((provider.items[index]["Price"]-(provider.items[index]["Price"] * provider.items[index]["Discount"]/100)).toStringAsFixed(2));
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text("${provider.items[index]["Price"] } EGP",
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
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title:  Text(
            provider.subCategoryTitle,
            style: const TextStyle(color: Colors.white, fontSize: 25,fontFamily: "Poppins",fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          //elevation: 0.0,
        ),
        body: StreamBuilder(
          initialData: provider.connectivtyResult,
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if(snapshot.data == ConnectivityResult.wifi || snapshot.data == ConnectivityResult.mobile){
              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 340),

                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  for(int i = 0;i<provider.items.length;i++){
                    recommendationliked.add(false);
                  }
                  return InkWell(
                    onTap: () async{
                      provider.itemName = provider.usedItems[index]["Item Name"];
                      provider.getItemId(provider.itemName);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AnimatedSplashScreen(
                            disableNavigation: true,
                            splashIconSize: 150,
                            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                            splash:
                            Lottie.asset("assets/lotties/1620-simple-dots-loading.json"),
                            animationDuration: const Duration(seconds: 1),
                            nextScreen: itemDetails());
                          },
                       );
                      provider.similarSubcategoriesNames.clear();
                      provider.similarSubcategoriesIds.clear();
                      provider.similarItemsIds.clear();
                      provider.similarItemsData.clear();
                      provider.similarItemsNames = await provider.getSimilarItems(provider.usedItems[index]["Item Name"]);
                       for(int i = 0; i < provider.similarItemsNames.length; i++){
                        await provider.getSimilarSubCategoriesNames(provider.similarItemsNames[i]);
                      }
                       for(int i = 0; i < provider.similarItemsNames.length; i++){
                        await provider.getSimilarSubCategoriesIds(provider.similarSubcategoriesNames[i]);
                      }
                      for(int i = 0; i < provider.similarItemsNames.length; i++){
                        await provider.getSimilarItemsIds(provider.similarSubcategoriesIds[i],provider.similarItemsNames[i]);
                      }
                      for(int i = 0; i < provider.similarItemsNames.length; i++){
                        await provider.getSimilarItemsData(provider.similarSubcategoriesIds[i],provider.similarItemsIds[i]);
                      }
                      provider.recommendedSubcategoriesNames.clear();
                      provider.recommendedSubcategoriesIds.clear();
                      provider.recommendedItemsIds.clear();
                      provider.recommendedItemsData.clear();
                      provider.recommendedItemsNames = await provider.getRecommendedItems(provider.usedItems[index]["Item Name"]);
                       for(int i = 0; i < provider.recommendedItemsNames.length; i++){
                        await provider.getRecommendedSubCategoriesNames(provider.recommendedItemsNames[i]);
                      }
                       for(int i = 0; i < provider.recommendedItemsNames.length; i++){
                        await provider.getRecommendedSubCategoriesIds(provider.recommendedSubcategoriesNames[i]);
                      }
                      for(int i = 0; i < provider.recommendedItemsNames.length; i++){
                        await provider.getRecommendedItemsIds(provider.recommendedSubcategoriesIds[i],provider.recommendedItemsNames[i]);
                      }
                      for(int i = 0; i < provider.recommendedItemsNames.length; i++){
                        await provider.getRecommendedItemsData(provider.recommendedSubcategoriesIds[i],provider.recommendedItemsIds[i]);
                      } 
                      provider.setRecommendedItems(provider.recommendedItemsData);
                       // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(SlideLeftAnimationRoute(Page: itemDetails()));
                     // print(provider.recommendedItemsData);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      width: 150,
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
                                                  image: AssetImage('assets/images/${provider.items[index]["Image"]}'),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ],
                                    ),
                                    Positioned(  
                                      child: Container(
                                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                                        child:provider.items[index]["Discount"] > 0 ?  Text(
                                              " - ${provider.items[index]["Discount"]}%",
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
                                            provider.items[index]["Quantity"] > 0?"":"Out of stock",
                                            style: const TextStyle(fontSize: 15.5,color: Color.fromRGBO(198, 48, 48, 1),),
                                          ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only( top:8,left: 5,right: 5),
                                  child: Text(
                                            provider.items[index]["Description"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                          ),
                                ),
                                checkIemDiscount(index),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Container(
                                    color:provider.items[index]["Quantity"] == 0 ? Colors.grey[350]:const Color.fromRGBO(198, 48, 48, 1),
                                    width: 100,
                                    height: 35,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(onTap: provider.items[index]["Quantity"] == 0 ? null :() {
                                      double value = double.parse((provider.items[index]["Price"]-(provider.items[index]["Price"] * provider.items[index]["Discount"]/100)).toStringAsFixed(2));
                                      bool foundInCart = provider.cartItems.any((element) => element["Item Name"] == provider.items[index]["Item Name"],);
                                  if(!foundInCart){
                                    if(provider.items[index]["Discount"] == 0){
                                        provider.cartItems.add({
                                          "Item Name":provider.items[index]["Item Name"],
                                          "Description":provider.items[index]["Description"],
                                          "Item Images":provider.items[index]["Item Images"],
                                          "Rates":provider.items[index]["Rates"],
                                          "Sales":provider.items[index]["Sales"],
                                          "Default Quantity":provider.items[index]["Default Quantity"],
                                          "Discount":provider.items[index]["Discount"],
                                          "Image":provider.items[index]["Image"],
                                          "Selected Quantity":provider.defaultQuantity,
                                          "Price":provider.items[index]["Price"],
                                          "Default Price":provider.items[index]["Price"],
                                          "Total Quantity":provider.items[index]["Quantity"],
                                          });
                                          
                                    }
                                    else{
                                      provider.cartItems.add({
                                        "Item Name":provider.items[index]["Item Name"],
                                        "Description":provider.items[index]["Description"],
                                        "Item Images":provider.items[index]["Item Images"],
                                        "Rates":provider.items[index]["Rates"],
                                        "Sales":provider.items[index]["Sales"],
                                        "Default Quantity":provider.items[index]["Default Quantity"],
                                        "Discount":provider.items[index]["Discount"],
                                        "Image":provider.items[index]["Image"],
                                        "Selected Quantity":provider.defaultQuantity,
                                        "Price":value,
                                        "Default Price":value,
                                        "Total Quantity":provider.items[index]["Quantity"],
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
                                      child:Center(child: provider.items[index]["Quantity"] == 0 ? 
                                      Text("Sold out",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontSize: MediaQuery.of(context).devicePixelRatio*6),)
                                      :Text("Add to cart",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontSize: MediaQuery.of(context).devicePixelRatio*5.6),)
                                      ),
                                      ),
                                    ),
                                  ),
                                  IconButton(onPressed: (() {
                                    setState(() {
                                      recommendationliked[index] = !recommendationliked[index];
                                    });
                                  })
                                  , icon:Icon(recommendationliked[index] == false? Icons.favorite_border_outlined:Icons.favorite,color: const Color.fromRGBO(198, 48, 48, 1),size: 30,) )
                                  ],)  
                                ]
                    ),
                  ));
                },
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