
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:lottie/lottie.dart' as loi;

import 'provider_controller.dart';

class Address extends StatefulWidget{
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {

  late bool serviceLocation;
  late var locationPermission;

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
            nextScreen: const Address());
      },
    );
      Future.delayed(const Duration(milliseconds: 4000),() {
        Navigator.pop(context);
        Navigator.of(context).push(SlideLeftAnimationRoute(Page: const DefaultAddressMap()));
      },);
    }

  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context);
    var user = FirebaseAuth.instance.currentUser;
      DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Address",
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
              return Column(children: [
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: InkWell(
              onTap: () async{
                serviceLocation = await Geolocator.isLocationServiceEnabled(); 
                  if(serviceLocation){
                    locationPermission = await Geolocator.checkPermission();
                    
                    if(locationPermission == LocationPermission.denied){
                        await Geolocator.requestPermission();
                    }
                    if(locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always){
                      provider.getPosition();
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
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add,size: 25,),
                    Text("Add your address",style: Theme.of(context).textTheme.bodyText1,),
                  ],
                ),
              ),
            ),
          ),
          StreamBuilder(
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
                  return Card(
                    child: Column(
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
                        ],),
                  );
                }
                
                  } else {
                    return const Text("");
                  }
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
class DefaultAddressMap extends StatefulWidget{
  const DefaultAddressMap({super.key});

  @override
  State<DefaultAddressMap> createState() => _DefaultAddressMapState();
}

class _DefaultAddressMapState extends State<DefaultAddressMap> {
  
  late GoogleMapController gmc;
  Set<Marker> currentLocation = {
    
  }; 
  List<Placemark> placemarks=[];

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    final provider = ProviderController.of(context);
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
                  userref.update({"Default Country":placemarks[0].country});
                  userref.update({"Default City":placemarks[0].administrativeArea});
                  userref.update({"Default Subcity":placemarks[0].subAdministrativeArea});
                  userref.update({"Default Street":placemarks[0].street});
                  userref.update({"Default Thoroughfare":placemarks[0].thoroughfare});
                  Fluttertoast.showToast(
                    msg: "Successfully added",
                    backgroundColor: Colors.black54,
                    toastLength:Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM
                  ); 
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
        },
      ),
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