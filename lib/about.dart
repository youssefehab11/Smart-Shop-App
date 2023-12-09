import 'package:flutter/material.dart';
import 'package:graduationproject/transition_animation.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "About",
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
                        child: Text("Terms and Conditions",
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(SlideLeftAnimationRoute(
                      Page: const TermsAndConditions()));
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
                        child: Text("Privacy Policy",
                            style: Theme.of(context).textTheme.headline6),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      SlideLeftAnimationRoute(Page: const PrivacyPolicy()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text("App Version 12.2.0",
                  style: Theme.of(context).textTheme.headline3),
            )
          ],
        ));
  }
}

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "About App",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              Text(
                  "S-Mart is the easiest and fastest way to have your groceries delivered to your doorstep around Egypt.\nFree your time from the supermarkets’ long queues, the search for parking spaces and carrying it all home. Our user-friendly app is packed with powerful features that will transform your grocery shopping experience. ",
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ));
  }
}

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool isVisible = false;
  bool theme = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Terms and Conditions",
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
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Our Delivery Service",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "When you place an order, we use all reasonable efforts to deliver to you at the time. Once you place your order online, we will prepare for the ordered products. You can modify an existing order at any time up until the order leaves the store by calling our customer service number at (+20)1060004750. Please note that we reserve the right to refuse service to anyone. We reserve the right to change the cost of deliveries and/or our delivery fees at any time.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Price and Availability",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "From time to time, products you order may be unavailable. If we are unable to fulfill your entire order, we will make every reasonable effort to suggest the closest product for you. We do not set the prices for the items you select on your grocery list. We pay the prices that each individual store has already set.\nTo receive delivery, you do not need to be present to receive your order from our driver. In the case of bad weather or unforeseen delivery complications, deliveries may be delayed. We will make every effort to get your groceries to you at closest time.\nYour order will arrive with an invoice that will list all of the items you have received and were billed for. If something is missing from your order, please call us so that we can do everything reasonable in our power to ensure your satisfaction.\nProduct information contained on the application or in our advertisements is offered as a convenience and should not be deemed as accurate. Information contained on the website or in our advertisements should not be used by you to evaluate ingredient information, nutritional values, or potential food allergies. The company assumes no responsibility for such information.\nOur drivers are allowed to accept tips. Customers are under no obligation to tip drivers but have the option of doing so at their discretion.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Payment",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "You can choose from the following ways of paying on delivery, depending on the products, the means of dispatch and as per technical availability:\n1.  Credit card reader on delivery.\n2.  Cash on delivery.\n3.  Online payment.\nWe accept payments online using visa, MasterCard and  debit card in the currency of the country where the user is located at the time of ordering.\nIf  you make a payment for our products or services on our website or application, the details you are asked to submit will be provided directly to our payment provider via a secured connection.\n The cardholder must retain a copy of transaction records and merchant policies and rules.\nThe user can select which payment method is preferred. The payment methods available are displayed for selection when the order is finalized. If for any reason the online payment transaction is declined, s-mart is entitled, at its soles discretion, to offer the user cash on delivery payment option or credit card reader on delivery where available.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Your Personal Information",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "You are responsible for, and agree to pay promptly, all charges to your account, including applicable taxes and purchases by you or anyone you allow to use your credit card. You agree and accept responsibility for keeping all your account information current, including name, credit card information, telephone number, and e-mail address. You can update your information anytime that you place an order. You agree that you will not provide fraudulent information and that you are solely responsible for any information you provide to us. You will comply with all laws applicable to your activities on the site and with this agreement. Our secure server encrypts your credit card information, among other things so that it cannot be read as the information travels over the internet. Once we receive your credit card information, it is stored in our secure data center. S-mart will exercise commercially reasonable efforts to ensure that your credit card information remains confidential at all times. When our order form asks users to enter sensitive information, such as a credit card number, that information is encrypted and is protected with encryption software.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 8, right: 8, bottom: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Future Amendments",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "S-Mart may amend this agreement at any time by posting the amended terms on our site. All amended terms shall automatically be effective at the time they are initially posted on our site. By accessing this site after the effective date of any such amendment, you agree to be bound by any such revisions and should therefore periodically visit this page to determine the then current agreement to which you are bound. Customers who prefer to place order by telephone agree to be bound by the terms of this agreement, as amended from time to time. In all cases, as a condition of making deliveries to you, you agree to review this agreement from time to time.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            "Privacy Policy",
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
                padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Personal Data",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "While using our service, we may ask you to provide us with certain personally identifiable information that can be used to contact or identify you. Personally identifiable information may include, but is not limited to:\n1. Email address\n2. First name and last name\n3. Phone number\n4.Usage Data",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Use of Your Personal Data",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "The company may use personal data for the following purposes:\n1. To provide and maintain our service: including to monitor the usage of our service.\n2. To manage your account: to manage your registration as a user of the service. The personal data you provide can give you access to different functionalities of the service that are available to you as a registered user.\n3. For the performance of a contract: the development, compliance and undertaking of the purchase contract for the products, items or services you have purchased or of any other contract with us through the service.\n4. To contact you: to contact you by email, telephone calls, sms, or other equivalent forms of electronic communication, such as a mobile application's push notifications regarding updates or informative communications related to the functionalities, products or contracted services, including the security updates, when necessary or reasonable for their implementation.\n5. To provide you with news, special offers and general information about other products which we offer that are similar to those that you have already purchased or enquired about unless you have opted not to receive such information.\n6. To manage your requests: to attend and manage your requests to us.\n7. For other purposes: we may use your information for other purposes, such as data analysis, identifying usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve our service, products, services, marketing and your experience.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Retention of Your Personal Data",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "The application will retain your personal data only for as long as is necessary for the purposes set out in this privacy policy. We will retain and use your personal data to the extent necessary to comply with our legal obligations (for example, if we are required to retain your data to comply with applicable laws), resolve disputes, and enforce our legal agreements and policies.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Delete Your Personal Data",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "You have the right to delete or request that we assist in deleting the personal data that we have collected about you.\nOur service may give you the ability to delete certain information about you from within the service.\nYou may update, amend, or delete your information at any time by signing in to your account, if you have one, and visiting the account settings section that allows you to manage your personal information. You may also contact us to request access to, correct, or delete any personal information that you have provided to us.\nPlease note, however, that we may need to retain certain information when we have a legal obligation or lawful basis to do so.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Security of Your Personal Data ",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "The security of your personal data is important to us, but remember that no method of transmission over the internet, or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your personal data, we cannot guarantee its absolute security.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Childern's Privacy ",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "Our service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from anyone under the age of 13. If you are a parent or guardian and you are aware that your child has provided us with personal data, please contact us. If we become aware that we have collected personal data from anyone under the age of 13 without verification of parental consent, we take steps to remove that information from our servers.\nIf we need to rely on consent as a legal basis for processing your information and your country requires consent from a parent, we may require your parent's consent before we collect and use that information.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 8.0, left: 8.0, top: 15, bottom: 15),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.onBackground,
                          child: ExpansionTile(
                            title: Text("Changes to this Privacy Policy ",
                                style: Theme.of(context).textTheme.headline4),
                            children: [
                              Container(
                                color: Theme.of(context).colorScheme.outline,
                                child: ListTile(
                                  title: Text(
                                      "We may update our privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page.\nYou are advised to review this privacy policy periodically for any changes. Changes to this privacy policy are effective when they are posted on this page.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                ),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
