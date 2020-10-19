import 'package:flutter/material.dart';

class ItemsAddPage extends StatefulWidget {
  String name;
  ItemsAddPage(String name) {
    this.name = name;
  }
  @override
  _ItemsAddPageState createState() => _ItemsAddPageState();
}

class _ItemsAddPageState extends State<ItemsAddPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = new TextEditingController();
  List<dynamic> _list;
  bool _isSearching;
  // ignore: unused_field
  String _searchText = "";
  List searchresult = new List();

  _ItemsAddPageState() {
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
            Container(
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
            Flexible(
                child: searchresult.length != 0 ||
                        _searchController.text.isNotEmpty
                    ? new ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = searchresult[index];
                          return new Container(
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
                              ));
                        },
                      )
                    : new ListView.builder(
                        shrinkWrap: true,
                        itemCount: _list.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = _list[index];
                          return new Container(
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
                              ));
                        },
                      )),
          ],
        ));
  }
}
