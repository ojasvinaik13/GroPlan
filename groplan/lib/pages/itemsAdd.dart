import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class ItemsAddPage extends StatefulWidget {
  String name;
  Map<String, List> groceryMap;
  ItemsAddPage(String name, Map<String, List> groceryMap) {
    this.name = name;
    this.groceryMap = groceryMap;
  }
  @override
  _ItemsAddPageState createState() => _ItemsAddPageState(name, groceryMap);
}

class _ItemsAddPageState extends State<ItemsAddPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = new TextEditingController();
  List<dynamic> _list = new List<dynamic>();
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

  _ItemsAddPageState(name, groceryMap) {
    this.name = name;
    this._list = groceryMap[name];
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
              _showNotification(itemName, itemDuration);
              nameController.clear();
              quantityController.clear();
              durationController.clear();
              Navigator.pop(context);
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

  void _showNotification(String name, String duration) async {
    await _demoNotification(name, duration);
  }

  Future<void> _demoNotification(String name, String duration) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "channelId", "channelName", "channelDescription",
        importance: Importance.max,
        priority: Priority.high,
        channelShowBadge: true);
    var scheduledNotificationDateTime =
        new DateTime.now().add(Duration(seconds: int.parse(duration)));
    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
        0,
        'GroPlan Reminder',
        'You might be running out of ' + name + '. Stock up now!',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: 'test payload');
  }

  initState() {
    super.initState();
    _isSearching = false;
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
