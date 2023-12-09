import 'package:flutter/material.dart';
import 'package:graduationproject/auth_screen.dart';
import 'package:graduationproject/intro_screen.dart';
import 'package:graduationproject/navigationbar_controller_screen.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:graduationproject/register_screen.dart';
import 'package:graduationproject/test.dart';
import 'package:provider/provider.dart';
import 'about.dart';
import 'package:graduationproject/theme_manager';
import 'package:graduationproject/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'forgot_password.dart';
import 'transition_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'help.dart';


bool islogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
var user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }


  runApp(MyApp());
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: _themeManager.themeMode,
        home: IntroScreen(),
        routes: {
          'Login': (context) => AuthScreen(),
          'Register': (context) => RegisterScreen(),
          'Home': (context) => NavigationBarController(),
          //'test 2':  (context) => test2(),
          'test': (context) => test(),
          'ForgotPassword': (context) => ForgotPassword(),
          'Verification': (context) => Verification(),
          'NewPassword': (context) => NewPassword(),
          //'About': (context) => AboutPage(),
          // 'AboutApp': (context) => AboutApp(),
          //'PrivacyPolicy': (context) => PrivacyPolicy(),
          //'Help': (context) => FAQ(),
        },
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
  var selectedCountry;
  var selectedLanguage;
  bool notify = false;
  bool theme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        //elevation: 0.0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5, top: 5),
            width: double.infinity,
            height: 30,
            color: _themeManager.themeMode == ThemeMode.dark
                ? Colors.grey[800]
                : Colors.grey[300],
            child: const Text(
              "Common",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Lato",
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 60),
                    ),
                    const Icon(Icons.notifications_none),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        "Notifications",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Switch(
                        value: notify,
                        onChanged: (val) {
                          setState(() {
                            notify = val;
                          });
                        }),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.grey[850]
                      : const Color.fromARGB(255, 255, 255, 255),
                  height: 0.5,
                  child: const Divider(),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 60),
                    ),
                    const Icon(Icons.dark_mode_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        "Dark Mode",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Switch(
                        //activeColor: _themeManager.themeMode == ThemeMode.dark?Colors.purpleAccent:Colors.deepPurple,
                        value: _themeManager.themeMode == ThemeMode.dark,
                        onChanged: (val) {
                          setState(() {
                            _themeManager.toggleTheme(val);
                          });
                        }),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.grey[850]
                      : const Color.fromARGB(255, 255, 255, 255),
                  height: 0.5,
                  child: const Divider(),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  width: double.infinity,
                  height: 30,
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  child: const Text(
                    "Regional",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 60),
                    ),
                    const Icon(Icons.flag_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        "Country",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    DropdownButton(
                      hint: const Text("Choose Country"),
                      items: ["Egypt", "USA", "China", "Russia", "England"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCountry = val;
                        });
                      },
                      value: selectedCountry,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.grey[850]
                      : const Color.fromARGB(255, 255, 255, 255),
                  height: 0.5,
                  child: const Divider(),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 60),
                    ),
                    const Icon(Icons.language_outlined),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        "Language",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    DropdownButton(
                      hint: const Text("English"),
                      items: ["English", "Arabic"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedLanguage = val;
                        });
                      },
                      value: selectedLanguage,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  width: double.infinity,
                  height: 30,
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  child: const Text(
                    "Reach out to us",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                MaterialButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: const Color.fromARGB(0, 69, 69, 69),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          context: context,
                          builder: ((context) {
                            return SizedBox(
                              height: 140,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      launchUrl(Uri.parse("tel:+201060004750"));
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      width: double.infinity,
                                      height: 65,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black45),
                                      child: Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: const Icon(
                                              Icons.phone_in_talk,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                          const Text(
                                            "(+20) 1060004750",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    198, 48, 48, 1),
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Lato"),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 0,
                                    height: 5,
                                    color: Color.fromARGB(0, 69, 69, 69),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      width: double.infinity,
                                      height: 65,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.black87),
                                      child: const Center(
                                          child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(198, 48, 48, 1),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Lato"),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }));
                    },
                    height: 60,
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone_in_talk_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text("Contact Us",
                            style: Theme.of(context).textTheme.headline6)
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.grey[850]
                      : const Color.fromARGB(255, 255, 255, 255),
                  height: 0.5,
                  child: const Divider(),
                ),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(SlideLeftAnimationRoute(Page: const Help()));
                    },
                    height: 60,
                    child: Row(
                      children: [
                        Icon(
                          Icons.help_outline_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text("Help",
                            style: Theme.of(context).textTheme.headline6)
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: _themeManager.themeMode == ThemeMode.dark
                      ? Colors.grey[850]
                      : const Color.fromARGB(255, 255, 255, 255),
                  height: 0.5,
                  child: const Divider(),
                ),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          SlideLeftAnimationRoute(Page: const AboutPage()));
                    },
                    height: 60,
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text("About",
                            style: Theme.of(context).textTheme.headline6)
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}




