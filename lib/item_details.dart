
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class itemDetails extends StatefulWidget{
  @override
  State<itemDetails> createState() => itemDetailsState();
}

class itemDetailsState extends State<itemDetails> {
  int selectedQuantity = 1;
  bool liked = false;
  var similarItemsLiked = [];
  int selectedPage = 0;

  void loadingItem() {
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
    Future.delayed(
      const Duration(milliseconds: 3000),
      () {
        Navigator.pop(context);
        Navigator.of(context)
            .push(SlideLeftAnimationRoute(Page: itemDetails()));
      },
    );
  }
  void loadingSimilarItem() {
    
    Future.delayed(
      const Duration(milliseconds: 7500),
      () {
        
      },
    );
  }

  Widget yellowStar(){
    return const Padding(
      padding: EdgeInsets.only(left: 5,bottom: 5),
      child: Icon(Icons.star_rounded,size: 30,color: Colors.amber,),
    ); 
  }
  Widget greyStar(){
    return const Padding(
      padding: EdgeInsets.only(left: 5,bottom: 5),
      child: Icon(Icons.star_rounded,size: 30,color: Colors.grey,),
    ); 
  }
  Widget setRate(){
    final provider = ProviderController.of(context);
    if(provider.totalReviews == 0){
      return Row(children: [
        greyStar(),greyStar(),greyStar(),greyStar(),greyStar()
      ],);
    }
    else if(provider.avgItemRate > 0 && provider.avgItemRate <= 1){
      return Row(children: [
        yellowStar(),greyStar(),greyStar(),greyStar(),greyStar()
      ],);
    }
    else if(provider.avgItemRate > 1 && provider.avgItemRate <= 2){
      return Row(children: [
        yellowStar(),yellowStar(),greyStar(),greyStar(),greyStar()
      ],);
    }
    else if(provider.avgItemRate > 2 && provider.avgItemRate <= 3){
      return Row(children: [
        yellowStar(),yellowStar(),yellowStar(),greyStar(),greyStar()
      ],);
    }
    else if(provider.avgItemRate > 3 && provider.avgItemRate <= 4){
      return Row(children: [
        yellowStar(),yellowStar(),yellowStar(),yellowStar(),greyStar()
      ],);
    }
    else{
      return Row(children: [
        yellowStar(),yellowStar(),yellowStar(),yellowStar(),yellowStar()
      ],);
    }
  }

  Widget checkItemDiscount(){
    final provider = ProviderController.of(context);
    if(provider.itemDiscount == 0){
      return Padding(
        padding: const EdgeInsets.only(top: 20,left: 15,),
        child: Text("${provider.doubleItemPrice} EGP",style: Theme.of(context).textTheme.headline2),
        );
    }
    else{
      return Column(
        children: [
          Text("${provider.stringItemPrice} EGP",
          style: const TextStyle(fontFamily: "Lato",fontSize: 16,decoration: TextDecoration.lineThrough),),
          Text("${provider.priceOfDiscount} EGP",
          style: Theme.of(context).textTheme.headline2,),],);
    }
  }

