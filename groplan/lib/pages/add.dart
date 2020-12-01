import 'package:flutter/material.dart';
import 'package:groplan/components/category_card.dart';
import 'package:groplan/pages/itemsAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final firestoreInstance = FirebaseFirestore.instance;
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = new TextEditingController();
  Map<String, List> groceryMap = new Map<String, List>();
  List<dynamic> _list;
  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();

  _AddPageState() {
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

  void initState() {
    super.initState();
    _isSearching = false;
    values();
    getAllValues();
  }

  void values() {
    _list = List();
    _list.add("Fruits");
    _list.add("Vegetables");
    _list.add("Dairy");
    _list.add("Bakery");
    _list.add("Packaged");
    _list.add("Refrigerated");
    _list.add("Essentials");
    _list.add("Oils and Sauces");
    _list.add("Household Items");
    _list.add("Spices");
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
            Flexible(
                child: searchresult.length != 0 ||
                        _searchController.text.isNotEmpty
                    ? new GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: searchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = searchresult[index];
                          List<String> name =
                              (listData.toString().toLowerCase()).split(" ");
                          String imgname = name[0];
                          return new CategoryCard(
                            onClick: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ItemsAddPage(imgname, groceryMap);
                                },
                              ));
                            },
                            imgname: "images/$imgname.jpg",
                            titleText: new Text(
                              listData.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      )
                    : new GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: _list.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = _list[index];
                          List<String> name =
                              (listData.toString().toLowerCase()).split(" ");
                          String imgname = name[0];
                          return new CategoryCard(
                            onClick: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ItemsAddPage(imgname, groceryMap);
                                },
                              ));
                            },
                            imgname: "images/$imgname.jpg",
                            titleText: new Text(
                              listData.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      )),
          ],
        ));
  }

  void getAllValues() async {
    await getValues();
  }

  Future<void> getValues() async {
    _list.forEach((element) {
      element = (element.toString().toLowerCase()).split(" ")[0];
      firestoreInstance
          .collection('groceries')
          .doc(element)
          .get()
          .then((querySnapshot) {
        groceryMap[element] = querySnapshot.data()['names'];
      });
    });
  }
}
