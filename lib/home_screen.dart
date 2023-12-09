
// ignore_for_file: avoid_print

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/item_details.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/recommended_items.dart';
import 'package:graduationproject/search.dart';
import 'package:graduationproject/shopping_list.dart';
import 'package:graduationproject/top_selling.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  List recommendedItemsLiked = [];
  List topSellingLiked = [];
  List offerImages = ["assets/images/Cakes.jpg", "assets/images/Chocolates.jpg"];

  Widget checkRecommendedIemsDiscount(int index,var snapshot){
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

  Widget checkTopSellingIemsDiscount(int index,var snapshot){
    if(snapshot.data!.docs[index]["Discount"] == 0){
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0,top: 5),
            child: Text("${snapshot.data!.docs[index]["Price"]} EGP",
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
                child: Text("${snapshot.data!.docs[index]["Price"]} EGP",
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

  Widget checkRecommendedForYouAvailability(){
    final provider = ProviderController.of(context);
    var user = FirebaseAuth.instance.currentUser;
    DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    return StreamBuilder(
      stream: userref.snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          if(snapshot.data!.get("Viewed Items").length == 0){
            return Container();
          }
          else{
            return Column(
              children: [
                Container(
              margin: const EdgeInsets.only(
                top: 35,
              ),
              padding: const EdgeInsets.only(left: 10),
              width: double.infinity,
              height: 40,
              color: Theme.of(context).colorScheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Recommended For You",
                      style: Theme.of(context).textTheme.headline2),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextButton(
                        onPressed: () {
                          provider.checkConnectivity();
                          Navigator.of(context).push(SlideLeftAnimationRoute(Page: RecommendedItems()));
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            color: Color.fromRGBO(198, 48, 48, 1),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  )
                ],
              )),
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 1, right: 15),
                  height: 350,
                  child: StreamBuilder(
          stream: userref.snapshots(),
          builder: (context, snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!["Viewed Items"].length > 8? 8 : snapshot.data!["Viewed Items"].length,
                                itemBuilder: (context, index) {
                                for(int i = 0;i<snapshot.data!["Viewed Items"].length;i++){
                                  recommendedItemsLiked.add(false);
                                }
                                return Row(children: [
                                  Column(
                                    children: [
                                      InkWell(
                                    onTap: () async{
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
                           provider.itemName = snapshot.data!["Viewed Items"][index]["Item Name"];
                                      await provider.getRecommendedSubCategoryName(provider.itemName);
                                      await provider.getRecommendedSubCategoryId(provider.recommendedSubCategoryName);
                                      await provider.getRecommendedItemId();
                                      await provider.getItemDetail();
                                       provider.similarSubcategoriesNames.clear();
                                      provider.similarSubcategoriesIds.clear();
                                      provider.similarItemsIds.clear();
                                      provider.similarItemsData.clear();
                                      provider.similarItemsNames = await provider.getSimilarItems(provider.itemName);
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
                                      provider.recommendedItemsNames = await provider.getRecommendedItems(provider.itemName);
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
                                      provider.checkConnectivity();
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).push(SlideLeftAnimationRoute(Page: itemDetails()));
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
                                                checkRecommendedIemsDiscount(index,snapshot),
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
                                                      bool foundInCart = provider.cartItems.any((element) => element["Item Name"] == snapshot.data!["Viewed Items"][index]["Item Name"],);
                                                  if(!foundInCart){
                                                    if(snapshot.data!["Viewed Items"][index]["Discount"] == 0){
                                                        provider.cartItems.add({
                                                          "Item Name":snapshot.data!["Viewed Items"][index]["Item Name"],
                                                          "Description":snapshot.data!["Viewed Items"][index]["Description"],
                                                          "Item Images":snapshot.data!["Viewed Items"][index]["Item Images"],
                                                          "Rates":snapshot.data!["Viewed Items"][index]["Rates"],
                                                          "Sales":snapshot.data!["Viewed Items"][index]["Sales"],
                                                          "Default Quantity":snapshot.data!["Viewed Items"][index]["Default Quantity"],
                                                          "Discount":snapshot.data!["Viewed Items"][index]["Discount"],
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
                                                        "Description":snapshot.data!["Viewed Items"][index]["Description"],
                                                        "Item Images":snapshot.data!["Viewed Items"][index]["Item Images"],
                                                        "Rates":snapshot.data!["Viewed Items"][index]["Rates"],
                                                        "Sales":snapshot.data!["Viewed Items"][index]["Sales"],
                                                        "Default Quantity":snapshot.data!["Viewed Items"][index]["Default Quantity"],
                                                        "Discount":snapshot.data!["Viewed Items"][index]["Discount"],
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
                  return  Container();
                }
                
          },
        )),
              ],
            );
          }
        }
        else{
          return Container();
        }
    },);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context);
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("TopSelling");
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        automaticallyImplyLeading: false,
        //elevation: 0.0,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(top: 15, left: 7, right: 3.5),
                                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                         ),
                      child: InkWell(
                        onTap: () {
                          provider.checkConnectivity();
                          showSearch(context: context, delegate: SearchItems());
                        },
                        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding:  EdgeInsets.all(8.0),
                          child: Row(
                          children: [
                             Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                             SizedBox(
                              width: 5,
                            ),
                             Text(
                              "Find Product",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                          ),
                        ),
                      ),
                    )),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 3.5, right: 7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  height: 50,
                  width: 50,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(ScaleAnimationRoute(Page: ShoppingList()));
                      },
                      child: const Icon(
                        Icons.list_alt_rounded,
                        color: Colors.black87,
                        size: 25,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
      body: StreamBuilder(
        initialData: provider.connectivtyResult,
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if(snapshot.data == ConnectivityResult.wifi || snapshot.data == ConnectivityResult.mobile){
            return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          CarouselSlider(
              items: [Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 6.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image:  const DecorationImage(
                          image: AssetImage("assets/images/ElDoha.jpg"),
                          fit: BoxFit.cover)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 6.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image:  const DecorationImage(
                          image: AssetImage("assets/images/Rehana.jpg"),
                          fit: BoxFit.cover)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 6.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image:  const DecorationImage(
                          image: AssetImage("assets/images/Lamar.jpg"),
                          fit: BoxFit.cover)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 6.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image:  const DecorationImage(
                          image: AssetImage("assets/images/Juhayna.jpg"),
                          fit: BoxFit.cover)),
                ),
              ],
              options: CarouselOptions(
                  height: 180.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration:
                      const Duration(milliseconds: 800))),
          Container(
              margin: const EdgeInsets.only(top: 25),
              padding: const EdgeInsets.only(left: 10),
              width: double.infinity,
              height: 35,
              color: Theme.of(context).colorScheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Offers", style: Theme.of(context).textTheme.headline2),
                ],
              )),
          Container(
              margin: const EdgeInsets.only(left: 10, top: 1),
              height: 140,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 250,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: AssetImage(offerImages[index]),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    );
                  })),
          
              checkRecommendedForYouAvailability(),
          Container(
              padding: const EdgeInsets.only(left: 10),
              width: double.infinity,
              height: 40,
              color: Theme.of(context).colorScheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Top Selling",
                      style: Theme.of(context).textTheme.headline2),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextButton(
                        onPressed: () {
                          provider.checkConnectivity();
                          Navigator.of(context).push(SlideLeftAnimationRoute(Page: TopSellingItems()));
                        },
                        child: const Text(
                          "See All",
                          style:TextStyle(
                            color: Color.fromRGBO(198, 48, 48, 1),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  )
                ],
              )),Container(
              margin: const EdgeInsets.only(left: 15, top: 1, right: 15),
              height: 350,
              child: StreamBuilder(
          stream: collectionReference.snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length > 8? 8 : snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                            for(int i = 0 ; i < 8 ; i++){
                              topSellingLiked.add(false);
                            }
                            if(snapshot.data!.docs[index]["Sales"]/snapshot.data!.docs[index]["Default Quantity"]*100 < 65){
                              provider.getTopSellingItemId(snapshot.data!.docs[index]["Item Name"]);
                            }
                            for(int i = index; i<snapshot.data!.docs.length-1;i++){
                              if(snapshot.data!.docs[index]["Item Name"] == snapshot.data!.docs[i+1]["Item Name"]){
                                provider.getTopSellingItemId(snapshot.data!.docs[index]["Item Name"]);
                              }
                            }
                            return Row(children: [
                              Column(
                                children: [
                                  InkWell(
                                onTap: () async{
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
                       provider.itemName = snapshot.data!.docs[index]["Item Name"];
                                  await provider.getRecommendedSubCategoryName(provider.itemName);
                                  await provider.getRecommendedSubCategoryId(provider.recommendedSubCategoryName);
                                  await provider.getRecommendedItemId();
                                  await provider.getItemDetail();
                                   provider.similarSubcategoriesNames.clear();
                                  provider.similarSubcategoriesIds.clear();
                                  provider.similarItemsIds.clear();
                                  provider.similarItemsData.clear();
                                  provider.similarItemsNames = await provider.getSimilarItems(provider.itemName);
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
                                  provider.recommendedItemsNames = await provider.getRecommendedItems(provider.itemName);
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
                                  provider.checkConnectivity();
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).push(SlideLeftAnimationRoute(Page: itemDetails()));
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
                                            Padding(
                                              padding: const EdgeInsets.only( top:8,left: 5,right: 5),
                                              child: Text(
                                                        snapshot.data!.docs[index]["Description"],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline3,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                      ),
                                            ),
                                            checkTopSellingIemsDiscount(index,snapshot),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              Container(
                                                color:snapshot.data!.docs[index]["Quantity"] == 0 ? Colors.grey[350]:const Color.fromRGBO(198, 48, 48, 1),
                                                width: 100,
                                                height: 35,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(onTap: snapshot.data!.docs[index]["Quantity"] == 0 ? null :() {
                                                  double value = double.parse((snapshot.data!.docs[index]["Price"]-(snapshot.data!.docs[index]["Price"] * snapshot.data!.docs[index]["Discount"]/100)).toStringAsFixed(2));
                                                  bool foundInCart = provider.cartItems.any((element) => element["Item Name"] == snapshot.data!.docs[index]["Item Name"],);
                                              if(!foundInCart){
                                                if(snapshot.data!.docs[index]["Discount"] == 0){
                                                    provider.cartItems.add({
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
                                                }
                                                else{
                                                  provider.cartItems.add({
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
                                                  }
                                              }
                                              Fluttertoast.showToast(
                                                    msg: "Successfully added",
                                                    backgroundColor: Colors.black54,
                                                    toastLength:Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM
                                                    );
                                                  },
                                                  child:Center(child: snapshot.data!.docs[index]["Quantity"] == 0 ? 
                                                  Text("Sold out",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontSize: MediaQuery.of(context).devicePixelRatio*6),)
                                                  :Text("Add to cart",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontSize: MediaQuery.of(context).devicePixelRatio*5.6),)
                                                  ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(onPressed: (() {
                                                setState(() {
                                                  topSellingLiked[index] = !topSellingLiked[index];
                                                });
                                              })
                                              , icon:Icon(topSellingLiked[index] == false? Icons.favorite_border_outlined:Icons.favorite,color: const Color.fromRGBO(198, 48, 48, 1),size: 30,) )
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
              return  Container();
            }
            
          },
        )),
          
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
      },)
    );
  }
}
