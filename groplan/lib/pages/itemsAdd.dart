import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ItemsAddPage extends StatefulWidget {
  String name;
  ItemsAddPage(String name) {
    this.name = name;
  }
  @override
  _ItemsAddPageState createState() => _ItemsAddPageState(name);
}

class _ItemsAddPageState extends State<ItemsAddPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = new TextEditingController();
  List<dynamic> _list;
  String name;
  bool _isSearching;
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
                decoration: InputDecoration(
                  icon: Icon(Icons.turned_in),
                  labelText: 'Name',
                ),
              ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.shopping_basket),
                labelText: 'Quantity',
              ),
            ),
            TextField(
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
            onPressed: () => Navigator.pop(context),
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

  void initState() {
    super.initState();
    _isSearching = false;
    values();
  }

  void values() {
    var myList = groceryMap[name];
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
