
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduationproject/provider_controller.dart';

class CreditCard extends StatefulWidget {
  const CreditCard({super.key});
  @override
  State<CreditCard> createState() => _CreditCard();
}
class _CreditCard extends State<CreditCard> {

  bool isCvvFocused = false;

  String cardNumber ="";
  String expiryDate ="";
  String cardHolderName ="";
  String cvvCode ="";
  String showBackView ="";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = ProviderController.of(context);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Credit Card",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [IconButton(onPressed: () {
            if(formKey.currentState!.validate()){
              provider.cardNumber = cardNumber;
              provider.expiryDate = expiryDate;
              provider.cardHolderName = cardHolderName;
              provider.cvvCode = cvvCode;
              Fluttertoast.showToast(
                msg: "Successfully saved",
                backgroundColor: Colors.black54,
                toastLength:Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM
              ); 
              Navigator.of(context).pop();
              }
              
              
          }, icon: const Icon(Icons.check)),]
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
          const SizedBox(height: 30,),
          CreditCardWidget(
                  chipColor: const Color.fromARGB(255, 222, 160, 52),
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: 'Axis Bank',
                  frontCardBorder:Border.all(color: const Color.fromARGB(255, 17, 91, 27)),
                  backCardBorder:Border.all(color: const Color.fromARGB(255, 17, 91, 27)),
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor:const Color.fromARGB(255, 17, 91, 27),
                   backgroundImage:'assets/images/card_bg.jpg' ,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange:
                      (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: [
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/images/Master Card.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                SingleChildScrollView(
                    child: CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          themeColor: Colors.grey,
                          textColor: Theme.of(context).primaryColor,
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            hintStyle: const TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),
                            labelStyle: const TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                                width: 2.0,),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                                width: 2.0,),),
                          ),
                          expiryDateDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),
                            labelStyle: const TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                                width: 2.0,),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                                width: 2.0,),),
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),
                            labelStyle: const TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                                width: 2.0,),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                                width: 2.0,),),
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),
                            labelStyle: const TextStyle(color: Color.fromRGBO(126, 126, 126, 1) ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                                width: 2.0,),),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.7),
                                width: 2.0,),),
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),
                  
                ),
               
        ],),
    );
  }
  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
