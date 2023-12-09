import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:lottie/lottie.dart';
import 'edit_profile.dart';
import 'firebase_constant.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context); 
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Profile",
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
              return Stack(
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.25,
              color: const Color.fromRGBO(198, 48, 48, 1),
              child: Center(
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 60,
                  child: const Icon(
                    Icons.person,
                    size: 110,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Scroll(),
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
    ));
  }
}

Scroll() {
  // final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void loading(BuildContext context) {
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
            nextScreen: const EditProfile());
      },
    );
    Future.delayed(
      const Duration(milliseconds: 3500),
      () {
        Navigator.pop(context);
        Navigator.of(context)
            .push(SlideLeftAnimationRoute(Page: const EditProfile()));
      },
    );
  }

  return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 1.0,
      minChildSize: 0.75,
      builder: (context, scrollController) {
        return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: 5,
                                    width: 35,
                                    color: Colors.black12),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20.0,
                                left: 25,
                              ),
                              child: Text("First Name",
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                            StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(auth.currentUser!.uid)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    var data = snapshot.data!.data();
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: TextFormField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: data!['First Name']),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                          decoration: InputDecoration(
                                            filled: true, //<-- SEE HERE
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            disabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedErrorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          )),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            filled: true, //<-- SEE HERE
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            disabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedErrorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          )),
                                    );
                                  }
                                }),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                              ),
                              child: Text("Last Name",
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                            StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(auth.currentUser!.uid)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    var data = snapshot.data!.data();

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: TextFormField(
                                          readOnly: true,
                                          controller: TextEditingController(
                                              text: data!['Last Name']),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                          decoration: InputDecoration(
                                            filled: true, //<-- SEE HERE
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            disabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedErrorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          )),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: TextFormField(
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            filled: true, //<-- SEE HERE
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            disabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            errorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedErrorBorder:
                                                const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                          )),
                                    );
                                  }
                                }),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                              ),
                              child: Text("Phone Number",
                                  style: Theme.of(context).textTheme.headline6),
                            ),
                          ]),
                    ),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(auth.currentUser!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!.data();
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: data!['Phone Number']),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                  decoration: InputDecoration(
                                    filled: true, //<-- SEE HERE

                                    fillColor:
                                        Theme.of(context).colorScheme.onPrimary,

                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    disabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    errorBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    focusedErrorBorder:
                                        const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  )),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    filled: true, //<-- SEE HERE

                                    fillColor:
                                        Theme.of(context).colorScheme.onPrimary,

                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    disabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    errorBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    focusedErrorBorder:
                                        const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  )),
                            );
                          }
                        }),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 25,
                      ),
                      child: Text("Email Address",
                          style: Theme.of(context).textTheme.headline6),
                    ),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .doc(auth.currentUser!.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!.data();
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(
                                      text: data!['Email address']),
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                  decoration: InputDecoration(
                                    filled: true, //<-- SEE HERE

                                    fillColor:
                                        Theme.of(context).colorScheme.onPrimary,

                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    disabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    errorBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    focusedErrorBorder:
                                        const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  )),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    filled: true, //<-- SEE HERE

                                    fillColor:
                                        Theme.of(context).colorScheme.onPrimary,

                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    disabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    errorBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),

                                    focusedErrorBorder:
                                        const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  )),
                            );
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Center(
                        child: MaterialButton(
                          onPressed: () {
                            loading(context);
                          },
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor,
                          textColor: Colors.white,
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(fontFamily: "Lato", fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ));
      });
}
