import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationproject/cart.dart';
import 'package:graduationproject/category_screen.dart';
import 'package:graduationproject/provider_controller.dart';
import 'package:lottie/lottie.dart';
import 'main.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'account.dart';


class NavigationBarController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigationBarControllerState();
  }
}

class NavigationBarControllerState extends State<NavigationBarController> {
  int selectedIndex = 0;
  List<Widget> navigationBarScreens = [
    HomePage(),
    CategoryScreen(),
    Cart(),
    const Account(),
    SettingsScreen()
  ];
getUser() {
    var user = FirebaseAuth.instance.currentUser;
    print(user!.email);
  }


  @override
  initState() {
  getUser();
    super.initState();
  }


  
Future<bool> _onWillPop() async {
     return (
      
      
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure?', style:  Theme.of(context).textTheme.bodyText1),
          content:  Text('Do you want to exit an App', style:  Theme.of(context).textTheme.bodyText1),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
              child: const Text('No', style : TextStyle (color: Color.fromRGBO(198, 48, 48, 1),) ),
            ),
            TextButton(
              onPressed: () {SystemNavigator.pop();},
               // <-- SEE HERE
              child: const Text('Yes', style:  TextStyle (color: Color.fromRGBO(198, 48, 48, 1),)),
            ),
          ],
        ),
      )
      ) ??
      false;
  }

  @override
  Widget build(BuildContext context) {

    final provider = ProviderController.of(context);
    void loading(int value){
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
            nextScreen: CategoryScreen());
      },
    );
      Future.delayed(const Duration(milliseconds: 4000),() {
        Navigator.pop(context);
         setState(() {
           selectedIndex = value;
         });
      },);
    }

    return WillPopScope(

      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton:FloatingActionButton(onPressed: (){
          provider.checkConnectivity();
          setState(() {
            selectedIndex = 2;
          });
        }, child:Icon(selectedIndex == 2 ? Icons.shopping_cart : Icons.shopping_cart_outlined,color: Theme.of(context).floatingActionButtonTheme.hoverColor)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            children: [
              Row(
                children: [MaterialButton(onPressed: (){
                  //provider.x.clear();
                  //print(provider.x);
                  provider.flag = 0;
                  provider.checkConnectivity();
                  loading(0);
                },child: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined,color:Theme.of(context).iconTheme.color,size: 30,),),
                MaterialButton(onPressed: (){
                  //provider.x=[{"Name":"Masalas","Image":"Masalas.jpg"},{"Name":"Spices","Image":"Spices.jpg"},{"Name":"Edible Oil & Ghee","Image":"Oil&Ghee.jpg"}];
                  //print(provider.x);
                  provider.flag = 1;
                  provider.category = "Oil & Masala";
                  provider.getCategoryId(provider.category);
                  provider.checkConnectivity();
                  provider.selectedCategoryBackGroundColor.clear();
                  provider.selectedCategoryLableColor.clear();
                  provider.selectedCategoryBackGroundColor.add(true);
                  provider.selectedCategoryLableColor.add(true);
                    loading(1);
                },child: Icon(selectedIndex == 1 ? Icons.category : Icons.category_outlined,color:Theme.of(context).iconTheme.color,size: 30,),),
                ],
              ),
              const Spacer(),
              Row(children: [
                MaterialButton(onPressed: (){
                  provider.checkConnectivity();
                  setState(() {
                    selectedIndex = 3;
                  });
                },child: Icon(selectedIndex == 3 ? Icons.person_rounded : Icons.person_outline_rounded,color:  Theme.of(context).iconTheme.color,size: 30,),),
                MaterialButton(onPressed: (){
                  setState(() {
                    
                    selectedIndex = 4;
                  });
                },child: Icon(selectedIndex == 4 ? Icons.settings: Icons.settings_outlined,color:Theme.of(context).iconTheme.color,size: 30,),)
              ],)
            ],
          ),
        ),
        body: navigationBarScreens.elementAt(selectedIndex),
      ),
    );
  }
}