  Widget checkSimilarIemsDiscount(int index){
    final provider = ProviderController.of(context);
    if(provider.similarItemsData[index]["Discount"] == 0){
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0,top: 5),
            child: Text("${provider.similarItemsData[index]["Price"] } EGP",
            style: Theme.of(context).textTheme.headline4,),
            ),
        ],
      );
    }
    else{
      double value = double.parse((provider.similarItemsData[index]["Price"]-(provider.similarItemsData[index]["Price"] * provider.similarItemsData[index]["Discount"]/100)).toStringAsFixed(2));
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text("${provider.similarItemsData[index]["Price"] } EGP",
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
          leading: InkWell(onTap: () {
            provider.itemImages.clear();
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_rounded),
          ),
          title:  Text(
            provider.itemName,
            style: const TextStyle(color: Colors.white,fontFamily: "Poppins",fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        backgroundColor:Theme.of(context).colorScheme.onPrimaryContainer,
        body:StreamBuilder(
          initialData: provider.connectivtyResult,
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if(snapshot.data == ConnectivityResult.wifi || snapshot.data == ConnectivityResult.mobile){
              return Stack(
          children: [
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.7,
                      child: PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.itemImages.length,
                        onPageChanged: (page) {
                          setState(() {
                            selectedPage = page;
                          });
                        },
                        itemBuilder: (context, index) {
                        return Image.asset("assets/images/${provider.itemImages[index]}",scale: 1,);
                      },),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PageViewDotIndicator(
                          size: const Size(10.5, 10.5),
                          unselectedSize: const Size(8, 8),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          currentItem: selectedPage,
                          count: provider.itemImages.length,
                          unselectedColor: Colors.black26,
                          selectedColor: const Color.fromRGBO(198, 48, 48, 1),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  child:provider.itemDiscount > 0 ?  Text(
                  " - ${provider.itemDiscount}%",
                  style:Theme.of(context).textTheme.subtitle2,
                  ):const SizedBox(width: 0,height: 0,)
                  ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width-MediaQuery.of(context).size.width*0.2,
                top: MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.75,
                child: IconButton(onPressed: (() {
                  setState(() {
                    liked = !liked;
                    });
                    })
                    ,icon:Icon(liked == false? Icons.favorite_border_outlined:Icons.favorite,color
                    : const Color.fromRGBO(198, 48, 48, 1),size: 30,) ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 1,
                minChildSize: 0.6,
                builder: (context, scrollController) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                    color: Theme.of(context).colorScheme.onPrimary
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child:Column(children:[
                      Padding(
                        padding: const EdgeInsets.only(top:8.0,),
                        child: ListTile(
                          title: Text(provider.itemName,style: Theme.of(context).textTheme.headline2),
                          subtitle:Text(provider.itemDescription,style: const TextStyle(fontSize: 16),softWrap: true,),
                          trailing: checkItemDiscount(),
                        ),
                      ),
                      Row(
                        children:[
                          Padding(
                            padding: const EdgeInsets.only(left: 15,bottom: 5,top: 5),
                            child: provider.itemQuantity > 0 ? const Text("In Stock",
                            style: TextStyle(
                              color: Color.fromRGBO(198, 48, 48, 1),
                              fontFamily: "Poppins",
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ))
                            :const Text("Out Of Stock",
                            style: TextStyle(
                              color: Color.fromRGBO(198, 48, 48, 1),
                              fontFamily: "Poppins",
                              fontSize: 22,
                              fontWeight: FontWeight.bold
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("(${provider.itemQuantity.toString()})"),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        Container(
                                margin: const EdgeInsets.all(6),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                color: selectedQuantity == 1 ? Colors.grey:const Color.fromRGBO(198, 48, 48, 1),),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: selectedQuantity == 1 ? null : () {
                                      setState(() {
                                        selectedQuantity--;
                                      });
                                    },
                                    customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  child:  const Center(child: Icon(Icons.remove,color: Colors.white,))),
                                ),
                              ),
                        Container(
                          width: 200,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.grey)),
                          child: Center(child: Text("Qty: ${selectedQuantity.toString()}",style:Theme.of(context).textTheme.bodyText1))),
                        Container(
                                margin: const EdgeInsets.all(6),
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                color: selectedQuantity == provider.itemQuantity  ? Colors.grey:const Color.fromRGBO(198, 48, 48, 1),),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: selectedQuantity == provider.itemQuantity ? null : () {
                                      setState(() {
                                        selectedQuantity++;
                                      });
                                    },
                                    customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  child:  const Center(child: Icon(Icons.add,color: Colors.white,))),
                                ),
                              ),
                      ],),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20,left: 10,bottom: 5),
                            child: Text("Reviews",style: Theme.of(context).textTheme.headline2),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20,left: 10),
                            child: Text("(${provider.totalReviews.toString()})"),
                          )
                        ],
                      ),
                      setRate(),
                      Padding(
                        padding: const EdgeInsets.only(top:15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: Container(
                              decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color:provider.itemQuantity == 0 ? Colors.grey:const Color.fromRGBO(198, 48, 48, 1)),
                              child: Material(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                color: Colors.transparent,
                                child: InkWell(onTap: provider.itemQuantity == 0 ? null :() {
                                     bool foundInCart = provider.cartItems.any((element) => element["Item Name"] == provider.itemName,);
                                      if(!foundInCart){
                                        if(provider.itemDiscount == 0){
                                            provider.cartItems.add({
                                              "Item Name":provider.itemName,
                                              "Description":provider.itemDescription,
                                              "Item Images":provider.itemImages,
                                              "Rates":provider.itemRates,
                                              "Sales":provider.itemSales,
                                              "Default Quantity":provider.itemDefaultQuantity,
                                              "Discount":provider.itemDiscount,
                                              "Image":provider.itemImages[0],
                                              "Selected Quantity":selectedQuantity,
                                              "Price":provider.doubleItemPrice * selectedQuantity,
                                              "Default Price":provider.doubleItemPrice,
                                              "Total Quantity":provider.itemQuantity,
                                              });
                                        }
                                        else{
                                          provider.cartItems.add({
                                            "Item Name":provider.itemName,
                                            "Description":provider.itemDescription,
                                            "Item Images":provider.itemImages,
                                            "Rates":provider.itemRates,
                                            "Sales":provider.itemSales,
                                            "Default Quantity":provider.itemDefaultQuantity,
                                            "Discount":provider.itemDiscount,
                                            "Image":provider.itemImages[0],
                                            "Selected Quantity":selectedQuantity,
                                            "Price":provider.priceOfDiscount * selectedQuantity,
                                            "Default Price":provider.priceOfDiscount,
                                            "Total Quantity":provider.itemQuantity,
                                          });
                                          }
                                      }
                                      else{
                                        int indexFound = provider.cartItems.indexWhere((element) => element["Item Name"] == provider.itemName);
                                        provider.cartItems.removeAt(indexFound);
                                        provider.cartItems.insert(indexFound, {
                                          "Item Name":provider.itemName,
                                          "Description":provider.itemDescription,
                                          "Item Images":provider.itemImages,
                                          "Rates":provider.itemRates,
                                          "Sales":provider.itemSales,
                                          "Default Quantity":provider.itemDefaultQuantity,
                                          "Discount":provider.itemDiscount,
                                          "Image":provider.itemImages[0],
                                          "Selected Quantity":selectedQuantity,
                                          "Price":provider.priceOfDiscount * selectedQuantity,
                                          "Default Price":provider.priceOfDiscount,
                                          "Total Quantity":provider.itemQuantity,
                                        });
                                      }
                                      Fluttertoast.showToast(
                                        msg: "Successfully added",
                                        backgroundColor: Colors.black54,
                                        toastLength:Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM
                                        );
                                        print(provider.cartItems);
                                },
                                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    provider.itemQuantity == 0? const Icon(Icons.remove_shopping_cart_rounded,color: Colors.white,)
                                    :const Icon(Icons.add_shopping_cart_rounded,color: Colors.white,),
                                    const SizedBox(width: 8,),
                                    provider.itemQuantity == 0? const Text("Sold Out",
                                    style: TextStyle(fontFamily: "Poppins",fontSize: 17,color: Colors.white),)
                                    :const Text("Add to Cart",
                                    style: TextStyle(fontFamily: "Poppins",fontSize: 17,color: Colors.white),),
                                ],)
                                ),
                              ),
                            ),
                          )
                        ],),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20,left: 10,bottom: 5),
                            child: provider.similarItemsNames.isEmpty? const Text("")
                            :Text("Also Buy",style: Theme.of(context).textTheme.headline2),
                          ),
                        ],
                      ),
                      Container(
                          margin: provider.similarItemsNames.isEmpty? const EdgeInsets.all(0)
                          :const EdgeInsets.only(left: 15, top: 1, right: 15),
                          height:provider.similarItemsNames.isEmpty? 0: 350,
                          child: provider.similarItemsNames.isEmpty? Container()
                            :ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: provider.similarItemsData.length,
                            itemBuilder: (context, index) {
                            for(int i = 0;i<provider.similarItemsData.length;i++){
                              similarItemsLiked.add(false);
                            }
                            return Row(children: [
                              Column(
                                children: [
                                  InkWell(
                                onTap: () async{
                                  provider.itemName = provider.similarItemsData[index]["Item Name"];
                                  provider.itemImages = provider.similarItemsData[index]["Item Images"];
                                  provider.stringItemPrice = provider.similarItemsData[index]["Price"].toString();
                                  provider.doubleItemPrice = provider.similarItemsData[index]["Price"]+0.00;
                                  provider.itemDescription = provider.similarItemsData[index]["Description"];
                                  provider.itemQuantity = provider.similarItemsData[index]["Quantity"];
                                  provider.itemRates = provider.similarItemsData[index]["Rates"];
                                  provider.totalReviews = (provider.itemRates[0] + provider.itemRates[1] + provider.itemRates[2] + provider.itemRates[3] + provider.itemRates[4]);
                                  provider.avgItemRate = (provider.itemRates[0]*1 + provider.itemRates[1]*2 + provider.itemRates[2]*3 + provider.itemRates[3]*4 + provider.itemRates[4]*5)/provider.totalReviews;
                                  provider.numberOfItemImages = provider.itemImages.length;
                                  provider.itemDiscount = provider.similarItemsData[index]["Discount"];
                                  provider.priceOfDiscount = double.parse(( provider.doubleItemPrice - (provider.doubleItemPrice * provider.itemDiscount/100)).toStringAsFixed(2)); 
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
                                  provider.recommendedItemsNames = await provider.getRecommendedItems(provider.similarItemsNames[index]);
                                  provider.similarItemsNames = await provider.getSimilarItems(provider.similarItemsNames[index]);
                                  provider.similarSubcategoriesNames.clear();
                                  provider.similarSubcategoriesIds.clear();
                                  provider.similarItemsIds.clear();
                                  provider.similarItemsData.clear();
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
                                  Navigator.of(context).pushReplacement(SlideLeftAnimationRoute(Page: itemDetails()));
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
                                                              image: AssetImage('assets/images/${provider.similarItemsData[index]["Image"]}'),
                                                              fit: BoxFit.cover)),
                                                    ),
                                                  ],
                                                ),
                                                Positioned(  
                                                  child: Container(
                                                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                                                    child:provider.similarItemsData[index]["Discount"] > 0 ?  Text(
                                                          " - ${provider.similarItemsData[index]["Discount"]}%",
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
                                                        provider.similarItemsData[index]["Quantity"] > 0?"":"Out of stock",
                                                        style: const TextStyle(fontSize: 15.5,color: Color.fromRGBO(198, 48, 48, 1),),
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only( top:8,left: 5,right: 5),
                                              child: Text(
                                                        provider.similarItemsData[index]["Description"],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline3,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                      ),
                                            ),
                                            checkSimilarIemsDiscount(index),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                              Container(
                                                color:provider.similarItemsData[index]["Quantity"] == 0 ? Colors.grey[350]:const Color.fromRGBO(198, 48, 48, 1),
                                                width: 100,
                                                height: 35,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(onTap: provider.similarItemsData[index]["Quantity"] == 0 ? null :() {
                                                  double value = double.parse((provider.similarItemsData[index]["Price"]-(provider.similarItemsData[index]["Price"] * provider.similarItemsData[index]["Discount"]/100)).toStringAsFixed(2));
                                                  bool foundInCart = provider.cartItems.any((element) => element["Item Name"] == provider.similarItemsData[index]["Item Name"],);
                                              if(!foundInCart){
                                                if(provider.similarItemsData[index]["Discount"] == 0){
                                                    provider.cartItems.add({
                                                      "Item Name":provider.similarItemsData[index]["Item Name"],
                                                      "Image":provider.similarItemsData[index]["Image"],
                                                      "Selected Quantity":provider.defaultQuantity,
                                                      "Price":provider.similarItemsData[index]["Price"],
                                                      "Default Price":provider.similarItemsData[index]["Price"],
                                                      "Total Quantity":provider.similarItemsData[index]["Quantity"],
                                                      });
                                                }
                                                else{
                                                  provider.cartItems.add({
                                                    "Item Name":provider.similarItemsData[index]["Item Name"],
                                                    "Image":provider.similarItemsData[index]["Image"],
                                                    "Selected Quantity":provider.defaultQuantity,
                                                    "Price":value,
                                                    "Default Price":value,
                                                    "Total Quantity":provider.similarItemsData[index]["Quantity"],
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
                                                  child:Center(child: provider.similarItemsData[index]["Quantity"] == 0 ? 
                                                  Text("Sold out",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontSize: MediaQuery.of(context).devicePixelRatio*6),)
                                                  :Text("Add to cart",style: TextStyle(color: Colors.white,fontFamily: "Lato",fontSize: MediaQuery.of(context).devicePixelRatio*5.6),)
                                                  ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(onPressed: (() {
                                                setState(() {
                                                  similarItemsLiked[index] = !similarItemsLiked[index];
                                                });
                                              })
                                              , icon:Icon(similarItemsLiked[index] == false? Icons.favorite_border_outlined:Icons.favorite,color: const Color.fromRGBO(198, 48, 48, 1),size: 30,) )
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
              ))
                      ],)
                  ),
                );
              },)
            ],);
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