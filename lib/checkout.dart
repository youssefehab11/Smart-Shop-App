// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduationproject/credit_card.dart';
import 'package:graduationproject/navigationbar_controller_screen.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:lottie/lottie.dart' as loi;

class Checkout extends StatefulWidget{
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  var pickupLocation;
  var paymentMethod;
  late bool serviceLocation;
  late var locationPermission;
  double shippingFee = 20;
  double Total = 0;
  String defaultAddress = "";
  

  void loading(){
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedSplashScreen(
            disableNavigation: true,
            splashIconSize: 150,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            splash:
                loi.Lottie.asset("assets/lotties/1620-simple-dots-loading.json"),
            animationDuration: const Duration(seconds: 1),
            nextScreen: const Checkout());
      },
    );
      Future.delayed(const Duration(milliseconds: 4000),() {
        Navigator.pop(context);
        Navigator.of(context).push(SlideLeftAnimationRoute(Page: CustomAdressMap()));
      },);
    }

    Widget getTotal(){
      final provider = ProviderController.of(context);
      Total = provider.subtotal + shippingFee;
      Total = double.parse((Total).toStringAsFixed(2));
      return Text("${Total.toString()} EGP",style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22,
        fontFamily: "Poppins",
        color:Color.fromRGBO(198, 48, 48, 1)
        ),);
    }
    Widget confirmation(){
      final provider = ProviderController.of(context);
      if(paymentMethod == null || pickupLocation == null){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 200,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.grey),
                child: Material(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  color: Colors.transparent,
                  child: InkWell(onTap: null,
                  customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: const Center(
                    child: Text("Confirm",
                    style: TextStyle(fontFamily: "Poppins",fontSize: 18,color: Colors.white),),),
                         ),
                        ),
                      )
                   ),
               );
      }
      else {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 200,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromRGBO(198, 48, 48, 1)),
                child: Material(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  color: Colors.transparent,
                  child: InkWell(onTap: () async{
                    if(pickupLocation == "Default location" && paymentMethod == "Cash On Delivery"){
                      if(defaultAddress != ""){
                        Fluttertoast.showToast(
                          msg: "Check your inbox confirmation message",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AnimatedSplashScreen(
                                disableNavigation: true,
                                splashIconSize: 150,
                                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                splash:
                                loi.Lottie.asset("assets/lotties/1620-simple-dots-loading.json"),
                                animationDuration: const Duration(seconds: 1),
                                nextScreen: NavigationBarController());
                              },
                           );
                        for(int i = 0; i < provider.cartItems.length; i++){
                          await provider.getCartItemSubCategoryName(provider.cartItems[i]["Item Name"],i); 
                          await provider.getCartItemIdInTopSelling(i);                         

                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(SlideRightAnimationRoute(Page: NavigationBarController()));
 
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Add your Address first!",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                      }
                    }
                    else if(pickupLocation == "Default location" && paymentMethod == "Pay by Card"){
                      if(defaultAddress != ""){
                        if(provider.cardNumber != ""){
                          Fluttertoast.showToast(
                          msg: "Check your inbox confirmation message",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AnimatedSplashScreen(
                                disableNavigation: true,
                                splashIconSize: 150,
                                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                splash:
                                loi.Lottie.asset("assets/lotties/1620-simple-dots-loading.json"),
                                animationDuration: const Duration(seconds: 1),
                                nextScreen: NavigationBarController());
                              },
                           );
                        for(int i = 0; i < provider.cartItems.length; i++){
                          await provider.getCartItemSubCategoryName(provider.cartItems[i]["Item Name"],i); 
                          await provider.getCartItemIdInTopSelling(i);                         

                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(SlideRightAnimationRoute(Page: NavigationBarController()));
                        }
                        else{
                          Fluttertoast.showToast(
                          msg: "Add your Card first!",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                        }
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Add your Address first!",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                      }
                    }
                    else if(pickupLocation == "Custom location" && paymentMethod == "Cash On Delivery"){
                      if(provider.customAddressFlag == true){
                          Fluttertoast.showToast(
                          msg: "Check your inbox confirmation message",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AnimatedSplashScreen(
                                disableNavigation: true,
                                splashIconSize: 150,
                                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                splash:
                                loi.Lottie.asset("assets/lotties/1620-simple-dots-loading.json"),
                                animationDuration: const Duration(seconds: 1),
                                nextScreen: NavigationBarController());
                              },
                           );
                        for(int i = 0; i < provider.cartItems.length; i++){
                          await provider.getCartItemSubCategoryName(provider.cartItems[i]["Item Name"],i); 
                          await provider.getCartItemIdInTopSelling(i);                         

                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(SlideRightAnimationRoute(Page: NavigationBarController()));
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Add your Address first!",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                      }
                    }
                    else{
                      if(provider.customAddressFlag == true){
                        if(provider.cardNumber != ""){
                          Fluttertoast.showToast(
                          msg: "Check your inbox confirmation message",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AnimatedSplashScreen(
                                disableNavigation: true,
                                splashIconSize: 150,
                                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                splash:
                                loi.Lottie.asset("assets/lotties/1620-simple-dots-loading.json"),
                                animationDuration: const Duration(seconds: 1),
                                nextScreen: NavigationBarController());
                              },
                           );
                        for(int i = 0; i < provider.cartItems.length; i++){
                          await provider.getCartItemSubCategoryName(provider.cartItems[i]["Item Name"],i); 
                          await provider.getCartItemIdInTopSelling(i);                         

                        }
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(SlideRightAnimationRoute(Page: NavigationBarController()));
                        }
                        else{
                          Fluttertoast.showToast(
                          msg: "Add your Card first!",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                        }
                      }
                      else{
                        Fluttertoast.showToast(
                          msg: "Add your Address first!",
                          backgroundColor: Colors.black54,
                          toastLength:Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                        );
                      }
                    }
                  },
                  customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: const Center(
                    child: Text("Confirm",
                    style: TextStyle(fontFamily: "Poppins",fontSize: 18,color: Colors.white),),),
                         ),
                        ),
                      )
                   ),
               );
      }
    }

    Widget checkSelectedLocation(){
      final provider = ProviderController.of(context);

      if(pickupLocation == null || pickupLocation == "Default location"){
        return Container();
      }
      else{
        return Container(
            margin: const EdgeInsets.only(top: 5,left: 15,right: 15,bottom: 15),
            width: double.infinity,
            //height: MediaQuery.of(context).size.height/2.7,
            decoration: BoxDecoration(
              border: Border.all(width: 1,color: Colors.grey),
              borderRadius: BorderRadius.circular(20)
              
            ),
            child: Column(children: [
              
              InkWell(
                onTap: () async{
                  serviceLocation = await Geolocator.isLocationServiceEnabled(); 
                  if(serviceLocation){
                    locationPermission = await Geolocator.checkPermission();
                    
                    if(locationPermission == LocationPermission.denied){
                        await Geolocator.requestPermission();
                    }
                    if(locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always){
                      provider.getPosition();
                      provider.checkConnectivity();
                      loading();
                      
                    } 
                  }
                  else{
                     Fluttertoast.showToast(
                      msg: "Activate your location",
                      backgroundColor: Colors.black54,
                      toastLength:Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM
                    ); 
                      Future.delayed(const Duration(seconds: 1),() async{
                        await Geolocator.openLocationSettings();
                      },);
                  }
                  
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  child: Image.asset("assets/images/Maps.jpg",fit:BoxFit.cover,))),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(children: [
                      const Icon(Icons.location_on,color: Color.fromRGBO(198, 48, 48, 1),),
                      const SizedBox(width: 5,),
                      Text("Mark your pickup location",style: Theme.of(context).textTheme.headline4,)
                    ]),
                  ),
                )
            ],),
          );
      }
    }

    Widget checkSelectedPaymentMethod(){
      if(paymentMethod == null){
        return Container();
      }
      else if(paymentMethod == "Cash On Delivery"){
        return Container();
      }
      else{
        return InkWell(
          onTap: () {
            Navigator.of(context).push(SlideLeftAnimationRoute(Page: const CreditCard()));
          },
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add,size: 25,),
                Text("Add your Card",style: Theme.of(context).textTheme.bodyText1,),
              ],
            ),
          ),
        );
      }

    }

    Widget setAddress(){
      var user = FirebaseAuth.instance.currentUser;
      DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
      if(pickupLocation == null){
        return const SizedBox(
          height: 50,
          width: double.infinity,
          child: Center(child: Text("No address yet!")));
      }
      else if(pickupLocation == "Default location"){
        return  StreamBuilder(
            stream: userref.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data!["Default Country"] == ""){
                  return const SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Center(child: Text("No address yet!")));
                }
                else{
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(),
                      Padding(
                        padding: const EdgeInsets.only(top:25,left: 8),
                        child: Text("Name: ${snapshot.data!["First Name"]} ${snapshot.data!["Last Name"]}",
                          style:Theme.of(context).textTheme.bodyText1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,left: 8),
                        child: Text("${snapshot.data!["Default Country"]}, ${snapshot.data!["Default City"]}",
                        style:Theme.of(context).textTheme.bodyText1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text("${snapshot.data!["Default Subcity"]}, ${snapshot.data!["Default Thoroughfare"]}, ${snapshot.data!["Default Street"]}",
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyText1
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0,left: 8,bottom: 25),
                        child: Text("Phone Number: ${snapshot.data!["Phone Number"]}",
                          style:Theme.of(context).textTheme.bodyText1),
                      ),
                      ],);
                }
                
                  } else {
                    return const Text("");
                  }
          },);
      }
      else{
          return StreamBuilder(
            stream: userref.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if(snapshot.data!["Custom Country"] == ""){
                  return const SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: Center(child: Text("No address yet!")));
                }
                else{
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(),
                      Padding(
                        padding: const EdgeInsets.only(top:25,left: 8),
                        child: Text("Name: ${snapshot.data!["First Name"]} ${snapshot.data!["Last Name"]}",
                          style:Theme.of(context).textTheme.bodyText1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,left: 8),
                        child: Text("${snapshot.data!["Custom Country"]}, ${snapshot.data!["Custom City"]}",
                        style:Theme.of(context).textTheme.bodyText1),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text("${snapshot.data!["Custom Subcity"]}, ${snapshot.data!["Custom Thoroughfare"]}, ${snapshot.data!["Custom Street"]}",
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyText1
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0,left: 8,bottom: 25),
                        child: Text("Phone Number: ${snapshot.data!["Phone Number"]}",
                          style:Theme.of(context).textTheme.bodyText1),
                      ),
                      ],);
                }
                
                  } else {
                    return const Text("");
                  }
          },);
      }
    }

  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context);

    var user = FirebaseAuth.instance;
    DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user.currentUser!.uid);
    return Scaffold(
      appBar:AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            ),
      body:StreamBuilder(
        initialData: provider.connectivtyResult,
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if(snapshot.data == ConnectivityResult.wifi || snapshot.data == ConnectivityResult.mobile){
            return ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, top: 5),
            width: double.infinity,
            height: 30,
            color: Theme.of(context).colorScheme.onBackground,
            child: const Text(
              "Delivery",
              style: TextStyle(
               fontSize: 15,
               fontWeight: FontWeight.bold,
               fontFamily: "Lato",),
            )
          ),
          Card(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                Text("Default location",style: Theme.of(context).textTheme.bodyText1,),
                const Spacer(),
                Radio(
                  activeColor:const Color.fromRGBO(198, 48, 48, 1),
                  value: "Default location", groupValue: pickupLocation, onChanged: (value) async{
                    await userref.get().then((value) {
                    defaultAddress = value.get("Default Country");});
                    setState(() {
                      pickupLocation = value;
                    });
                },)
            ],),
              ),
             const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child:  Text("Default address will take the saved address in your profile"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 1,width: double.infinity,color: Theme.of(context).colorScheme.onBackground,),
              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Text("Custom location",style: Theme.of(context).textTheme.bodyText1,),
              const Spacer(),
              Radio(
                activeColor:const Color.fromRGBO(198, 48, 48, 1),
                value: "Custom location", groupValue: pickupLocation, onChanged: (value) {
                setState(() {
                  pickupLocation = value;
                });
              },)
            ],),
          ),
          checkSelectedLocation(),
          Container(
            padding: const EdgeInsets.only(left: 10, top: 5),
            width: double.infinity,
            height: 30,
            color: Theme.of(context).colorScheme.onBackground,
            child: const Text(
              "Address Details",
              style: TextStyle(
               fontSize: 15,
               fontWeight: FontWeight.bold,
               fontFamily: "Lato",),
            )
          ),
          setAddress(),
          ],),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, top: 5),
            width: double.infinity,
            height: 30,
            color: Theme.of(context).colorScheme.onBackground,
            child: const Text(
              "Payment Method",
              style: TextStyle(
               fontSize: 15,
               fontWeight: FontWeight.bold,
               fontFamily: "Lato",),
            )
          ),
          Card(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                Text("Cash On Delivery",style: Theme.of(context).textTheme.bodyText1,),
                const Spacer(),
                Radio(
                  activeColor:const Color.fromRGBO(198, 48, 48, 1),
                  value: "Cash On Delivery", groupValue: paymentMethod, onChanged: (value) {
                    setState(() {
                      paymentMethod = value;
                    });
                },)
            ],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 1,width: double.infinity,color: Theme.of(context).colorScheme.onBackground,),
              ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Text("Pay by Card",style: Theme.of(context).textTheme.bodyText1,),
                  const Spacer(),
                  Radio(
                    activeColor:const Color.fromRGBO(198, 48, 48, 1),
                    value: "Pay by Card", groupValue: paymentMethod, onChanged: (value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },)
                ],),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Image.asset('assets/images/Master Card.png',
                    height: 48,
                    width: 48,
                    ),
                    const SizedBox(width: 5,),
                    Image.asset('assets/images/Visa.jpg',
                    height: 48,
                    width: 48,
                    ),
                  ],
                ),
              ),
            ],
          ),
          checkSelectedPaymentMethod(),
          
          ],),
          ),
          Card(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Text("Subtotal",style: Theme.of(context).textTheme.headline4,),
                  const Spacer(),
                  Text("${provider.subtotal.toString()} EGP",style: const TextStyle(fontSize: 18),)
                ],),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Text("Shipping Fee",style: Theme.of(context).textTheme.headline4,),
                  const Spacer(),
                  Text("${shippingFee.toString()} EGP",style: const TextStyle(fontSize: 18),)
                ],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 1,width: double.infinity,color: Theme.of(context).colorScheme.onBackground,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Text("Total",style: Theme.of(context).textTheme.headline4),
                  const Spacer(),
                  getTotal(),
                ],),
              ),
              confirmation(),
            ]),
          ) 
        ],
      ) ;
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
class CustomAdressMap extends StatefulWidget{
  const CustomAdressMap({super.key});

