import 'package:flutter/material.dart';
import 'package:graduationproject/transition_animation.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Help",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 75,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("I can't place my order",
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 30,),
                  ],
                ),
              ),
              onTap: () {
                
              },
            ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).colorScheme.secondaryContainer,
              height: 0.5,
              child: const Divider(),
            ),
            SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 75,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("Online payment didn't go through",
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 30,),
                  ],
                ),
              ),
              onTap: () {
                
              },
            ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).colorScheme.secondaryContainer,
              height: 0.5,
              child: const Divider(),
            ),
            SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 75,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("I didn't recieve my order",
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 30,),
                  ],
                ),
              ),
              onTap: () {
                
              },
            ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).colorScheme.secondaryContainer,
              height: 0.5,
              child: const Divider(),
            ),
            SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 75,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text("FAQ",
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Icon(Icons.keyboard_arrow_right,
                        color: Theme.of(context).colorScheme.onBackground,
                        size: 30,),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(SlideLeftAnimationRoute(Page: const FAQ()));
              },
            ),
            ),
          ],
        ));
  }
}

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  bool isVisible = false;
  bool theme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "FAQ",
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text("What is S-Mart?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "S-Mart is a leading online grocery delivery service that operates in Egypt.\nOur Application offers all fresh food that you might need for your kitchen.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text("How do I place an order on S-Mart?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "Go to S-Mart app, log in with your account, then select products that you want to buy, add them to cart, press on checkout then fill your information and confirm your order.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text("Can I re-order a previous order?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "Yes. In the app, you can simply go to the 'My Orders' section and choose an order from your previous orders, and re-order it.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 15, left: 8, right: 8, bottom: 15),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text("How can I add a new address?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "After checkout. Click on 'Change Address' then you will be able to add the new address details.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text(
                          "I was not happy with my order? Who should I contact?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "If you have any issues with your order, you can notify us by calling our call center number.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
              child: Column(
                children: [
                  Container(
                    color:Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text(
                          "I paid online and then my order was cancelled. How long will it take for my online payment to be refunded?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "In most cases, the online payment was not charged but only put on hold by the bank. the bank immediately releases the payment hold upon canceled orders. Most of the time this should be reflected in your account within 24 hours. Some credit card provider banks, however, can take 7-14 days to release the funds after the application requests the release of the hold. This is outside of S-Mart's control and the best course of action, if this happens, is to call your bank.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text("How do I search for an item?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "Simply type the name of the product that you’re looking for in the search bar.\nThe search bar can be found on the top of your page.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text("Do you have special offers?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "Yes. You can view the latest offers in offers tab at home page.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
              child: Column(
                children: [
                  Container(
                    color:Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text(
                          "Can I make a payment online in a foreign currency?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "S-Mart currently only accepts Egyptian pounds.",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 15),
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.onBackground,
                    child: ExpansionTile(
                      title: Text("How can I contact S-Mart?",
                          style: Theme.of(context).textTheme.headline4),
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            title: Text(
                                "You can contact us anytime through our call center number (+20 1060004750).",
                                style: Theme.of(context).textTheme.headline6),
                          ),
                        )
                      ],
                      onExpansionChanged: (bool expanded) {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}