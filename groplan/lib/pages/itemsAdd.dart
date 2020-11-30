import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ItemsAddPage extends StatefulWidget {
  String name;
  ItemsAddPage(String name) {
    this.name = name;
  }
  @override
  _ItemsAddPageState createState() => _ItemsAddPageState(name);
}

class _ItemsAddPageState extends State<ItemsAddPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  // final _auth = FirebaseAuth.instance;
  // final _result = await _auth.signInAnonymously();

  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = new TextEditingController();
  List<dynamic> _list;
  final TextEditingController quantityController = new TextEditingController();
  final TextEditingController durationController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  String name;
  bool _isSearching;
  String itemName;
  String itemQuantity;
  String itemDuration;
  // ignore: unused_field
  String _searchText = "";
  List searchresult = new List();
  var groceryMap = {
    "fruits": [
      "Oranges",
      "Apples",
      "Strawberry",
      "Banana",
      "Blueberry",
      "Pineapple",
      "Mosambi",
      "Watermelon",
      "Chickoo",
      "Cherry"
    ],
    "vegetables": [
      "Cabbage",
      "Potatoes",
      "Cauliflower",
      "Chillies",
      "Brinjal",
      "Tomatoes"
    ],
    "dairy": ["Milk", "Cheese", "Butter", "Yogurt", "Ghee"],
    "bakery": ["Bread", "Burger Buns", "Pizza Base", "Cake"],
    "packaged": ["Biscuits", "Wafers", "Noodles"],
    "refrigerated": ["Water", "Juice", "Ice Cream"],
    "essentials": [
      "Rice",
      "Dal",
      "Wheat Flour",
      "Refined Flour",
      "Salt",
      "Sugar"
    ],
    "oils": [
      "Sunflower Oil",
      "Groundnut Oil",
      "Olive Oil",
      "Red Chilli Sauce",
      "Green Chilli Sauce",
      "Soy sauce"
    ],
    "household": [
      "Detergent",
      "Mop",
      "Handwash",
      "Dish Washer",
      "Soap",
      "Scrub Sponge"
    ],
    "spices": [
      "Red Chilli Powder",
      "Haldi Powder",
      "Garam masala",
      "Dhaniya Powder",
      "Jeera Powder"
    ]
  };
  _ItemsAddPageState(name) {
    this.name = name;
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchController.text;
        });
      }
    });
  }

  void search(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }

  String getName(bool customFlag, String nameOfItem) {
    if (customFlag == true) {
      return nameController.text;
    } else {
      return nameOfItem;
    }
  }

  void alertMethod(String nameOfItem, bool customFlag) {
    Alert(
        closeFunction: () => Navigator.pop(context),
        context: context,
        title: nameOfItem,
        content: Column(
          children: <Widget>[
            Divider(),
            if (customFlag == true)
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.turned_in),
                  labelText: 'Name',
                ),
              ),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(
                icon: Icon(Icons.shopping_basket),
                labelText: 'Quantity',
              ),
            ),
            TextField(
              controller: durationController,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.schedule),
                labelText: 'Lasts For',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Color(0xffFDD76E),
            onPressed: () {
              itemName = getName(customFlag, nameOfItem);
              itemQuantity = quantityController.text;
              itemDuration = durationController.text;

              Navigator.pop(context);
              _showNotification();
            },
            child: Text(
              "Add",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        ]).show();
  }

  void _showNotification() async {
    await _demoNotification();
  }

  Future<void> _demoNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.max,
        priority: Priority.high,
        channelShowBadge: true);
    var scheduledNotificationDateTime =
        new DateTime.now().add(Duration(seconds: 10));
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0, 'Hello', 'reminder',
        scheduledNotificationDateTime, platformChannelSpecifics,
        payload: 'test payload');
  }

  void initState() {
    super.initState();
    _isSearching = false;
    values();
    initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification Payload: $payload');
    }
    // await Navigator.push(context,
    // new MaterialPageRoute(builder: (context)=>);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('OK'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    // await Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                  },
                )
              ],
            ));
  }

  void values() async {
    var myList = groceryMap[name];
    // var myList;
    // firestoreInstance
    //     .collection('groceries')
    //     .doc(name)
    //     .get()
    //     .then((value) async => myList = await value.data()['names']);
    // print(myList);

    _list = List();
    for (var i = 0; i < (myList.length); i++) {
      _list.add(myList[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: const Text('Add Grocery'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                ),
                controller: _searchController,
                onChanged: search,
              ),
            ),
            GestureDetector(
              onTap: () {
                alertMethod("Custom", true);
              },
              child: Container(
                  height: 80,
                  padding: EdgeInsets.all(20),
                  color: Color(0x5072C077),
                  child: Row(
                    children: [
                      Text(
                        "Custom",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Icon(Icons.add, color: Color(0xFF72C077), size: 40)
                    ],
                  )),
            ),
            Flexible(
                child: searchresult.length != 0 ||
                        _searchController.text.isNotEmpty
                    ? new ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = searchresult[index];
                          return new GestureDetector(
                            onTap: () {
                              alertMethod(listData.toString(), false);
                            },
                            child: Container(
                                height: 80,
                                padding: EdgeInsets.all(20),
                                color: Color(0xffffffff),
                                child: Row(
                                  children: [
                                    Text(
                                      listData.toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Spacer(),
                                    Icon(Icons.add,
                                        color: Color(0xFF72C077), size: 40)
                                  ],
                                )),
                          );
                        },
                      )
                    : new ListView.builder(
                        shrinkWrap: true,
                        itemCount: _list.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = _list[index];
                          return new GestureDetector(
                              onTap: () {
                                alertMethod(listData.toString(), false);
                              },
                              child: Container(
                                  height: 80,
                                  padding: EdgeInsets.all(20),
                                  color: Color(0xffffffff),
                                  child: Row(
                                    children: [
                                      Text(
                                        listData.toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.add,
                                        color: Color(0xFF72C077),
                                        size: 40,
                                      )
                                    ],
                                  )));
                        },
                      )),
          ],
        ));
  }
}
