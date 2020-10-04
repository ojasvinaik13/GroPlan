import 'package:flutter/material.dart';
import 'package:groplan/pages/calendar.dart';
import 'package:groplan/pages/lists.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return ListsPage();
          },
        ));
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return CalendarPage();
          },
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GroPlan"),
      ),
      body: Text("Home"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF72C077),
        onPressed: () {},
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
