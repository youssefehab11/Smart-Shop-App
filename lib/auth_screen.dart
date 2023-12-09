import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/navigationbar_controller_screen.dart';
import 'package:graduationproject/original_button.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/register_screen.dart';
import 'package:graduationproject/transition_animation.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'forgot_password.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AuthScreen extends StatefulWidget {
  final user = FirebaseAuth.instance;

  AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  late SMITrigger error;
  late SMITrigger check;
  late SMITrigger reset;
  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    return controller;
  }

  final provier = ProviderController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool showPassword = false;

  String _email = '', _password = '';

  late RiveAnimationController btnAnimationController;

  @override
  void initState() {
    super.initState();
    btnAnimationController = OneShotAnimation("active", autoplay: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset("assets/images/Spline.jpg"),
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          )),
          const RiveAnimation.asset(
            "assets/rive/shapes.riv",
            fit: BoxFit.cover,
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: const SizedBox(),
          )),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("S-Mart", style: Theme.of(context).textTheme.headline1),
                const Text(
                  "Welcom to S Mart, it's great to meet you! we promise to keep you up-to-date with the best new sales, tell you about our awesome offers and throw in the odd surprise...",
                  style: TextStyle(fontFamily: "Lato", fontSize: 20),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    btnAnimationController.isActive = true;
                    Future.delayed(const Duration(milliseconds: 750), () {
                      _passwordController.text = '';
                      _emailController.text = '';
                      showGeneralDialog(
                          transitionDuration: const Duration(milliseconds: 500),
                          context: context,
                          transitionBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = 0.0;
                            var end = 1.0;
                            var curvesAnimation = CurvedAnimation(
                                parent: animation, curve: Curves.easeIn);
                            var tween = Tween(begin: begin, end: end);
                            return ScaleTransition(
                              scale: tween.animate(curvesAnimation),
                              child: child,
                            );
                          },
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Center(
                                    child: Container(
                                      height: 620,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                      child: Scaffold(
                                          backgroundColor: Colors.transparent,
                                          body: StatefulBuilder(
                                            builder: (context, setState) {
                                              return Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  ListView(
                                                    children: [
                                                      Center(
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 50,
                                                                      bottom:
                                                                          15),
                                                              child: Text(
                                                                "Sign In",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline5,
                                                              ),
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 16,
                                                                      right: 16,
                                                                      bottom:
                                                                          60),
                                                              child: Text(
                                                                "Sign in to your own account to start online shopping, Hope to enjoy with S Mart...",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Lato"),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            //Spacer(),
                                                            Form(
                                                                key: _formKey,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      TextFormField(
                                                                        controller:
                                                                            _emailController,
                                                                        onChanged:
                                                                            (value) =>
                                                                                _email = value,
                                                                        validator:
                                                                            (value) {
                                                                          // ignore: avoid_print
                                                                          print(
                                                                              value);
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return "Please enter your email";
                                                                          } else if (!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                                                              .hasMatch(value)) {
                                                                            return "Please enter a valid email";
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          labelText:
                                                                              'Enter your email ',
                                                                          hintText:
                                                                              'ex: test@gmail.com',
                                                                          prefixIcon:
                                                                              Icon(
                                                                            Icons.email,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      TextFormField(
                                                                        controller:
                                                                            _passwordController,
                                                                        obscureText: showPassword
                                                                            ? false
                                                                            : true,
                                                                        onChanged:
                                                                            (value) =>
                                                                                _password = value,
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return "Please enter your password";
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              'Enter your password',
                                                                          prefixIcon:
                                                                              const Icon(
                                                                            Icons.lock,
                                                                          ),
                                                                          suffixIcon: InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  showPassword = !showPassword;
                                                                                });
                                                                              },
                                                                              child: Icon(
                                                                                showPassword ? Icons.visibility_off : Icons.remove_red_eye,
                                                                              )),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pushReplacement(SlideLeftAnimationRoute(Page: const ForgotPassword()));
                                                                        },
                                                                        child: Text(
                                                                            "Forgot password?",
                                                                            style:
                                                                                Theme.of(context).textTheme.headline3),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            25,
                                                                      ),
                                                                      OriginalButton(
                                                                        text:
                                                                            ('Login'),
                                                                        textColor:
                                                                            Colors.white,
                                                                        bgColor:
                                                                            Theme.of(context).backgroundColor,
                                                                        onPressed:
                                                                            () async{
                                                                              
                                                                              final connectivityResult = await (Connectivity().checkConnectivity());
                                                                              // ignore: avoid_print
                                                                              print(connectivityResult);
                                                                          setState(
                                                                              () {
                                                                            isShowLoading =
                                                                                true;
                                                                          });
                                                                          // ignore: unrelated_type_equality_checks
                                                                          if(connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.mobile){
                                                                            Future
                                                                              .delayed(
                                                                            const Duration(seconds: 1),
                                                                            () async {
                                                                              if (_formKey.currentState!.validate()) {
                                                                                try {
                                                                                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);

                                                                                  Future.delayed(
                                                                                    const Duration(seconds: 2),
                                                                                    () async {
                                                                                      setState(() {
                                                                                        isShowLoading = false;
                                                                                      });

                                                                                      if (userCredential.user!.emailVerified) {
                                                                                        AwesomeDialog(
                                                                                          autoHide: const Duration(milliseconds: 1500),
                                                                                          context: context,
                                                                                          animType: AnimType.scale,
                                                                                          dialogType: DialogType.success,
                                                                                          body: Center(
                                                                                            child: Container(
                                                                                              margin: const EdgeInsets.only(bottom: 15),
                                                                                              child: const Text(
                                                                                                "Login Success!",
                                                                                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          title: 'This is Ignored',
                                                                                        ).show();
                                                                                        await Future.delayed(
                                                                                          const Duration(seconds: 2),
                                                                                          () {
                                                                                            setState(() {
                                                                                              isShowLoading = false;
                                                                                            });
                                                                                          },
                                                                                        );
                                                                                        // ignore: use_build_context_synchronously
                                                                                        Navigator.of(context).pushReplacement(SlideLeftAnimationRoute(Page: NavigationBarController()));
                                                                                      } else {
                                                                                        _passwordController.text = '';
                                                                                        _emailController.text = '';
                                                                                        AwesomeDialog(
                                                                                                context: context,
                                                                                                animType: AnimType.scale,
                                                                                                dialogType: DialogType.error,
                                                                                                body: Center(
                                                                                                  child: Container(
                                                                                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                                    child: const Text(
                                                                                                      "Email is not verified! Please check your Inbox...",
                                                                                                      style: TextStyle(fontSize: 18),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                                title: 'This is Ignored',
                                                                                                btnOkOnPress: () {},
                                                                                                btnOkColor: const Color.fromRGBO(198, 48, 48, 1))
                                                                                            .show();
                                                                                      }
                                                                                    },
                                                                                  );
                                                                                } on FirebaseAuthException catch (e) {
                                                                                  if (e.code == 'user-not-found') {
                                                                                    _passwordController.text = '';
                                                                                    _emailController.text = '';
                                                                                    AwesomeDialog(
                                                                                            context: context,
                                                                                            animType: AnimType.scale,
                                                                                            dialogType: DialogType.error,
                                                                                            body: Center(
                                                                                              child: Container(
                                                                                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                                child: const Text(
                                                                                                  "No user with this Email!",
                                                                                                  style: TextStyle(fontSize: 18),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            title: 'This is Ignored',
                                                                                            btnOkOnPress: () {},
                                                                                            btnOkColor: const Color.fromRGBO(198, 48, 48, 1))
                                                                                        .show();
                                                                                    Future.delayed(
                                                                                      const Duration(seconds: 2),
                                                                                      () {
                                                                                        setState(() {
                                                                                          isShowLoading = false;
                                                                                        });
                                                                                      },
                                                                                    );
                                                                                  } else if (e.code == 'wrong-password') {
                                                                                    _passwordController.text = '';
                                                                                    _emailController.text = '';
                                                                                    AwesomeDialog(
                                                                                            context: context,
                                                                                            animType: AnimType.scale,
                                                                                            dialogType: DialogType.error,
                                                                                            body: Center(
                                                                                              child: Container(
                                                                                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                                                                                child: const Text(
                                                                                                  "Wrong Password!",
                                                                                                  style: TextStyle(fontSize: 18),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            title: 'This is Ignored',
                                                                                            btnOkOnPress: () {},
                                                                                            btnOkColor: const Color.fromRGBO(198, 48, 48, 1))
                                                                                        .show();
                                                                                    Future.delayed(
                                                                                      const Duration(seconds: 2),
                                                                                      () {
                                                                                        setState(() {
                                                                                          isShowLoading = false;
                                                                                        });
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                }
                                                                              } else {
                                                                                error.fire();
                                                                                Future.delayed(
                                                                                  const Duration(seconds: 2),
                                                                                  () {
                                                                                    setState(() {
                                                                                      isShowLoading = false;
                                                                                    });
                                                                                  },
                                                                                );
                                                                              }
                                                                            },
                                                                          );
                                                                          
                                                                          }
                                                                          else{
                                                                            Future.delayed(const Duration(seconds: 2),() {
                                                                              setState(
                                                                              () {
                                                                            isShowLoading =
                                                                                false;
                                                                          });
                                                                          
                                                                          // ignore: use_build_context_synchronously
                                                                          AwesomeDialog(
                                                                                          autoHide: const Duration(milliseconds: 2500),
                                                                                          context: context,
                                                                                          animType: AnimType.scale,
                                                                                          dialogType: DialogType.error,
                                                                                          body: Center(
                                                                                            child: Container(
                                                                                              margin: const EdgeInsets.only(bottom: 15),
                                                                                              child: const Text(
                                                                                                "No internet connection",
                                                                                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          title: 'This is Ignored',
                                                                                        ).show();
                                                                            },);
                                                                          }
                                                                          
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Positioned(
                                                      left: 0,
                                                      right: 0,
                                                      bottom: -15,
                                                      child: CircleAvatar(
                                                          radius: 20,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            radius: 20,
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color,
                                                            ),
                                                          ))),
                                                  isShowLoading
                                                      ? CustomPosintioned(
                                                          child: RiveAnimation
                                                              .asset(
                                                            "assets/rive/checkerror.riv",
                                                            onInit: (artboard) {
                                                              StateMachineController
                                                                  controller =
                                                                  getRiveController(
                                                                      artboard);
                                                              check = controller
                                                                      .findSMI(
                                                                          "Check")
                                                                  as SMITrigger;
                                                              error = controller
                                                                      .findSMI(
                                                                          "Error")
                                                                  as SMITrigger;
                                                              reset = controller
                                                                      .findSMI(
                                                                          "Reset")
                                                                  as SMITrigger;
                                                            },
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              );
                                            },
                                          )),
                                    ),
                                  ));
                    });
                  },
                  child: Center(
                    child: SizedBox(
                        height: 64,
                        width: 300,
                        child: Stack(
                          children: [
                            RiveAnimation.asset(
                              "assets/rive/button.riv",
                              controllers: [btnAnimationController],
                            ),
                            const Positioned.fill(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.arrow_right,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Sign In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.black),
                                )
                              ],
                            ))
                          ],
                        )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showGeneralDialog(
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            RegisterScreen(),
                        transitionDuration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = 0.0;
                          var end = 1.0;
                          var curvesAnimation = CurvedAnimation(
                              parent: animation, curve: Curves.easeIn);
                          var tween = Tween(begin: begin, end: end);
                          return ScaleTransition(
                            scale: tween.animate(curvesAnimation),
                            child: child,
                          );
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ",
                            style: Theme.of(context).textTheme.headline3),
                        Text("Sign Up ",
                            style: Theme.of(context).textTheme.headline4)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class CustomPosintioned extends StatelessWidget {
  const CustomPosintioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}
