import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/auth_screen.dart';
import 'package:graduationproject/transition_animation.dart';
import 'original_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'verification.dart';
//import 'package:email_auth/email_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final credential = FirebaseAuth.instance;

  var SelectedDay;
  var SelectedMonth;
  var SelectedYear;
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '', firstname = '', lastname = '';
  var phonenumber;
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            height: 620,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Theme.of(context).colorScheme.onPrimary),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ListView(
                      children: [
                        Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 15),
                            child: Text(
                              "Create Account",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    onChanged: (value) => firstname = value,
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter your first name'
                                        : null,
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.person,
                                        ),
                                        labelText: 'First Name',
                                        labelStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .labelStyle
                                        //labelStyle: TextStyle(fontSize: 13)
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    onChanged: (value) => lastname = value,
                                    validator: (value) => value!.isEmpty
                                        ? 'Enter your last name'
                                        : null,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person,
                                      ),
                                      labelText:
                                          'Last Name', //labelStyle: TextStyle(fontSize: 13)
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    onChanged: (value) => _email = value,
                                    validator: (value) {
                                      print(value);
                                      if (value!.isEmpty) {
                                        return "Please enter your email";
                                      } else if (!RegExp(
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(value)) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Email address',
                                      prefixIcon: Icon(
                                        Icons.email,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: showPassword ? false : true,
                                    onChanged: (value) => _password = value,
                                    validator: (value) => value!.length <= 6
                                        ? 'Your password must be larger than 6 characters'
                                        : null,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                      ),
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            setState(() {
                                              showPassword = !showPassword;
                                            });
                                          },
                                          child: Icon(
                                            showPassword
                                                ? Icons.visibility_off
                                                : Icons.remove_red_eye,
                                          )),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    onChanged: (value) => phonenumber = value,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your phone number ";
                                      } else if (!RegExp(
                                              r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
                                          .hasMatch(value)) {
                                        return "Please enter a valid phone number";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.call,
                                      ),
                                      labelText:
                                          'Phone number', //labelStyle: TextStyle(fontSize: 13)
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: OriginalButton(
                                      text: ('Register'),
                                      textColor: Colors.white,
                                      bgColor:
                                          Theme.of(context).backgroundColor,
                                      onPressed: () async {
                                        final connectivityResult =
                                            await (Connectivity()
                                                .checkConnectivity());
                                        if (connectivityResult ==
                                                ConnectivityResult.wifi ||
                                            connectivityResult ==
                                                ConnectivityResult.mobile) {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            try {
                                              final credential = await FirebaseAuth
                                                  .instance
                                                  .createUserWithEmailAndPassword(
                                                      email: _email.trim(),
                                                      password:
                                                          _password.trim());
                                              // ignore: use_build_context_synchronously
                                              await AwesomeDialog(
                                                autoHide: const Duration(
                                                    milliseconds: 3200),
                                                context: context,
                                                animType: AnimType.scale,
                                                dialogType:
                                                    DialogType.infoReverse,
                                                body: Center(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 15),
                                                    child: const Text(
                                                      "Please check your Email to verfiy your account",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                                title: 'This is Ignored',
                                                //btnOkOnPress: () {},
                                                //btnOkColor: const Color.fromRGBO(198, 48, 48, 1)
                                              ).show();
                                              credential.user!
                                                  .sendEmailVerification();
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop(
                                                  ScaleAnimationRoute(
                                                      Page: AuthScreen()));

                                              //print (credential.user!.emailVerified);

                                              await FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(credential.user!.uid)
                                                  .set({
                                                "First Name": firstname,
                                                "Last Name": lastname,
                                                "Phone Number": phonenumber,
                                                "Email address": _email,
                                                "Cart": [],
                                                "Custom Country": "",
                                                "Custom City": "",
                                                "Custom Subcity": "",
                                                "Custom Street": "",
                                                "Custom Thoroughfare": "",
                                                "Default Country": "",
                                                "Default City": "",
                                                "Default Subcity": "",
                                                "Default Street": "",
                                                "Default Thoroughfare": "",
                                                "Viewed Items": []
                                              });
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'weak-password') {
                                                print(
                                                    'The password provided is too weak.');
                                              } else if (e.code ==
                                                  'email-already-in-use') {
                                                print(
                                                    'The account already exists for that email.');
                                              }
                                              return null;
                                            } catch (e) {
                                              print(e);
                                              return null;
                                            }
                                          }
                                        } else {
                                          // ignore: use_build_context_synchronously
                                          AwesomeDialog(
                                            autoHide: const Duration(
                                                milliseconds: 2500),
                                            context: context,
                                            animType: AnimType.scale,
                                            dialogType: DialogType.error,
                                            body: Center(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 15),
                                                child: const Text(
                                                  "No internet connection",
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            title: 'This is Ignored',
                                          ).show();
                                        }
                                      },
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Already a user? ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3),
                                          Text("Login ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ])
                      ],
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: -15,
                        child: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              radius: 20,
                              child: Icon(
                                Icons.close,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            )))
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
