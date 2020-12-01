import 'package:flutter/material.dart';
import 'package:groplan/pages/add.dart';
import 'package:groplan/pages/calendar.dart';
import 'package:groplan/pages/lists.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var prefSearchKey = "userList";
  var list;
  int _selectedIndex = 0;
  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        if (list == null) {
          getLists();
          return CircularProgressIndicator();
        } else {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return ListsPage(list);
            },
          ));
        }
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return CalendarPage();
          },
        ));
      }
    });
  }

  Future getLists() async {
    final SharedPreferences prefs = await _prefs;
    list = await prefs.getStringList(prefSearchKey);
    if (list == null) {
      list = List<String>();
      list.add("Tea");
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    getLists().then((value) {
      setState(() {
        this.list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GroPlan"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 70,
          ),
          Image(
            image: AssetImage('images/homeImg.png'),
          ),
          Text(
            "No Reminders to Show",
            style: TextStyle(fontSize: 28),
          ),
          Container(
            width: 160,
            child: Text(
              "Click the + button to add new Items now!",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          )
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF72C077),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return AddPage();
            },
          ));
        },
        child: Icon(
          Icons.add,
          size: 40.0,
          color: Color(0xFFFFFFFF),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color(0xFF72C077),
          unselectedFontSize: 14.0,
          selectedFontSize: 14.0,
          selectedItemColor: Color(0xFF72C077),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                ),
                title: Text("My Lists")),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), title: Text("My Calendar"))
          ]),
    );
  }
}
