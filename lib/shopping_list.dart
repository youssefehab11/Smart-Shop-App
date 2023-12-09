

import 'package:flutter/material.dart';
import 'package:graduationproject/provider_controller.dart';

class ShoppingList extends StatefulWidget {
  @override
  State<ShoppingList> createState() {
    return ShoppingListState();
  }
}

class ShoppingListState extends State<ShoppingList> {
  List<bool> checked = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  List subCategory = [
    {"Item Name": "Biscuits", "Image": "assets/images/Biscuits.jpg"},
    {"Item Name": "Bread", "Image": "assets/images/Bread.jpg"},
    {"Item Name": "Cakes", "Image": "assets/images/Cakes.jpg"},
    {"Item Name": "Chicken", "Image": "assets/images/Chicken.jpg"},
    {"Item Name": "Chocolates", "Image": "assets/images/Chocolates.jpg"},
    {"Item Name": "Cookies", "Image": "assets/images/Cookies.jpg"},
    {"Item Name": "Eggs", "Image": "assets/images/Eggs.jpg"},
    {"Item Name": "Fish", "Image": "assets/images/Fish.jpg"},
    {"Item Name": "Flour", "Image": "assets/images/Flour.jpg"},
    {"Item Name": "Fruits", "Image": "assets/images/Fruits.jpg"},
    {"Item Name": "Health", "Image": "assets/images/Healthydrinks.jpg"},
    {"Item Name": "Masalas", "Image": "assets/images/Masalas.jpg"},
    {"Item Name": "Meat", "Image": "assets/images/Meat.jpg"},
    {"Item Name": "Noodles", "Image": "assets/images/Noodles.jpg"},
    {"Item Name": "Oil&Ghee", "Image": "assets/images/Oil&Ghee.jpg"},
    {"Item Name": "Rice", "Image": "assets/images/Rice.jpg"},
    {"Item Name": "Soft drinks", "Image": "assets/images/Soft drinks.jpg"},
    {"Item Name": "Spices", "Image": "assets/images/Spices.jpg"},
    {"Item Name": "Vegetables", "Image": "assets/images/Vegetables.jpg"},
  ];

