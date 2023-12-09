// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationproject/auth_screen.dart';
import 'package:graduationproject/transition_animation.dart';
import 'original_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: SingleChildScrollView(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Column(
              children: [
                Text(
                  "Forgot Password",
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 100,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
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
                        labelText: 'Enter your email address',
                        hintText: 'ex: test@gmail.com',
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(ScaleAnimationRoute(Page: AuthScreen()));
                  },
                  child: Text("Back to sign in",
                      style: Theme.of(context).textTheme.headline3),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: OriginalButton(
                    text: ('Reset Password'),
                    textColor: Colors.white,
                    bgColor: Theme.of(context).backgroundColor,
                    onPressed: () async {
                      final connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.wifi ||
                          connectivityResult == ConnectivityResult.mobile) {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: _email)
                                .then((value) => {
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.scale,
                                        dialogType: DialogType.success,
                                        body: Center(
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 15),
                                            child: const Text(
                                              "Email Sent Successfully",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        title: 'This is Ignored',
                                        btnOkOnPress: () {
                                          Navigator.of(context).push(
                                              ScaleAnimationRoute(
                                                  Page: AuthScreen()));
                                        },
                                      ).show(),
                                    });
                            // ignore: unused_catch_clause
                          } on FirebaseAuthException catch (e) {
                            // ignore: use_build_context_synchronously
                            AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.error,
                                    body: Center(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: const Text(
                                          "Email is not registered with us",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    title: 'This is Ignored',
                                    btnOkOnPress: () {
                                      Navigator.of(context).push(
                                          ScaleAnimationRoute(
                                              Page: AuthScreen()));
                                    },
                                    btnOkColor:
                                        const Color.fromRGBO(198, 48, 48, 1))
                                .show();
                          }
                        }
                      } else {
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
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          title: 'This is Ignored',
                        ).show();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(ScaleAnimationRoute(Page: AuthScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: Theme.of(context).textTheme.headline3),
                      Text("Sign Up ",
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  ),
                )
              ],
            ),
          ),
        )));
  }
}

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

final _formKey = GlobalKey<FormState>();

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              Text("Verification",
                  style: Theme.of(context).textTheme.headline5),
              const SizedBox(
                height: 90,
              ),
              Text("Enter Verification Code",
                  style: Theme.of(context).textTheme.headline2),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 45, right: 45.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 68,
                            width: 64,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              onSaved: (pin1) {},
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 68,
                            width: 64,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              onSaved: (pin2) {},
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 68,
                            width: 64,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              onSaved: (pin3) {},
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 68,
                            width: 64,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              onSaved: (pin4) {},
                              style: Theme.of(context).textTheme.headline6,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(1),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("If you didn’t receive a code! ",
                                style: Theme.of(context).textTheme.headline3),
                            Text("Resend",
                                style: Theme.of(context).textTheme.headline4),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: OriginalButton(
                        text: ('Verify'),
                        textColor: Colors.white,
                        bgColor: Theme.of(context).backgroundColor,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pushNamed('NewPassword');
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _password = '', _pass = '';
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool showPass = false;
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(children: [
                Text("New Password",
                    style: Theme.of(context).textTheme.headline5),
                const SizedBox(
                  height: 90,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text("Enter New Password",
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text("Confirm Password",
                          style: Theme.of(context).textTheme.headline2),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: showPass ? false : true,
                    onChanged: (value) => _pass = value,
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
                              showPass = !showPass;
                            });
                          },
                          child: Icon(
                            showPass
                                ? Icons.visibility_off
                                : Icons.remove_red_eye,
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 90,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: OriginalButton(
                    text: ('Submit'),
                    textColor: Colors.white,
                    bgColor: Theme.of(context).backgroundColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pushNamed('Login');
                      }
                    },
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title, description;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(widget.title, style: Theme.of(context).textTheme.headline4),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(widget.description,
                style: Theme.of(context).textTheme.bodyText1),
          ),
          const SizedBox(height: 15),
          const Divider(
            height: 1,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context)
                    .push(ScaleAnimationRoute(Page: AuthScreen()));
              },
              child: const Center(
                child: Text(
                  "OK",
                  style: TextStyle(
                      color: Color.fromRGBO(198, 48, 48, 1), fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
