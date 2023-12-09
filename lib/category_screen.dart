import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/subcategory_items.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:lottie/lottie.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => CategoryScreenState();
}

List categories = [
  "Oil & Masala",
  "Eggs, Meat & Fish",
  "Beverages",
  "Fruits & Veggies",
  "Bakery",
  "Snacks",
  "Food Grains"
];
String subCategory = "";


class CategoryScreenState extends State<CategoryScreen> {
  loadingSubCategories() {
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
            nextScreen: const CategoryScreen());
      },
    );
  }

  void loadingItems() {
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
            nextScreen: const CategoryScreen());
      },
    );
    Future.delayed(
      const Duration(milliseconds: 3000),
      () {
        Navigator.pop(context);
        Navigator.of(context)
            .push(SlideLeftAnimationRoute(Page: SubCategoryItems()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context);

    Widget pageView() {
      CollectionReference collectionReference = FirebaseFirestore.instance
        .collection("Categories")
        .doc(provider.categoryId)
        .collection("SubCategories");
      return Expanded(
          child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        height: double.infinity,
        child: FutureBuilder(
          future: collectionReference.get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 190),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 135,
                            width: 135,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.onPrimary),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: InkWell(
                                  onTap: () {
                                    
                                    provider.items.clear();
                                    setState(() {
                                      provider.subCategoryTitle = snapshot
                                          .data?.docs[index]["SubCategoryName"];
                                      subCategory = snapshot.data?.docs[index]
                                          ["SubCategoryName"];
                                      provider.getSubCategoryId(subCategory);
                                    });
                                    loadingItems();
                                    Future.delayed(const Duration(seconds: 3),() {
                                      provider.usedItems = provider.items;
                                    },);
                                    
                                  },
                                  child: Image.asset(
                                    'assets/images/${snapshot.data?.docs[index]["Image"]}',
                                    fit: BoxFit.cover,
                                  )),
                            )),
                      ),
                      Text(snapshot.data?.docs[index]["SubCategoryName"]),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text("Error");
            } else {
              return const Text("Loading");
            }
          },
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Categories",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        //elevation: 0.0,
      ),
      body:StreamBuilder(
        initialData: provider.connectivtyResult,
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if(snapshot.data == ConnectivityResult.wifi || snapshot.data == ConnectivityResult.mobile){
            return  Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width*0.72,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    for (int i = 0; i < 7; i++) {
                      provider.selectedCategoryBackGroundColor.add(false);
                    }
                    for (int i = 0; i < 7; i++) {
                      provider.selectedCategoryLableColor.add(false);
                    }
                    return SizedBox(
                      height: 80,
                      child: InkWell(
                        onTap: () {
                          provider.getCategoryId(categories[index]);
                          loadingSubCategories();
                          Future.delayed(
                            const Duration(seconds: 3),
                            () {
                              Navigator.pop(context);
                              setState(() {
                                provider.selectedCategoryBackGroundColor
                                    .clear();
                                for (int i = 0; i < 7; i++) {
                                  provider.selectedCategoryBackGroundColor
                                      .add(false);
                                }
                                provider.selectedCategoryBackGroundColor[
                                        index] =
                                    !provider
                                        .selectedCategoryBackGroundColor[index];
                                provider.selectedCategoryLableColor.clear();
                                for (int i = 0; i < 7; i++) {
                                  provider.selectedCategoryLableColor
                                      .add(false);
                                }
                                provider.selectedCategoryLableColor[index] =
                                    !provider.selectedCategoryLableColor[index];
                              });
                            },
                          );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                              color: provider.selectedCategoryBackGroundColor[
                                          index] ==
                                      false
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : const Color.fromRGBO(198, 48, 48, 1),
                            ),
                            padding: const EdgeInsets.only(
                                top: 10, right: 5, left: 8),
                            child: Text(categories[index],
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    color: provider.selectedCategoryLableColor[
                                                index] ==
                                            false
                                        ? Colors.black87
                                        : Colors.white))),
                      ),
                    );
                  })),
          Container(
            width: 2,
            height: double.infinity,
            color: Theme.of(context).colorScheme.primary,
          ),
          pageView()
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
