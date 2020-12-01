import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flushbar/flushbar.dart';

class ListsPage extends StatefulWidget {
  List list;
  GlobalKey<ScaffoldState> _scaffoldKey;
  ListsPage(List list, GlobalKey<ScaffoldState> _scaffoldKey) {
    this.list = list;
    this._scaffoldKey = _scaffoldKey;
  }

  @override
  _ListsPageState createState() => _ListsPageState(list, _scaffoldKey);
}

class _ListsPageState extends State<ListsPage> {
  var list;
  GlobalKey<ScaffoldState> _scaffoldKey;
  _ListsPageState(list, _scaffoldKey) {
    this.list = list;
    this._scaffoldKey = _scaffoldKey;
  }
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var prefSearchKey = "userList";

  Widget buildList() {
    if (list == null)
      return Text("No Items added yet!");
    else {
      return new ListView.builder(itemBuilder: (context, index) {
        if (index < list.length) {
          return _buildShopItem(list[index], index);
        }
      });
    }
  }

  void _addShopItem(String item) async {
    setState(() {
      if (item.length > 0) {
        list.add(item);
        final SharedPreferences prefs = _prefs as SharedPreferences;
        prefs.setStringList(prefSearchKey, list);
      }
    });
  }

  Widget _buildShopItem(String toshopText, int index) {
    return new Dismissible(
      key: Key(toshopText),
      background: Container(color: Colors.redAccent[700]),
      direction: DismissDirection.endToStart,
      child: Column(
        children: [
          ListTile(
            title: new Text(toshopText),
            tileColor: Color(0x5072C077),
          ),
          Divider(
            height: 1,
            thickness: 2,
          ),
        ],
      ),
      onDismissed: (direction) {
        setState(() {
          list.removeAt(index);
        });
        Flushbar(
          icon: Icon(
            Icons.delete,
            color: Color(0xFF72C077),
          ),
          duration: Duration(seconds: 4),
          message: toshopText + " removed.",
        ).show(context);
      },
    );
  }

  void initState() {
    super.initState();
  }

  void _pushAddToShopScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
              title: new Text(
            'Add a new item to your Grocery List',
            style: TextStyle(fontSize: 15),
          )),
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
            title: const Text('Your Shopping List'),
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
