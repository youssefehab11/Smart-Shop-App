// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ProviderController extends ChangeNotifier{

  List<String> _savedItemsNames = [];
  List<String> get savedItemsNames => _savedItemsNames; 
  List<String> _savedItemsImages = [];
  List<String> get savedItemsImages => _savedItemsImages; 
  var counter;
  var budget = 0.0 ;
  String subCategoryTitle = "";
  String subCategoryId = "";
  String category = "";
  String categoryId = "";
  String itemId = "";
  List items = [];
  List usedItems = [];
  List selectedCategoryBackGroundColor = [];
  List selectedCategoryLableColor = [];

  int flag = 0;

  String itemName = "";
  List itemImages = [];
  String stringItemPrice = "";
  double doubleItemPrice = 0;
  String itemDescription = "";
  int itemQuantity = 0;
  double avgItemRate = 0;
  List itemRates = [];
  int totalReviews = 0;
  int numberOfItemImages = 0;
  int itemDiscount = 0;
  double priceOfDiscount = 0.00;
  int itemDefaultQuantity = 0;
  int itemSales = 0;

  int defaultQuantity = 1;
  int numberOfCartItems = 0;
  List cartItems = [];

  late CameraPosition kGooglePlex;
  var lat;
  var long;
  var currentLocation;

  String cardNumber ="";
  String expiryDate ="";
  String cardHolderName ="";
  String cvvCode ="";

  double subtotal = 0;
  bool customAddressFlag = false;

  List similarItemsNames =[];
  List similarSubcategoriesNames = [];
  List similarSubcategoriesIds = [];
  List similarItemsIds = [];
  List similarItemsData = [];

  List viewedItems = [];
  List recommendedItemsNames = [];
  List recommendedSubcategoriesNames = [];
  List recommendedSubcategoriesIds = [];
  List recommendedItemsIds = [];
  List recommendedItemsData = [];
  List recommendedItemsInFireBase = [];

  String recommendedSubCategoryName = "";
  String recommendedSubCategoryId = "";
  String recommendedItemId = "";

  var connectivtyResult;

  String subCategoryNameForBudgetRecommendation = "";
  List budgetRecommendation = [];

  String topSellingItemId = "";

  String cartItemSubCategoryName = "";
  String cartItemSubCategoryId = "";
  String cartItemId = "";
  String cartItemIdInTopSelling = "";
  List updateSalesViewedList = []; 

  List recommendedForYou =[];

  
  

  void makeListItemName(List checked,List subCategory){
    for(int i = 0; i < checked.length; i++ ){
      if(checked[i] == true){
        _savedItemsNames.add(subCategory[i]['Item Name']);
                          
      }
    }
    _savedItemsNames = _savedItemsNames.toSet().toList();
    counter = _savedItemsNames.length;
    notifyListeners();
  }
  void makeListItemImage(List checked,List subCategory){
    for(int i = 0; i < checked.length; i++ ){
      if(checked[i] == true){
        _savedItemsImages.add(subCategory[i]['Image']);
                          
      }
    }
    _savedItemsImages = _savedItemsImages.toSet().toList(); 
    notifyListeners();
  }
  void deleteItem(int index){
    _savedItemsNames.removeAt(index);
    _savedItemsImages.removeAt(index);
    notifyListeners();
  }
  void clearList(){
    _savedItemsNames.clear();
    notifyListeners();
  }
  saveValue(double value){
    if(value == 0){
      budget = 0;
    }
    else{
      budget = value;
    }
    notifyListeners();
  }
  getCategoryId(String category)async{
  CollectionReference collectionReference = FirebaseFirestore.instance.collection("Categories");
  await collectionReference.where("CategoryName" ,isEqualTo: category).get().then((value) {
    for (var element in value.docs) {
      categoryId = element.id;
    } 
  },);
}
  getSubCategoryId(String subCategory)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList");
    await collectionReference.where("SubCategory",isEqualTo: subCategory).get().then((value) {
      for (var element in value.docs) {
          subCategoryId = element.id;
      }
      getItems();
    });
  }
  getItemId(String name)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList").doc(subCategoryId).collection("Items");
    await collectionReference.where("Item Name",isEqualTo: name).get().then((value) {
      for (var element in value.docs) {
          itemId = element.id;
      }
      getItemDetail();
    });
  }
  getItemDetail()async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("ProductsList").doc(subCategoryId).collection("Items").doc(itemId);
    await documentReference.get().then((value) {
      itemName = value.get("Item Name");
      itemDescription = value.get("Description").toString();
      stringItemPrice = value.get("Price").toString();
      itemSales = value.get("Sales");
      itemDefaultQuantity = value.get("Default Quantity");
      itemQuantity = value.get("Quantity");
      itemImages = value.get("Item Images");
      numberOfItemImages = itemImages.length;
      itemRates = value.get("Rates");
      totalReviews = (itemRates[0] + itemRates[1] + itemRates[2] + itemRates[3] + itemRates[4]);
      avgItemRate = (itemRates[0]*1 + itemRates[1]*2 + itemRates[2]*3 + itemRates[3]*4 + itemRates[4]*5)/totalReviews;
      itemDiscount = value.get("Discount");
      doubleItemPrice = value.get("Price")+0.00;
      priceOfDiscount = double.parse(( doubleItemPrice - (doubleItemPrice * itemDiscount/100)).toStringAsFixed(2));
    });
  } 
  Future<List> getSimilarItems(String itemName)async{
    List x = [];
    var url = Uri.https('smartapplication.pythonanywhere.com', '/recommend/10/$itemName');
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    x.addAll(responseBody);
    print("====================== Also Buy ==============================");
    print(x);
    return x;
  }
  Future<List> getRecommendedItems(String itemName)async{
    List x = [];
    var url = Uri.https('smartapplication.pythonanywhere.com', '/recommendforyou/10/$itemName');
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    x.addAll(responseBody);
    print("====================== Recommended Items ==============================");
    print(x);
    return x;
    
  }

  getItems()async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList").doc(subCategoryId).collection("Items");
    await collectionReference.get().then((value) {
      for (var element in value.docs) {
        items.add(element.data());
      }
    });
  }
   getPosition()async{
    currentLocation = await Geolocator.getCurrentPosition().then((value) => value);
    print(currentLocation.latitude);
    print(currentLocation.longitude);
  } 

  getSimilarSubCategoriesNames(String SimilarItemName)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("SearchList");
    await collectionReference.where("ProductName" ,isEqualTo: SimilarItemName).get().then((value){
      for (var element in value.docs) {
        similarSubcategoriesNames.add(element["SubCategoryName"]);
      }
    });
  }

  getSimilarSubCategoriesIds(String SimilarSubcategoryName)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList");
    await collectionReference.where("SubCategory" ,isEqualTo: SimilarSubcategoryName).get().then((value){
      for (var element in value.docs) {
        similarSubcategoriesIds.add(element.id);
      }
    });
  }

  getSimilarItemsIds(String similarSubcategoryId, String SimilarItemName)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList").doc(similarSubcategoryId).collection("Items");
    await collectionReference.where("Item Name",isEqualTo: SimilarItemName).get().then((value) {
      for (var element in value.docs) {
        similarItemsIds.add(element.id);
      }
    });
  }
  getSimilarItemsData(String similarSubcategoryId, String similarItemsId)async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("ProductsList").doc(similarSubcategoryId).collection("Items").doc(similarItemsId);
    await documentReference.get().then((value){
      similarItemsData.add(value.data());
    });
  }

  getRecommendedSubCategoriesNames(String recommendedItemName)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("SearchList");
    await collectionReference.where("ProductName" ,isEqualTo: recommendedItemName).get().then((value){
      for (var element in value.docs) {
        recommendedSubcategoriesNames.add(element["SubCategoryName"]);
      }
    });
  }

  getRecommendedSubCategoriesIds(String recommendedSubcategoryName)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList");
    await collectionReference.where("SubCategory" ,isEqualTo: recommendedSubcategoryName).get().then((value){
      for (var element in value.docs) {
        recommendedSubcategoriesIds.add(element.id);
      }
    });
  }

  getRecommendedItemsIds(String recommendedSubcategoryId, String recommendedItemName)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList").doc(recommendedSubcategoryId).collection("Items");
    await collectionReference.where("Item Name",isEqualTo: recommendedItemName).get().then((value) {
      for (var element in value.docs) {
        recommendedItemsIds.add(element.id);
      }
    });
  }
  getRecommendedItemsData(String recommendedSubcategoryId, String recommendedItemsId)async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("ProductsList").doc(recommendedSubcategoryId).collection("Items").doc(recommendedItemsId);
    await documentReference.get().then((value){
      recommendedItemsData.add(value.data());
    });
  }
  
  setRecommendedItems(List rec)async{
    var user = FirebaseAuth.instance.currentUser;
    DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    recommendedItemsInFireBase = await userref.get().then((value) => value.get("Viewed Items"));
    for(int i = 0; i < rec.length; i++){
    if(recommendedItemsInFireBase.length == 20){
          recommendedItemsInFireBase.removeAt(recommendedItemsInFireBase.length-1);
        
        if(!recommendedItemsInFireBase.any((element) => element["Item Name"] == rec[i]["Item Name"])){
            recommendedItemsInFireBase.insert(0, rec[i]);
            await userref.update ({
        "Viewed Items": recommendedItemsInFireBase
      });
        }
      
    }
    else{
      if(!recommendedItemsInFireBase.any((element) => element["Item Name"] == rec[i]["Item Name"])){
            recommendedItemsInFireBase.insert(0, rec[i]);
            await userref.update ({
        "Viewed Items": recommendedItemsInFireBase
      });
        }
    }
    }
  }

  getRecommendedSubCategoryName(String name)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("SearchList");
    await collectionReference.where("ProductName",isEqualTo: name).get().then((value){
       for (var element in value.docs) {
        recommendedSubCategoryName = element["SubCategoryName"];
       }
    });
  }
  
  getRecommendedSubCategoryId(String name)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList");
    await collectionReference.where("SubCategory",isEqualTo: name).get().then((value) {
      for (var element in value.docs) {
          subCategoryId = element.id;
      }
    });
  }
  getRecommendedItemId()async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList").doc(subCategoryId).collection("Items");
    await collectionReference.where("Item Name",isEqualTo: itemName).get().then((value) {
      for (var element in value.docs) {
          itemId = element.id;
      }
    });
  }
  checkConnectivity()async{
    connectivtyResult = await Connectivity().checkConnectivity(); 
  }

  getSubCategoryNameForBudgetRecommendation(String name)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("SearchList");
    await collectionReference.where("ProductName",isEqualTo: name).get().then((value){
       for (var element in value.docs) {
        subCategoryNameForBudgetRecommendation = element["SubCategoryName"];
       }
    });
  }
  getSubCategoryIdForBudgetRecommenadtion(String subCategory)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList");
    await collectionReference.where("SubCategory",isEqualTo: subCategory).get().then((value) {
      for (var element in value.docs) {
          subCategoryId = element.id;
      }
    });
  }
  getTopSellingItemId(String name)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("TopSelling");
    await collectionReference.where("Item Name",isEqualTo: name).get().then((value) {
      for (var element in value.docs) {
          topSellingItemId = element.id;
      }
    });
    collectionReference.doc(topSellingItemId).delete();
  }

  getCartItemSubCategoryName(String name ,int i)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("SearchList");
    await collectionReference.where("ProductName",isEqualTo: name).get().then((value) {
      for (var element in value.docs) {
          cartItemSubCategoryName = element["SubCategoryName"];
      }
    });
    print(cartItemSubCategoryName);
    getCartItemSubCategoryId(cartItemSubCategoryName,i);
  }

  getCartItemSubCategoryId(String name, int i)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList");
    await collectionReference.where("SubCategory",isEqualTo: name).get().then((value) {
      for (var element in value.docs) {
          cartItemSubCategoryId = element.id;
      }
    });
    print(cartItemSubCategoryId);
    getCartItemId(i);
  }

  getCartItemId(int i)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList").doc(cartItemSubCategoryId).collection("Items");
    await collectionReference.where("Item Name",isEqualTo: cartItems[i]["Item Name"]).get().then((value) {
      for (var element in value.docs) {
          cartItemId = element.id;
      }
    });
    print(cartItemId);
    updateSales(i);
  }

  updateSales(int i)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("ProductsList");
    DocumentReference documentReference = FirebaseFirestore.instance.collection("TopSelling").doc();
    var user = FirebaseAuth.instance.currentUser;
    DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    await collectionReference.doc(cartItemSubCategoryId).collection("Items").doc(cartItemId).update({
      "Sales": cartItems[i]["Sales"] + cartItems[i]["Selected Quantity"],
      "Quantity": cartItems[i]["Total Quantity"] - cartItems[i]["Selected Quantity"],
    });

    //if(cartItems[i]["Sales"])

    //cartItems[i]["Sales"] = cartItems[i]["Sales"] + cartItems[i]["Selected Quantity"];
    //cartItems[i]["Total Quantity"] = cartItems[i]["Total Quantity"] - cartItems[i]["Selected Quantity"];
    updateSalesViewedList = await userref.get().then((value) => value.get("Viewed Items"));
    for(int j = 0; j < updateSalesViewedList.length; j++){
      if(updateSalesViewedList[j]["Item Name"] == cartItems[i]["Item Name"]){
        updateSalesViewedList[j]["Sales"] = cartItems[i]["Sales"] + cartItems[i]["Selected Quantity"];
        updateSalesViewedList[j]["Quantity"] = cartItems[i]["Total Quantity"] - cartItems[i]["Selected Quantity"];
        await userref.update ({"Viewed Items": updateSalesViewedList
        });
      }
    }
    
     if((cartItems[i]["Sales"]+ cartItems[i]["Selected Quantity"])/cartItems[i]["Default Quantity"]*100 > 65){
      await documentReference.set({
        "Item Name":cartItems[i]["Item Name"],
        "Description":cartItems[i]["Description"],
        "Item Images":cartItems[i]["Item Images"],
        "Rates":cartItems[i]["Rates"],
        "Sales":cartItems[i]["Sales"]+cartItems[i]["Selected Quantity"],
        "Default Quantity":cartItems[i]["Default Quantity"],
        "Discount":cartItems[i]["Discount"],
        "Image":cartItems[i]["Image"],
        "Price":cartItems[i]["Price"]/cartItems[i]["Selected Quantity"],
        "Quantity":cartItems[i]["Total Quantity"]-cartItems[i]["Selected Quantity"],
      });
      print("done");
    } 
    if(i+1 == cartItems.length){
      cartItems.clear();                    
    }
    
  }
  getCartItemIdInTopSelling(int i)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("TopSelling");
    await collectionReference.where("Item Name",isEqualTo: cartItems[i]["Item Name"]).get().then((value) {
      for (var element in value.docs) {
          cartItemIdInTopSelling = element.id;
      }
    });
    print(cartItemIdInTopSelling);
    if(cartItemIdInTopSelling != ""){
      updateSalesInTopSelling(i);
    }
  }
  updateSalesInTopSelling(int i)async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("TopSelling");
    await collectionReference.doc(cartItemIdInTopSelling).update({
      "Sales": cartItems[i]["Sales"] + cartItems[i]["Selected Quantity"],
      "Quantity": cartItems[i]["Total Quantity"] - cartItems[i]["Selected Quantity"],});
  }

  checkRecommendedForYouAvailability()async{
    var user = FirebaseAuth.instance.currentUser;
    DocumentReference userref = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    recommendedForYou = await userref.get().then((value) => value.get("Viewed Items"));
  }


  static ProviderController of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<ProviderController>(
      context,
      listen: listen,
    );
  }

  
  }