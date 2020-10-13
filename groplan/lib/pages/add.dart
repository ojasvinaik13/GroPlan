import 'package:flutter/material.dart';
import 'package:groplan/components/category_card.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = new TextEditingController();
  List<dynamic> _list;
  bool _isSearching;
  // ignore: unused_field
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
  }

  // void _handleSearchStart() {
  //   setState(() {
  //     _isSearching = true;
  //   });
  // }

  // void _handleSearchEnd() {
  //   setState(() {
  //     _searchController.clear();
  //   });
  // }

  void values() {
    _list = List();
    _list.add("Apples");
    _list.add("Bananas");
    _list.add("Grapes");
    _list.add("Blueberry");
    _list.add("Strawberry");
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
            TextField(
              controller: _searchController,
              onChanged: search,
            ),

            // Flexible(
            //     child: searchresult.length != 0 ||
            //             _searchController.text.isNotEmpty
            //         ? new ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: searchresult.length,
            //             itemBuilder: (BuildContext context, int index) {
            //               String listData = searchresult[index];
            //               return new ListTile(
            //                 title: new Text(listData.toString()),
            //               );
            //             },
            //           )
            //         : new ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: _list.length,
            //             itemBuilder: (BuildContext context, int index) {
            //               String listData = _list[index];
            //               return new ListTile(
            //                 title: new Text(listData.toString()),
            //               );
            //             },
            //           )),
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                    child: CategoryCard(
                  titleText: Text(
                    "Fruits",
                    style: TextStyle(color: Colors.white),
                  ),
                  imgname: "images/fruits.jpg",
                )),
                Expanded(
                    child: CategoryCard(
                  titleText:
                      Text("Fruits", style: TextStyle(color: Colors.white)),
                  imgname: "images/fruits.jpg",
                )),
              ],
            )),
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                    child: CategoryCard(
                  titleText:
                      Text("Fruits", style: TextStyle(color: Colors.white)),
                  imgname: "images/fruits.jpg",
                )),
                Expanded(
                    child: CategoryCard(
                  titleText:
                      Text("Fruits", style: TextStyle(color: Colors.white)),
                  imgname: "images/fruits.jpg",
                )),
              ],
            )),
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                    child: CategoryCard(
                  titleText:
                      Text("Fruits", style: TextStyle(color: Colors.white)),
                  imgname: "images/fruits.jpg",
                )),
                Expanded(
                    child: CategoryCard(
                  titleText: Text(
                    "Fruits",
                    style: TextStyle(color: Colors.white),
                  ),
                  imgname: "images/fruits.jpg",
                )),
              ],
            )),
          ],
        ));
  }
}