  //List<String> savedItemsNames = [];
  List savedItemsImages = [];
  final budget = TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            "Shopping List",
            style: TextStyle(color: Colors.white, fontSize: 25,fontFamily: "Poppins",fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
          Column(children: [
          Container(
            padding: const EdgeInsets.only(left: 5, top: 5),
            width: double.infinity,
            height: 30,
            color: Theme.of(context).colorScheme.onBackground,
            child: const Text(
              "Budget",
              style: TextStyle(
                  //color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lato",),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Container(
              margin: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width-200,
              height: 80,
              child: Form(
                child: TextFormField(
                  maxLength: 4,
                controller: budget,
                showCursor: true,
                cursorWidth: 1,
                cursorHeight: 27,
                keyboardType: TextInputType.number,
                cursorColor: Colors.grey[600],
                decoration: InputDecoration(
                  label: const Text("Budget",style: TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color.fromRGBO(66, 66, 66, 1))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color.fromRGBO(66, 66, 66, 1))
                  ), 
                ),
                
              ),)
            ),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Row(
                children:  [
                   Text("${provider.budget}",style:const TextStyle(fontSize: 25,fontFamily: "Poppins")),
               const SizedBox(width: 5,),
               const Text("EGP",style: TextStyle(fontSize: 25,fontFamily: "Poppins"),)
                ],
              ),
            )
          ],),
          ListTile(trailing: MaterialButton(onPressed: (){
            if(budget.text.isEmpty){
              setState(() {
                provider.budget = 0;
              });
            }
            else{
              provider.saveValue(double.parse(budget.text));
            }
            
          },
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          textColor: Colors.white,
          child: const Text("Save",style: TextStyle(fontFamily: "Lato",fontSize: 17),),
          ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5, top: 5),
            width: double.infinity,
            height: 30,
            color: Theme.of(context).colorScheme.onBackground,
            child: const Text(
              "Grocery List",
              style: TextStyle(
                  //color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lato"),
            ),
          ),
          provider.savedItemsNames.isEmpty?  
          Column(
            mainAxisAlignment: MainAxisAlignment.center, 
          children: const [Text("List is Empty",style: TextStyle(fontFamily: "Lato",fontSize: 17)),])
            : StatefulBuilder(
                builder: (context, setState) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height-280,
                        child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: provider.savedItemsNames.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                              key: Key(provider.savedItemsNames[index]),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                provider.deleteItem(index);
                              },
                              background: Container(
                                  height: 72,
                                  color: const Color.fromRGBO(198, 48, 48, 1),
                                  child: const ListTile(
                                    trailing: Icon(
                                      Icons.delete_rounded,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )),
                              child: SizedBox(
                                height: 72,
                                child: Column(children: [
                                  Container(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 1,
                                              offset: const Offset(1, 1),
                                              spreadRadius: 0.5,
                                              color:
                                                  Theme.of(context).shadowColor)
                                        ],
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20)),
                                          Container(
                                            height: 55,
                                            width: 55,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                      blurRadius: 1,
                                                      offset: const Offset(
                                                          1.5, 1.5),
                                                      spreadRadius: 0.5,
                                                      color: Theme.of(context)
                                                          .shadowColor),
                                                ],
                                                image: DecorationImage(
                                                    image: AssetImage(provider
                                                            .savedItemsImages[
                                                        index]),
                                                    fit: BoxFit.cover)),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            provider.savedItemsNames[index],
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                ]),
                              ));
                        },
                      ),
                      );
                    },
                  );
                },
              ),
        ],),
        ],),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Theme.of(context).floatingActionButtonTheme.hoverColor,
          ),
          onPressed: () {
            if (provider.savedItemsNames.isNotEmpty) {}
            showGeneralDialog(
                transitionDuration: const Duration(milliseconds: 500),
                context: context,
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = const Offset(0.0, -1);
                  var end = const Offset(0, 0);
    
                  var tween = Tween(begin: begin, end: end);
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secondaryAnimation) => Center(
                        child: Container(
                      height: 430,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Theme.of(context).colorScheme.onPrimary),
                      child: Scaffold(
                          backgroundColor: Colors.transparent,
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.miniEndFloat,
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              provider.makeListItemName(checked, subCategory);
                              provider.makeListItemImage(checked, subCategory);
                              Navigator.of(context).pop();
                            },
                            mini: true,
                            child: Icon(
                              Icons.done_rounded,
                              color: Theme.of(context)
                                  .floatingActionButtonTheme
                                  .hoverColor,
                            ),
                          ),
                          body: StatefulBuilder(
                            builder: (context, setState) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          bottom: 20,
                                          left: 5,
                                          right: 5),
                                      height: 430,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      child: ListView.builder(
                                        physics:
                                            const BouncingScrollPhysics(),
                                        itemCount: subCategory.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                  height: 70,
                                                  width:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          45,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(30),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          blurRadius: 1,
                                                          offset:
                                                              const Offset(
                                                                  1, 1),
                                                          spreadRadius: 0.5,
                                                          color: Theme.of(
                                                                  context)
                                                              .shadowColor)
                                                    ],
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                                  left:
                                                                      20)),
                                                      Container(
                                                        height: 55,
                                                        width: 55,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        50),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      blurRadius:
                                                                          1,
                                                                      offset: const Offset(1.5,
                                                                          1.5),
                                                                      spreadRadius:
                                                                          0.5,
                                                                      color:
                                                                          Theme.of(context).shadowColor)
                                                                ],
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "${subCategory[index]["Image"]}"),
                                                                    fit: BoxFit
                                                                        .cover)),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        "${subCategory[index]["Item Name"]}",
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: "Lato"
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Container(
                                                        margin:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: Checkbox(
    
                                                          value: checked[
                                                              index],
                                                          onChanged: (val) {
                                                            setState(() {
                                                              checked[index] =
                                                                  val!;
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              )
                                            ],
                                          );
                                        },
                                      )),
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: -15,
                                      child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.white,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            radius: 20,
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            ),
                                          )))
                                ],
                              );
                            },
                          )),
                    )));
          },
        ));
  }
}