  @override
  State<CustomAdressMap> createState() => _CustomAdressMapState();
}

class _CustomAdressMapState extends State<CustomAdressMap> {
  
  late GoogleMapController gmc;
  Set<Marker> currentLocation = {
    
  }; 
  List<Placemark> placemarks=[];

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    final provider = ProviderController.of(context);
/*     lat = provider.lat;
    lng = provider.long;
    provider.long; */
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Maps",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold),
            ),      
            centerTitle: true,
            actions: [
              IconButton(onPressed: () async{
                var connectivtyResult = await Connectivity().checkConnectivity();
                Future.delayed(const Duration(milliseconds: 800),() {
                  if(connectivtyResult == ConnectivityResult.wifi || connectivtyResult == ConnectivityResult.mobile){
                    if(placemarks.isEmpty){
                  Fluttertoast.showToast(
                    msg: "Please mark your address first",
                    backgroundColor: Colors.black54,
                    toastLength:Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM
                  );
                }
                else{
                  userref.update({"Custom Country":placemarks[0].country});
                  userref.update({"Custom City":placemarks[0].administrativeArea});
                  userref.update({"Custom Subcity":placemarks[0].subAdministrativeArea});
                  userref.update({"Custom Street":placemarks[0].street});
                  userref.update({"Custom Thoroughfare":placemarks[0].thoroughfare});
                  Fluttertoast.showToast(
                    msg: "Successfully added",
                    backgroundColor: Colors.black54,
                    toastLength:Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM
                  );
                  provider.customAddressFlag = true; 
                  Navigator.of(context).pop();
                }
                  }
                  else{
                    Fluttertoast.showToast(
                    msg: "Check your connection!",
                    backgroundColor: Colors.black54,
                    toastLength:Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM
                  );
                  }
                },);
              }, icon: const Icon(Icons.check))
            ],
          ),
      body:StreamBuilder(
        initialData: provider.connectivtyResult,
        stream: Connectivity().onConnectivityChanged,
        builder: (context, snapshot) {
          if(snapshot.data == ConnectivityResult.wifi || snapshot.data == ConnectivityResult.mobile){
            return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: GoogleMap(
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          initialCameraPosition:const CameraPosition(
            target: LatLng(30.044420, 31.235712),
            zoom: 8,),
          onMapCreated: (GoogleMapController controller) {
            gmc = controller;
          },
          markers: currentLocation,  
          onTap:(argument) async{
            setState(() {
              currentLocation.remove(const Marker(markerId: MarkerId("1")));
              currentLocation.add(Marker(markerId: const MarkerId("1"),position: LatLng(argument.latitude, argument.longitude)));
            });
            placemarks = await placemarkFromCoordinates(argument.latitude,argument.longitude);
          },
        ),
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
        },),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(onPressed: () async{
        var connectivityResult = await Connectivity().checkConnectivity();
        // ignore: unrelated_type_equality_checks
        if(connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile){
          gmc.animateCamera(
          CameraUpdate.newCameraPosition( CameraPosition(
            target: LatLng(provider.currentLocation.latitude, provider.currentLocation.longitude),zoom:14.4746 )));
        }
        else{
          Fluttertoast.showToast(
                    msg: "Check your connection!",
                    backgroundColor: Colors.black54,
                    toastLength:Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM
                  );
        } 
      },
      backgroundColor: Colors.white,
      child: const Icon(Icons.location_searching_rounded,size: 30,),
      ),
    );
    
  }
}