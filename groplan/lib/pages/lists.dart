import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ListsPage extends StatefulWidget {
  List list;
  ListsPage(List list) {
    this.list = list;
  }

  @override
  _ListsPageState createState() => _ListsPageState(list);
}

class _ListsPageState extends State<ListsPage> {
  var list;
  _ListsPageState(list) {
    this.list = list;
    print(this.list);
  }
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var prefSearchKey = "userList";

  Widget buildList() {
    if (list == null)
      return Text("No Items added yet!");
    else {
      return new ListView.builder(itemBuilder: (context, index) {
        if (index < list.length) {
          return _buildShopItem(list[index]);
        }
      });
    }
  }

  void _addShopItem(String item) {
    setState(() {
      if (item.length > 0) {
        list.add(item);
      }
    });
  }

  Widget _buildShopItem(String toshopText) {
    return new ListTile(title: new Text(toshopText));
  }

  void initState() {
    super.initState();
  }

  void _pushAddToShopScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
              title: new Text('Add a new item to your Grocery List')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addShopItem(val);
              Navigator.pop(context);
            },
            decoration: new InputDecoration(
                hintText: 'Enter something to shop...',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  Future<bool> _onBackPressed() async {
    final SharedPreferences prefs = await _prefs as SharedPreferences;
    await prefs
        .setStringList(prefSearchKey, list)
        .then((value) => Navigator.of(context).pop(true));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
          appBar: AppBar(
            title: const Text('Lists'),
          ),
          body: buildList(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF72C077),
            onPressed: _pushAddToShopScreen,
            child: Icon(
              Icons.add,
              size: 40.0,
              color: Color(0xFFFFFFFF),
            ),
          )),
    );
  }
}
